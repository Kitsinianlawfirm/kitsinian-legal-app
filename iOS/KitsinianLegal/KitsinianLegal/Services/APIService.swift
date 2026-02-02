//
//  APIService.swift
//  KitsinianLegal
//

import Foundation

class APIService {
    static let shared = APIService()

    // Configure this with your Render backend URL
    private let baseURL = "https://kitsinian-legal-api.onrender.com/api"

    private init() {}

    // MARK: - Submit Lead
    func submitLead(_ lead: Lead) async throws {
        let url = URL(string: "\(baseURL)/leads")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(lead)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            // Success
            return
        case 400:
            throw APIError.badRequest
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.unknown
        }
    }

    // MARK: - Get Resources (future enhancement)
    func getResources() async throws -> [LegalResource] {
        // Currently using bundled resources
        // This can be extended to fetch from API
        return LegalResource.allResources
    }
}

// MARK: - API Errors
enum APIError: LocalizedError {
    case invalidResponse
    case badRequest
    case serverError
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .badRequest:
            return "Please check your information and try again"
        case .serverError:
            return "Server error. Please try again later."
        case .unknown:
            return "An unexpected error occurred"
        }
    }
}
