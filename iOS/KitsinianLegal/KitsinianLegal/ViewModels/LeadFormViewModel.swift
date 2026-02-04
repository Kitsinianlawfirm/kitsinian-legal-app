//
//  LeadFormViewModel.swift
//  ClaimIt
//
//  Extracted ViewModel for Lead form management
//

import SwiftUI

// MARK: - Lead Form ViewModel
class LeadFormViewModel: ObservableObject {
    @Published var lead = Lead()
    @Published var isSubmitting = false
    @Published var submissionSuccessful = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var validationErrors: [String: String] = [:]

    // MARK: - Form Validation

    var isFormValid: Bool {
        validateAllFields()
        return validationErrors.isEmpty
    }

    var firstNameError: String? { validationErrors["firstName"] }
    var lastNameError: String? { validationErrors["lastName"] }
    var emailError: String? { validationErrors["email"] }
    var phoneError: String? { validationErrors["phone"] }

    private func validateAllFields() {
        validationErrors.removeAll()

        // Validate first name
        let sanitizedFirstName = InputSanitizer.sanitizeName(lead.firstName)
        if !InputValidator.isValidName(sanitizedFirstName) {
            validationErrors["firstName"] = "First name must be \(AppConfiguration.Validation.minNameLength)-\(AppConfiguration.Validation.maxNameLength) characters"
        }

        // Validate last name
        let sanitizedLastName = InputSanitizer.sanitizeName(lead.lastName)
        if !InputValidator.isValidName(sanitizedLastName) {
            validationErrors["lastName"] = "Last name must be \(AppConfiguration.Validation.minNameLength)-\(AppConfiguration.Validation.maxNameLength) characters"
        }

        // Validate email
        let sanitizedEmail = InputSanitizer.sanitizeEmail(lead.email)
        if sanitizedEmail.isEmpty {
            validationErrors["email"] = "Email is required"
        } else if !InputValidator.isValidEmail(sanitizedEmail) {
            validationErrors["email"] = "Please enter a valid email address"
        }

        // Validate phone
        let sanitizedPhone = InputSanitizer.sanitizePhone(lead.phone)
        if sanitizedPhone.isEmpty {
            validationErrors["phone"] = "Phone number is required"
        } else if !InputValidator.isValidPhone(sanitizedPhone) {
            validationErrors["phone"] = "Please enter a valid 10-digit phone number"
        }
    }

    // MARK: - Real-time Field Validation

    func validateFirstName() {
        let sanitized = InputSanitizer.sanitizeName(lead.firstName)
        if !sanitized.isEmpty && !InputValidator.isValidName(sanitized) {
            validationErrors["firstName"] = "First name must be \(AppConfiguration.Validation.minNameLength)-\(AppConfiguration.Validation.maxNameLength) characters"
        } else {
            validationErrors.removeValue(forKey: "firstName")
        }
    }

    func validateLastName() {
        let sanitized = InputSanitizer.sanitizeName(lead.lastName)
        if !sanitized.isEmpty && !InputValidator.isValidName(sanitized) {
            validationErrors["lastName"] = "Last name must be \(AppConfiguration.Validation.minNameLength)-\(AppConfiguration.Validation.maxNameLength) characters"
        } else {
            validationErrors.removeValue(forKey: "lastName")
        }
    }

    func validateEmail() {
        let sanitized = InputSanitizer.sanitizeEmail(lead.email)
        if !sanitized.isEmpty && !InputValidator.isValidEmail(sanitized) {
            validationErrors["email"] = "Please enter a valid email address"
        } else {
            validationErrors.removeValue(forKey: "email")
        }
    }

    func validatePhone() {
        let sanitized = InputSanitizer.sanitizePhone(lead.phone)
        if !sanitized.isEmpty && !InputValidator.isValidPhone(sanitized) {
            validationErrors["phone"] = "Please enter a valid 10-digit phone number"
        } else {
            validationErrors.removeValue(forKey: "phone")
        }
    }

    // MARK: - Computed Properties

    var selectedAreaName: String? {
        PracticeArea.allAreas.first(where: { $0.id == lead.practiceArea })?.name
    }

    // MARK: - Submission

    @MainActor
    func submitLead() async {
        isSubmitting = true
        errorMessage = nil
        showError = false

        // Sanitize all inputs before submission
        let sanitizedLead = sanitizeLead(lead)

        // Final validation
        guard isFormValid else {
            isSubmitting = false
            errorMessage = "Please correct the form errors"
            showError = true
            return
        }

        do {
            try await APIService.shared.submitLead(sanitizedLead)
            submissionSuccessful = true
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }

        isSubmitting = false
    }

    // MARK: - Input Sanitization

    private func sanitizeLead(_ lead: Lead) -> Lead {
        var sanitized = lead

        // Sanitize all text fields
        sanitized.firstName = InputSanitizer.sanitizeName(lead.firstName)
        sanitized.lastName = InputSanitizer.sanitizeName(lead.lastName)
        sanitized.email = InputSanitizer.sanitizeEmail(lead.email)
        sanitized.phone = InputValidator.normalizePhone(InputSanitizer.sanitizePhone(lead.phone))
        sanitized.description = InputSanitizer.sanitizeDescription(lead.description)

        // Sanitize quiz answers (free text values)
        var sanitizedAnswers: [String: String] = [:]
        for (key, value) in lead.quizAnswers {
            sanitizedAnswers[key] = InputSanitizer.sanitize(value)
        }
        sanitized.quizAnswers = sanitizedAnswers

        return sanitized
    }

    // MARK: - Error Handling

    func resetError() {
        errorMessage = nil
        showError = false
    }

    func clearValidationErrors() {
        validationErrors.removeAll()
    }
}
