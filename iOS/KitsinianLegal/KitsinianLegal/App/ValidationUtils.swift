//
//  ValidationUtils.swift
//  ClaimIt
//
//  Input validation and sanitization utilities for security
//

import Foundation

// MARK: - Input Validator
struct InputValidator {

    // MARK: - Email Validation (RFC 5322 compliant - simplified)
    static func isValidEmail(_ email: String) -> Bool {
        // More robust email regex that catches common invalid patterns
        let emailRegex = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        // Additional checks
        guard emailPredicate.evaluate(with: email) else { return false }

        // Reject consecutive dots
        if email.contains("..") { return false }

        // Reject if starts or ends with dot in local part
        let parts = email.split(separator: "@")
        guard parts.count == 2 else { return false }
        let localPart = String(parts[0])
        if localPart.hasPrefix(".") || localPart.hasSuffix(".") { return false }

        return true
    }

    // MARK: - Phone Validation
    static func isValidPhone(_ phone: String) -> Bool {
        let digits = phone.filter { $0.isNumber }
        // US phone numbers: exactly 10 digits, or 11 digits starting with country code 1
        if digits.count == AppConfiguration.Validation.phoneDigitsRequired {
            return true
        }
        // Allow 11 digits if it starts with US country code "1"
        if digits.count == 11 && digits.hasPrefix("1") {
            return true
        }
        return false
    }

    static func normalizePhone(_ phone: String) -> String {
        var digits = phone.filter { $0.isNumber }

        // Strip leading US country code "1" if 11 digits
        if digits.count == 11 && digits.hasPrefix("1") {
            digits = String(digits.dropFirst())
        }

        guard digits.count == 10 else { return phone }

        // Format: (555) 123-4567
        let areaCode = String(digits.prefix(3))
        let prefix = String(digits.dropFirst(3).prefix(3))
        let line = String(digits.dropFirst(6))
        return "(\(areaCode)) \(prefix)-\(line)"
    }

    // MARK: - Name Validation
    static func isValidName(_ name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count >= AppConfiguration.Validation.minNameLength &&
               trimmed.count <= AppConfiguration.Validation.maxNameLength
    }

    // MARK: - Description Validation
    static func isValidDescription(_ description: String) -> Bool {
        return description.count <= AppConfiguration.Validation.maxDescriptionLength
    }
}

// MARK: - Input Sanitizer
struct InputSanitizer {

    // Dangerous patterns that could indicate injection attempts
    private static let dangerousPatterns = [
        "<script>", "</script>",
        "javascript:",
        "onerror=", "onclick=", "onload=",
        "eval(", "document.cookie",
        "window.location",
        "<iframe", "</iframe>",
        "data:text/html",
        "vbscript:"
    ]

    // MARK: - Sanitize Text Input
    static func sanitize(_ text: String) -> String {
        var sanitized = text

        // Remove dangerous patterns (case-insensitive)
        for pattern in dangerousPatterns {
            sanitized = sanitized.replacingOccurrences(
                of: pattern,
                with: "",
                options: [.caseInsensitive]
            )
        }

        // Remove HTML tags
        sanitized = sanitized.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        )

        // Trim excessive whitespace
        sanitized = sanitized.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        return sanitized
    }

    // MARK: - Sanitize Name
    static func sanitizeName(_ name: String) -> String {
        // Allow only letters, spaces, hyphens, and apostrophes
        let allowed = CharacterSet.letters
            .union(CharacterSet.whitespaces)
            .union(CharacterSet(charactersIn: "-'"))

        return String(name.unicodeScalars.filter { allowed.contains($0) })
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Sanitize Phone
    static func sanitizePhone(_ phone: String) -> String {
        // Keep only digits, parentheses, hyphens, spaces, and plus
        let allowed = CharacterSet(charactersIn: "0123456789()-+ ")
        return String(phone.unicodeScalars.filter { allowed.contains($0) })
    }

    // MARK: - Sanitize Email
    static func sanitizeEmail(_ email: String) -> String {
        // Remove any whitespace and convert to lowercase
        return email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    // MARK: - Sanitize Description (free text)
    static func sanitizeDescription(_ description: String) -> String {
        var sanitized = sanitize(description)

        // Enforce max length
        if sanitized.count > AppConfiguration.Validation.maxDescriptionLength {
            sanitized = String(sanitized.prefix(AppConfiguration.Validation.maxDescriptionLength))
        }

        return sanitized
    }
}

// MARK: - Validation Result
enum ValidationError: LocalizedError {
    case invalidEmail
    case invalidPhone
    case invalidName(field: String)
    case descriptionTooLong
    case missingRequired(field: String)

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .invalidPhone:
            return "Please enter a valid 10-digit phone number"
        case .invalidName(let field):
            return "\(field) must be between \(AppConfiguration.Validation.minNameLength) and \(AppConfiguration.Validation.maxNameLength) characters"
        case .descriptionTooLong:
            return "Description exceeds maximum length of \(AppConfiguration.Validation.maxDescriptionLength) characters"
        case .missingRequired(let field):
            return "\(field) is required"
        }
    }
}
