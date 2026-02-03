//
//  LeadFormView.swift
//  ClaimIt
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
        ScrollView(showsIndicators: false) {
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
            .padding(16)
        }
        .background(Color.claimBackground)
        .navigationTitle("Contact Us")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.claimPrimary)
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
        VStack(spacing: 16) {
            if let area = practiceArea {
                HStack(spacing: 8) {
                    Image(systemName: area.icon)
                        .font(.system(size: 14, weight: .semibold))
                    Text(area.name)
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.claimPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.claimPrimary.opacity(0.1))
                .cornerRadius(20)
            }

            Text("Tell us about your situation")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.claimTextPrimary)

            Text("All information is confidential. We'll review your case and respond within 24 hours.")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.claimTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
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
            VStack(alignment: .leading, spacing: 10) {
                Text("Preferred Contact Method")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.claimTextPrimary)

                HStack(spacing: 10) {
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
                VStack(alignment: .leading, spacing: 10) {
                    Text("What type of legal issue?")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.claimTextPrimary)

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
                                .font(.system(size: 15))
                                .foregroundColor(viewModel.lead.practiceArea.isEmpty ? .claimTextMuted : .claimTextPrimary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.claimTextMuted)
                        }
                        .padding(14)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.claimBorder, lineWidth: 1)
                        )
                    }
                }
            }

            // Urgency
            VStack(alignment: .leading, spacing: 10) {
                Text("How urgent is your matter?")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.claimTextPrimary)

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
            VStack(alignment: .leading, spacing: 10) {
                Text("Brief description (optional)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.claimTextPrimary)

                TextEditor(text: $viewModel.lead.description)
                    .font(.system(size: 15))
                    .frame(height: 100)
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.claimBorder, lineWidth: 1)
                    )
                    .focused($focusedField, equals: .description)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
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
            HStack(spacing: 10) {
                if viewModel.isSubmitting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 18, weight: .bold))
                    Text("Submit Request")
                        .font(.system(size: 17, weight: .bold))
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                viewModel.isFormValid
                    ? LinearGradient.claimAccentGradient
                    : LinearGradient(colors: [.gray, .gray], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(14)
            .shadow(color: viewModel.isFormValid ? .claimAccent.opacity(0.35) : .clear, radius: 12, y: 6)
        }
        .disabled(!viewModel.isFormValid || viewModel.isSubmitting)
    }

    // MARK: - Disclaimer
    private var disclaimer: some View {
        Text("By submitting this form, you agree to be contacted regarding your legal matter. This does not create an attorney-client relationship.")
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(.claimTextMuted)
            .multilineTextAlignment(.center)
            .lineSpacing(3)
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
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.claimTextPrimary)

            TextField(placeholder, text: $text)
                .font(.system(size: 15))
                .keyboardType(keyboardType)
                .textContentType(contentType)
                .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                .padding(14)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.claimBorder, lineWidth: 1)
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
            VStack(spacing: 6) {
                Image(systemName: method.icon)
                    .font(.system(size: 20, weight: .semibold))
                Text(method.displayName)
                    .font(.system(size: 11, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : .claimTextPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isSelected ? LinearGradient.claimPrimaryGradient : LinearGradient(colors: [.white, .white], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.clear : Color.claimBorder, lineWidth: 1)
            )
            .claimShadowSmall()
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
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.claimTextPrimary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.claimPrimary)
                }
            }
            .padding(14)
            .background(isSelected ? Color.claimPrimary.opacity(0.08) : Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.claimPrimary : Color.claimBorder, lineWidth: isSelected ? 2 : 1)
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
