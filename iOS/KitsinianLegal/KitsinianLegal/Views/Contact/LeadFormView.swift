//
//  LeadFormView.swift
//  KitsinianLegal
//

import SwiftUI

struct LeadFormView: View {
    @Environment(\.dismiss) var dismiss
    let practiceArea: PracticeArea?

    @StateObject private var viewModel = LeadFormViewModel()
    @State private var showingConfirmation = false
    @FocusState private var focusedField: FormField?

    enum FormField {
        case firstName, lastName, email, phone, description
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection

                // Form Fields
                formSection

                // Submit Button
                submitButton

                // Disclaimer
                disclaimer
            }
            .padding()
        }
        .background(Color("Background"))
        .navigationTitle("Contact Us")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .alert("Request Submitted", isPresented: $showingConfirmation) {
            Button("Done") {
                dismiss()
            }
        } message: {
            Text("Thank you! We'll be in touch within 24 hours.")
        }
        .onAppear {
            if let area = practiceArea {
                viewModel.lead.practiceArea = area.id
                viewModel.lead.practiceAreaCategory = area.category.rawValue
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            if let area = practiceArea {
                HStack {
                    Image(systemName: area.icon)
                    Text(area.name)
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color("Primary"))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color("Primary").opacity(0.1))
                .cornerRadius(20)
            }

            Text("Tell us about your situation")
                .font(.title3)
                .fontWeight(.semibold)

            Text("All information is confidential. We'll review your case and respond within 24 hours.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: 16) {
            // Name Row
            HStack(spacing: 12) {
                FormTextField(
                    title: "First Name",
                    text: $viewModel.lead.firstName,
                    placeholder: "First name"
                )
                .focused($focusedField, equals: .firstName)

                FormTextField(
                    title: "Last Name",
                    text: $viewModel.lead.lastName,
                    placeholder: "Last name"
                )
                .focused($focusedField, equals: .lastName)
            }

            // Email
            FormTextField(
                title: "Email",
                text: $viewModel.lead.email,
                placeholder: "your@email.com",
                keyboardType: .emailAddress
            )
            .focused($focusedField, equals: .email)

            // Phone
            FormTextField(
                title: "Phone",
                text: $viewModel.lead.phone,
                placeholder: "(555) 555-5555",
                keyboardType: .phonePad
            )
            .focused($focusedField, equals: .phone)

            // Preferred Contact Method
            VStack(alignment: .leading, spacing: 8) {
                Text("Preferred Contact Method")
                    .font(.subheadline)
                    .fontWeight(.medium)

                HStack(spacing: 8) {
                    ForEach(Lead.ContactMethod.allCases, id: \.self) { method in
                        ContactMethodButton(
                            method: method,
                            isSelected: viewModel.lead.preferredContact == method
                        ) {
                            viewModel.lead.preferredContact = method
                        }
                    }
                }
            }

            // Practice Area (if not pre-selected)
            if practiceArea == nil {
                VStack(alignment: .leading, spacing: 8) {
                    Text("What type of legal issue?")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    Menu {
                        ForEach(PracticeArea.allAreas) { area in
                            Button(area.name) {
                                viewModel.lead.practiceArea = area.id
                                viewModel.lead.practiceAreaCategory = area.category.rawValue
                            }
                        }
                    } label: {
                        HStack {
                            Text(viewModel.selectedAreaName ?? "Select an option")
                                .foregroundColor(viewModel.lead.practiceArea.isEmpty ? .secondary : .primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                }
            }

            // Urgency
            VStack(alignment: .leading, spacing: 8) {
                Text("How urgent is your matter?")
                    .font(.subheadline)
                    .fontWeight(.medium)

                VStack(spacing: 8) {
                    ForEach(Lead.Urgency.allCases, id: \.self) { urgency in
                        UrgencyButton(
                            urgency: urgency,
                            isSelected: viewModel.lead.urgency == urgency
                        ) {
                            viewModel.lead.urgency = urgency
                        }
                    }
                }
            }

            // Description
            VStack(alignment: .leading, spacing: 8) {
                Text("Brief description (optional)")
                    .font(.subheadline)
                    .fontWeight(.medium)

                TextEditor(text: $viewModel.lead.description)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .focused($focusedField, equals: .description)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }

    // MARK: - Submit Button
    private var submitButton: some View {
        Button(action: {
            Task {
                await viewModel.submitLead()
                if viewModel.submissionSuccessful {
                    showingConfirmation = true
                }
            }
        }) {
            HStack {
                if viewModel.isSubmitting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Image(systemName: "paperplane.fill")
                    Text("Submit Request")
                }
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(viewModel.isFormValid ? Color("Primary") : Color.gray)
            .cornerRadius(12)
        }
        .disabled(!viewModel.isFormValid || viewModel.isSubmitting)
    }

    // MARK: - Disclaimer
    private var disclaimer: some View {
        Text("By submitting this form, you agree to be contacted regarding your legal matter. This does not create an attorney-client relationship.")
            .font(.caption2)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
    }
}

// MARK: - Form Text Field
struct FormTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)

            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .textContentType(contentType)
                .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }

    private var contentType: UITextContentType? {
        switch keyboardType {
        case .emailAddress: return .emailAddress
        case .phonePad: return .telephoneNumber
        default: return nil
        }
    }
}

// MARK: - Contact Method Button
struct ContactMethodButton: View {
    let method: Lead.ContactMethod
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: method.icon)
                    .font(.title3)
                Text(method.displayName)
                    .font(.caption2)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color("Primary") : Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Urgency Button
struct UrgencyButton: View {
    let urgency: Lead.Urgency
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(urgency.displayName)
                    .font(.subheadline)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color("Primary"))
                }
            }
            .foregroundColor(.primary)
            .padding()
            .background(isSelected ? Color("Primary").opacity(0.1) : Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color("Primary") : Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Lead Form ViewModel
class LeadFormViewModel: ObservableObject {
    @Published var lead = Lead()
    @Published var isSubmitting = false
    @Published var submissionSuccessful = false
    @Published var errorMessage: String?

    var isFormValid: Bool {
        !lead.firstName.isEmpty &&
        !lead.lastName.isEmpty &&
        !lead.email.isEmpty &&
        !lead.phone.isEmpty &&
        isValidEmail(lead.email)
    }

    var selectedAreaName: String? {
        PracticeArea.allAreas.first(where: { $0.id == lead.practiceArea })?.name
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    @MainActor
    func submitLead() async {
        isSubmitting = true
        errorMessage = nil

        do {
            try await APIService.shared.submitLead(lead)
            submissionSuccessful = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isSubmitting = false
    }
}

#Preview {
    NavigationStack {
        LeadFormView(practiceArea: .personalInjury)
    }
}
