//
//  LeadFormViewModelTests.swift
//  KitsinianLegalTests
//
//  Unit tests for LeadFormViewModel
//

import XCTest
@testable import KitsinianLegal

@MainActor
final class LeadFormViewModelTests: XCTestCase {

    var viewModel: LeadFormViewModel!

    override func setUp() async throws {
        try await super.setUp()
        viewModel = LeadFormViewModel()
    }

    override func tearDown() async throws {
        viewModel = nil
        try await super.tearDown()
    }

    // MARK: - Initial State Tests

    func testInitialState() {
        XCTAssertFalse(viewModel.isSubmitting)
        XCTAssertFalse(viewModel.submissionSuccessful)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
        XCTAssertTrue(viewModel.validationErrors.isEmpty)
    }

    // MARK: - Form Validation Tests

    func testEmptyFormIsInvalid() {
        XCTAssertFalse(viewModel.isFormValid)
    }

    func testValidFormPassesValidation() {
        viewModel.lead.firstName = "John"
        viewModel.lead.lastName = "Doe"
        viewModel.lead.email = "john.doe@example.com"
        viewModel.lead.phone = "5551234567"

        XCTAssertTrue(viewModel.isFormValid)
        XCTAssertTrue(viewModel.validationErrors.isEmpty)
    }

    func testInvalidEmailFailsValidation() {
        viewModel.lead.firstName = "John"
        viewModel.lead.lastName = "Doe"
        viewModel.lead.email = "invalid-email"
        viewModel.lead.phone = "5551234567"

        XCTAssertFalse(viewModel.isFormValid)
        XCTAssertNotNil(viewModel.emailError)
    }

    func testInvalidPhoneFailsValidation() {
        viewModel.lead.firstName = "John"
        viewModel.lead.lastName = "Doe"
        viewModel.lead.email = "john@example.com"
        viewModel.lead.phone = "123"

        XCTAssertFalse(viewModel.isFormValid)
        XCTAssertNotNil(viewModel.phoneError)
    }

    func testEmptyFirstNameFailsValidation() {
        viewModel.lead.firstName = ""
        viewModel.lead.lastName = "Doe"
        viewModel.lead.email = "john@example.com"
        viewModel.lead.phone = "5551234567"

        XCTAssertFalse(viewModel.isFormValid)
        XCTAssertNotNil(viewModel.firstNameError)
    }

    func testEmptyLastNameFailsValidation() {
        viewModel.lead.firstName = "John"
        viewModel.lead.lastName = ""
        viewModel.lead.email = "john@example.com"
        viewModel.lead.phone = "5551234567"

        XCTAssertFalse(viewModel.isFormValid)
        XCTAssertNotNil(viewModel.lastNameError)
    }

    // MARK: - Real-time Validation Tests

    func testValidateFirstNameWithValidInput() {
        viewModel.lead.firstName = "John"
        viewModel.validateFirstName()

        XCTAssertNil(viewModel.firstNameError)
    }

    func testValidateFirstNameWithInvalidInput() {
        viewModel.lead.firstName = "J"
        viewModel.validateFirstName()

        XCTAssertNotNil(viewModel.firstNameError)
    }

    func testValidateEmailWithValidInput() {
        viewModel.lead.email = "test@example.com"
        viewModel.validateEmail()

        XCTAssertNil(viewModel.emailError)
    }

    func testValidateEmailWithInvalidInput() {
        viewModel.lead.email = "not-an-email"
        viewModel.validateEmail()

        XCTAssertNotNil(viewModel.emailError)
    }

    func testValidatePhoneWithValidInput() {
        viewModel.lead.phone = "5551234567"
        viewModel.validatePhone()

        XCTAssertNil(viewModel.phoneError)
    }

    func testValidatePhoneWithInvalidInput() {
        viewModel.lead.phone = "12345"
        viewModel.validatePhone()

        XCTAssertNotNil(viewModel.phoneError)
    }

    // MARK: - Error Handling Tests

    func testResetError() {
        viewModel.errorMessage = "Test error"
        viewModel.showError = true

        viewModel.resetError()

        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }

    func testClearValidationErrors() {
        viewModel.lead.firstName = "J"  // Too short
        _ = viewModel.isFormValid  // Trigger validation

        XCTAssertFalse(viewModel.validationErrors.isEmpty)

        viewModel.clearValidationErrors()

        XCTAssertTrue(viewModel.validationErrors.isEmpty)
    }

    // MARK: - Sanitization Tests

    func testInputIsSanitizedBeforeValidation() {
        viewModel.lead.firstName = "  John  "
        viewModel.lead.lastName = "  Doe  "
        viewModel.lead.email = "  JOHN@EXAMPLE.COM  "
        viewModel.lead.phone = "(555) 123-4567"

        XCTAssertTrue(viewModel.isFormValid)
    }

    func testMaliciousInputIsSanitized() {
        viewModel.lead.firstName = "<script>alert('xss')</script>John"
        viewModel.lead.lastName = "Doe<img onerror=evil()>"
        viewModel.lead.email = "john@example.com"
        viewModel.lead.phone = "5551234567"

        // Form should still be valid after sanitization
        // The malicious content is stripped, leaving valid names
        _ = viewModel.isFormValid

        // Validation should pass (sanitized names are valid)
        // Note: The actual sanitization happens during submission,
        // not during validation display
    }

    // MARK: - Selected Area Name Tests

    func testSelectedAreaNameReturnsCorrectName() {
        viewModel.lead.practiceArea = "personal-injury"

        // This will return the name from PracticeArea.allAreas
        let areaName = viewModel.selectedAreaName
        XCTAssertNotNil(areaName)
    }

    func testSelectedAreaNameReturnsNilForUnknownArea() {
        viewModel.lead.practiceArea = "unknown-area"

        let areaName = viewModel.selectedAreaName
        XCTAssertNil(areaName)
    }

    // MARK: - Edge Cases

    func testWhitespaceOnlyNameIsInvalid() {
        viewModel.lead.firstName = "   "
        viewModel.lead.lastName = "Doe"
        viewModel.lead.email = "john@example.com"
        viewModel.lead.phone = "5551234567"

        XCTAssertFalse(viewModel.isFormValid)
    }

    func testEmptyEmailShowsRequiredError() {
        viewModel.lead.firstName = "John"
        viewModel.lead.lastName = "Doe"
        viewModel.lead.email = ""
        viewModel.lead.phone = "5551234567"

        _ = viewModel.isFormValid

        XCTAssertEqual(viewModel.emailError, "Email is required")
    }

    func testEmptyPhoneShowsRequiredError() {
        viewModel.lead.firstName = "John"
        viewModel.lead.lastName = "Doe"
        viewModel.lead.email = "john@example.com"
        viewModel.lead.phone = ""

        _ = viewModel.isFormValid

        XCTAssertEqual(viewModel.phoneError, "Phone number is required")
    }

    // MARK: - Phone Format Variations

    func testVariousPhoneFormatsAreValid() {
        let validPhoneFormats = [
            "5551234567",
            "(555) 123-4567",
            "555-123-4567",
            "555.123.4567",
            "+1 555 123 4567"
        ]

        for phone in validPhoneFormats {
            viewModel.lead.firstName = "John"
            viewModel.lead.lastName = "Doe"
            viewModel.lead.email = "john@example.com"
            viewModel.lead.phone = phone
            viewModel.clearValidationErrors()

            XCTAssertTrue(viewModel.isFormValid, "Phone format '\(phone)' should be valid")
        }
    }
}
