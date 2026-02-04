//
//  ValidationUtilsTests.swift
//  KitsinianLegalTests
//
//  Unit tests for InputValidator and InputSanitizer
//

import XCTest
@testable import KitsinianLegal

final class InputValidatorTests: XCTestCase {

    // MARK: - Email Validation Tests

    func testValidEmails() {
        let validEmails = [
            "test@example.com",
            "user.name@domain.com",
            "user+tag@example.org",
            "firstname.lastname@company.co.uk",
            "email@subdomain.domain.com",
            "1234567890@example.com",
            "email@domain-one.com",
            "_______@example.com"
        ]

        for email in validEmails {
            XCTAssertTrue(InputValidator.isValidEmail(email), "Expected '\(email)' to be valid")
        }
    }

    func testInvalidEmails() {
        let invalidEmails = [
            "",
            "plainaddress",
            "@no-local-part.com",
            "missing-at-sign.com",
            "missing-domain@.com",
            "spaces in@email.com",
            "double..dots@example.com",
            ".leading-dot@example.com",
            "trailing-dot.@example.com",
            "two@@ats.com"
        ]

        for email in invalidEmails {
            XCTAssertFalse(InputValidator.isValidEmail(email), "Expected '\(email)' to be invalid")
        }
    }

    // MARK: - Phone Validation Tests

    func testValidPhones() {
        let validPhones = [
            "5551234567",
            "(555) 123-4567",
            "555-123-4567",
            "555.123.4567",
            "+1 555 123 4567",
            "1-555-123-4567"
        ]

        for phone in validPhones {
            XCTAssertTrue(InputValidator.isValidPhone(phone), "Expected '\(phone)' to be valid")
        }
    }

    func testInvalidPhones() {
        let invalidPhones = [
            "",
            "123",
            "12345",
            "123456789",  // 9 digits - too short
            "234567890123",  // 12 digits - too long
            "23456789012",  // 11 digits not starting with country code "1"
            "abcdefghij"
        ]

        for phone in invalidPhones {
            XCTAssertFalse(InputValidator.isValidPhone(phone), "Expected '\(phone)' to be invalid")
        }
    }

    // MARK: - Phone Normalization Tests

    func testPhoneNormalization() {
        XCTAssertEqual(InputValidator.normalizePhone("5551234567"), "(555) 123-4567")
        XCTAssertEqual(InputValidator.normalizePhone("(555) 123-4567"), "(555) 123-4567")
        XCTAssertEqual(InputValidator.normalizePhone("555-123-4567"), "(555) 123-4567")
        XCTAssertEqual(InputValidator.normalizePhone("+1 555 123 4567"), "(555) 123-4567")
    }

    func testPhoneNormalizationInvalidLength() {
        // Should return original if not 10 digits
        XCTAssertEqual(InputValidator.normalizePhone("12345"), "12345")
        XCTAssertEqual(InputValidator.normalizePhone(""), "")
    }

    // MARK: - Name Validation Tests

    func testValidNames() {
        let validNames = [
            "Jo",
            "John",
            "Mary Jane",
            "O'Connor",
            "Smith-Jones",
            String(repeating: "a", count: 100)
        ]

        for name in validNames {
            XCTAssertTrue(InputValidator.isValidName(name), "Expected '\(name)' to be valid")
        }
    }

    func testInvalidNames() {
        let invalidNames = [
            "",
            "J",  // Too short
            "   ",  // Only whitespace
            String(repeating: "a", count: 101)  // Too long
        ]

        for name in invalidNames {
            XCTAssertFalse(InputValidator.isValidName(name), "Expected '\(name)' to be invalid")
        }
    }

    // MARK: - Description Validation Tests

    func testValidDescriptions() {
        XCTAssertTrue(InputValidator.isValidDescription(""))
        XCTAssertTrue(InputValidator.isValidDescription("Short description"))
        XCTAssertTrue(InputValidator.isValidDescription(String(repeating: "a", count: 5000)))
    }

    func testInvalidDescriptions() {
        XCTAssertFalse(InputValidator.isValidDescription(String(repeating: "a", count: 5001)))
    }
}

// MARK: - Input Sanitizer Tests

final class InputSanitizerTests: XCTestCase {

    // MARK: - XSS Prevention Tests

    func testRemovesScriptTags() {
        let input = "Hello <script>alert('xss')</script> World"
        let sanitized = InputSanitizer.sanitize(input)
        XCTAssertFalse(sanitized.contains("<script>"))
        XCTAssertFalse(sanitized.contains("</script>"))
    }

    func testRemovesJavascriptProtocol() {
        let input = "Click javascript:alert('xss')"
        let sanitized = InputSanitizer.sanitize(input)
        XCTAssertFalse(sanitized.lowercased().contains("javascript:"))
    }

    func testRemovesEventHandlers() {
        let input = "Image onerror=alert('xss') onclick=evil()"
        let sanitized = InputSanitizer.sanitize(input)
        XCTAssertFalse(sanitized.lowercased().contains("onerror="))
        XCTAssertFalse(sanitized.lowercased().contains("onclick="))
    }

    func testRemovesIframeTags() {
        let input = "Content <iframe src='evil.com'></iframe> more"
        let sanitized = InputSanitizer.sanitize(input)
        XCTAssertFalse(sanitized.contains("<iframe"))
        XCTAssertFalse(sanitized.contains("</iframe>"))
    }

    func testRemovesAllHtmlTags() {
        let input = "Hello <b>bold</b> and <a href='link'>link</a>"
        let sanitized = InputSanitizer.sanitize(input)
        XCTAssertFalse(sanitized.contains("<"))
        XCTAssertFalse(sanitized.contains(">"))
    }

    func testCaseInsensitiveRemoval() {
        let input = "<SCRIPT>evil</SCRIPT> <ScRiPt>bad</ScRiPt>"
        let sanitized = InputSanitizer.sanitize(input)
        XCTAssertFalse(sanitized.lowercased().contains("script"))
    }

    // MARK: - Name Sanitization Tests

    func testSanitizeNameAllowsValidCharacters() {
        XCTAssertEqual(InputSanitizer.sanitizeName("John O'Connor"), "John O'Connor")
        XCTAssertEqual(InputSanitizer.sanitizeName("Mary-Jane"), "Mary-Jane")
        XCTAssertEqual(InputSanitizer.sanitizeName("José García"), "José García")
    }

    func testSanitizeNameRemovesNumbers() {
        XCTAssertEqual(InputSanitizer.sanitizeName("John123"), "John")
        XCTAssertEqual(InputSanitizer.sanitizeName("Test456User"), "TestUser")
    }

    func testSanitizeNameRemovesSpecialCharacters() {
        XCTAssertEqual(InputSanitizer.sanitizeName("John@Doe"), "JohnDoe")
        XCTAssertEqual(InputSanitizer.sanitizeName("Test<script>"), "Testscript")
    }

    func testSanitizeNameTrimsWhitespace() {
        XCTAssertEqual(InputSanitizer.sanitizeName("  John  "), "John")
    }

    // MARK: - Email Sanitization Tests

    func testSanitizeEmailTrimsAndLowercases() {
        XCTAssertEqual(InputSanitizer.sanitizeEmail("  TEST@EXAMPLE.COM  "), "test@example.com")
        XCTAssertEqual(InputSanitizer.sanitizeEmail("User@Domain.Com"), "user@domain.com")
    }

    // MARK: - Phone Sanitization Tests

    func testSanitizePhoneAllowsValidCharacters() {
        XCTAssertEqual(InputSanitizer.sanitizePhone("(555) 123-4567"), "(555) 123-4567")
        XCTAssertEqual(InputSanitizer.sanitizePhone("+1-555-123-4567"), "+1-555-123-4567")
    }

    func testSanitizePhoneRemovesInvalidCharacters() {
        XCTAssertEqual(InputSanitizer.sanitizePhone("555abc1234567"), "5551234567")
        XCTAssertEqual(InputSanitizer.sanitizePhone("call: 555-1234"), " 555-1234")
    }

    // MARK: - Description Sanitization Tests

    func testSanitizeDescriptionEnforcesMaxLength() {
        let longInput = String(repeating: "a", count: 6000)
        let sanitized = InputSanitizer.sanitizeDescription(longInput)
        XCTAssertEqual(sanitized.count, 5000)
    }

    func testSanitizeDescriptionRemovesDangerousContent() {
        let input = "My injury: <script>alert('xss')</script>"
        let sanitized = InputSanitizer.sanitizeDescription(input)
        XCTAssertFalse(sanitized.contains("<script>"))
    }

    // MARK: - Whitespace Normalization

    func testNormalizesExcessiveWhitespace() {
        let input = "Hello    world\n\n\ntest"
        let sanitized = InputSanitizer.sanitize(input)
        XCTAssertFalse(sanitized.contains("    "))
        XCTAssertFalse(sanitized.contains("\n\n"))
    }
}
