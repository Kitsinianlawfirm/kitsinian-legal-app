//
//  APIService.swift
//  ClaimIt
//
//  Secure API service with certificate pinning and retry logic
//

import Foundation
import Security
import CryptoKit

// MARK: - API Service
final class APIService: NSObject {
    static let shared = APIService()

    // MARK: - Configuration
    private var baseURL: String {
        AppConfiguration.apiBaseURL
    }

    private var timeout: TimeInterval {
        AppConfiguration.requestTimeout
    }

    // MARK: - Retry Configuration
    private let maxRetries = 3
    private let initialRetryDelay: TimeInterval = 1.0
    private let maxRetryDelay: TimeInterval = 30.0

    // MARK: - URL Session with Pinning
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForResource = timeout * 2
        configuration.waitsForConnectivity = true

        // Security headers
        configuration.httpAdditionalHeaders = [
            "X-App-Version": AppConfiguration.AppInfo.fullVersion,
            "X-Platform": "iOS",
            "X-Device-ID": KeychainService.shared.getOrCreateDeviceId()
        ]

        return URLSession(
            configuration: configuration,
            delegate: CertificatePinningDelegate.shared,
            delegateQueue: nil
        )
    }()

    private override init() {
        super.init()
    }

    // MARK: - Submit Lead
    func submitLead(_ lead: Lead) async throws {
        let url = URL(string: "\(baseURL)/leads")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = timeout

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(lead)

        // Use retry logic for submission
        let (_, response) = try await performRequestWithRetry(request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            AppConfiguration.log("Lead submitted successfully")
            return
        case 400:
            throw APIError.badRequest
        case 401:
            throw APIError.unauthorized
        case 403:
            throw APIError.forbidden
        case 404:
            throw APIError.notFound
        case 429:
            throw APIError.rateLimited
        case 500...599:
            throw APIError.serverError(code: httpResponse.statusCode)
        default:
            throw APIError.unknown(code: httpResponse.statusCode)
        }
    }

    // MARK: - Get Resources
    func getResources() async throws -> [LegalResource] {
        // Currently using bundled resources
        // This can be extended to fetch from API
        return LegalResource.allResources
    }

    // MARK: - Retry Logic with Exponential Backoff
    private func performRequestWithRetry(
        _ request: URLRequest,
        retryCount: Int = 0
    ) async throws -> (Data, URLResponse) {
        do {
            let (data, response) = try await session.data(for: request)

            // Check if we should retry based on response
            if let httpResponse = response as? HTTPURLResponse,
               shouldRetry(statusCode: httpResponse.statusCode),
               retryCount < maxRetries {
                let delay = calculateRetryDelay(attempt: retryCount)
                AppConfiguration.log("Retrying request after \(delay)s (attempt \(retryCount + 1)/\(maxRetries))")
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                return try await performRequestWithRetry(request, retryCount: retryCount + 1)
            }

            return (data, response)

        } catch let error as URLError {
            // Retry on network errors
            if isRetryableError(error), retryCount < maxRetries {
                let delay = calculateRetryDelay(attempt: retryCount)
                AppConfiguration.log("Network error, retrying after \(delay)s: \(error.localizedDescription)")
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                return try await performRequestWithRetry(request, retryCount: retryCount + 1)
            }
            throw mapURLError(error)
        }
    }

    private func shouldRetry(statusCode: Int) -> Bool {
        // Retry on server errors and rate limiting
        return statusCode == 429 || (statusCode >= 500 && statusCode < 600)
    }

    private func isRetryableError(_ error: URLError) -> Bool {
        let retryableCodes: [URLError.Code] = [
            .timedOut,
            .cannotConnectToHost,
            .networkConnectionLost,
            .notConnectedToInternet,
            .dnsLookupFailed
        ]
        return retryableCodes.contains(error.code)
    }

    private func calculateRetryDelay(attempt: Int) -> TimeInterval {
        // Exponential backoff with jitter
        let exponentialDelay = initialRetryDelay * pow(2.0, Double(attempt))
        let jitter = Double.random(in: 0...0.5) * exponentialDelay
        return min(exponentialDelay + jitter, maxRetryDelay)
    }

    private func mapURLError(_ error: URLError) -> APIError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .noConnection
        case .timedOut:
            return .timeout
        case .cancelled:
            return .cancelled
        case .secureConnectionFailed, .serverCertificateUntrusted:
            return .sslError
        default:
            return .networkError(underlying: error)
        }
    }
}

// MARK: - Certificate Pinning Delegate
final class CertificatePinningDelegate: NSObject, URLSessionDelegate {
    static let shared = CertificatePinningDelegate()

    // SHA256 hashes of expected certificate public keys
    // These should be updated with actual certificate hashes for production
    private let pinnedPublicKeyHashes: Set<String> = {
        switch AppConfiguration.current {
        case .development:
            // Skip pinning in development for localhost testing
            return []
        case .staging:
            // Staging certificate hashes (Render.com)
            return [
                // Add staging certificate hash here
                // "hash_here"
            ]
        case .production:
            // Production certificate hashes (Render.com)
            return [
                // Add production certificate hash here
                // "hash_here"
            ]
        }
    }()

    private override init() {
        super.init()
    }

    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        // Skip pinning in development or if no hashes configured
        guard AppConfiguration.current != .development,
              !pinnedPublicKeyHashes.isEmpty else {
            // Use default handling in development
            completionHandler(.performDefaultHandling, nil)
            return
        }

        // Evaluate the server's certificate chain
        var error: CFError?
        let isValid = SecTrustEvaluateWithError(serverTrust, &error)

        guard isValid else {
            AppConfiguration.log("Certificate chain validation failed: \(String(describing: error))")
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        // Extract and validate public key hash
        guard let certificateChain = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate],
              let serverCertificate = certificateChain.first else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        let serverPublicKey = SecCertificateCopyKey(serverCertificate)
        guard let publicKeyData = serverPublicKey.flatMap({ SecKeyCopyExternalRepresentation($0, nil) as Data? }) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        let publicKeyHash = sha256Hash(of: publicKeyData)

        if pinnedPublicKeyHashes.contains(publicKeyHash) {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            AppConfiguration.log("Certificate pinning failed - hash mismatch")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }

    private func sha256Hash(of data: Data) -> String {
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - API Errors
enum APIError: LocalizedError {
    case invalidResponse
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case rateLimited
    case serverError(code: Int)
    case noConnection
    case timeout
    case cancelled
    case sslError
    case networkError(underlying: Error)
    case unknown(code: Int)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .badRequest:
            return "Please check your information and try again"
        case .unauthorized:
            return "Authentication required"
        case .forbidden:
            return "Access denied"
        case .notFound:
            return "The requested resource was not found"
        case .rateLimited:
            return "Too many requests. Please wait a moment and try again."
        case .serverError(let code):
            return "Server error (\(code)). Please try again later."
        case .noConnection:
            return "No internet connection. Please check your network settings."
        case .timeout:
            return "Request timed out. Please try again."
        case .cancelled:
            return "Request was cancelled"
        case .sslError:
            return "Secure connection failed. Please ensure you're on a trusted network."
        case .networkError(let underlying):
            return "Network error: \(underlying.localizedDescription)"
        case .unknown(let code):
            return "An unexpected error occurred (code: \(code))"
        }
    }

    var isRetryable: Bool {
        switch self {
        case .noConnection, .timeout, .serverError, .rateLimited:
            return true
        default:
            return false
        }
    }
}

// MARK: - Response Models (for future use)
struct APIResponse<T: Decodable>: Decodable {
    let success: Bool
    let data: T?
    let error: APIErrorResponse?
}

struct APIErrorResponse: Decodable {
    let code: String
    let message: String
}
