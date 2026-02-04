//
//  AppConfiguration.swift
//  ClaimIt
//
//  Environment configuration and app-wide settings
//

import Foundation

// MARK: - App Environment
enum AppEnvironment: String {
    case development
    case staging
    case production

    var displayName: String {
        switch self {
        case .development: return "Development"
        case .staging: return "Staging"
        case .production: return "Production"
        }
    }
}

// MARK: - App Configuration
struct AppConfiguration {
    // MARK: - Current Environment
    static var current: AppEnvironment {
        #if DEBUG
        return .development
        #else
        // Check for TestFlight
        if isTestFlight {
            return .staging
        }
        return .production
        #endif
    }

    private static var isTestFlight: Bool {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
            return false
        }
        return appStoreReceiptURL.lastPathComponent == "sandboxReceipt"
    }

    // MARK: - API Configuration
    static var apiBaseURL: String {
        switch current {
        case .development:
            return "http://localhost:3000/api"
        case .staging:
            return "https://kitsinian-legal-api-staging.onrender.com/api"
        case .production:
            return "https://kitsinian-legal-api.onrender.com/api"
        }
    }

    static var requestTimeout: TimeInterval {
        switch current {
        case .development:
            return 60 // Longer timeout for debugging
        case .staging, .production:
            return 30
        }
    }

    // MARK: - Feature Flags
    struct Features {
        /// Enable crash detection for Accident Mode
        static var crashDetectionEnabled: Bool {
            switch current {
            case .development, .staging:
                return true
            case .production:
                return true // Enable after testing
            }
        }

        /// Enable verbose logging
        static var debugLoggingEnabled: Bool {
            switch current {
            case .development:
                return true
            case .staging, .production:
                return false
            }
        }

        /// Enable analytics tracking
        static var analyticsEnabled: Bool {
            switch current {
            case .development:
                return false
            case .staging, .production:
                return true
            }
        }

        /// Enable push notifications
        static var pushNotificationsEnabled: Bool {
            return true
        }
    }

    // MARK: - App Info
    struct AppInfo {
        static var version: String {
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        }

        static var build: String {
            Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        }

        static var fullVersion: String {
            "\(version) (\(build))"
        }

        static var bundleIdentifier: String {
            Bundle.main.bundleIdentifier ?? "com.kitsinianlawfirm.claimit"
        }
    }

    // MARK: - Contact Info
    struct Contact {
        static let firmName = "Kitsinian Law Firm, APC"
        static let firmPhone = "(818) 555-1234" // TODO: Replace with actual
        static let firmEmail = "intake@kitsinianlawfirm.com"
        static let firmWebsite = "https://kitsinianlawfirm.com"
        static let privacyPolicyURL = "https://kitsinianlawfirm.com/privacy"
        static let termsOfServiceURL = "https://kitsinianlawfirm.com/terms"
    }

    // MARK: - Timing Constants
    struct Timing {
        /// Response time promise to users (in hours)
        static let responseTimeHours = 24

        /// How often to check for case updates (in seconds)
        static let caseUpdateInterval: TimeInterval = 300 // 5 minutes

        /// Animation durations
        static let quickAnimation: TimeInterval = 0.2
        static let standardAnimation: TimeInterval = 0.3
        static let slowAnimation: TimeInterval = 0.5
    }

    // MARK: - Validation Rules
    struct Validation {
        static let minNameLength = 2
        static let maxNameLength = 100
        static let phoneDigitsRequired = 10
        static let maxDescriptionLength = 5000

        static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }

    // MARK: - Debug Helpers
    static func log(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        guard Features.debugLoggingEnabled else { return }
        let filename = (file as NSString).lastPathComponent
        print("[\(current.displayName)] \(filename):\(line) \(function) - \(message)")
    }
}

// MARK: - Convenience Extensions
extension AppConfiguration {
    /// Check if running in debug mode
    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    /// Check if running in production
    static var isProduction: Bool {
        current == .production
    }
}
