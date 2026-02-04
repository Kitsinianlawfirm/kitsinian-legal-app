//
//  ContactView.swift
//  ClaimIt
//
//  Account screen with sign-in, My Cases, and settings
//

import SwiftUI

// MARK: - User Model
struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var phone: String
    var memberSince: Date

    init(id: UUID = UUID(), name: String, email: String, phone: String, memberSince: Date = Date()) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.memberSince = memberSince
    }
}

// MARK: - Case Model
struct LegalCase: Identifiable, Codable {
    let id: UUID
    let caseType: String
    let caseNumber: String
    let status: CaseStatus
    let lastUpdated: Date
    let description: String

    enum CaseStatus: String, Codable {
        case submitted = "Submitted"
        case underReview = "Under Review"
        case qualified = "Qualified"
        case matched = "Matched"
        case retained = "Retained"

        var color: Color {
            switch self {
            case .submitted: return Color(hex: "6B7280")
            case .underReview: return Color(hex: "1D4ED8")
            case .qualified: return Color(hex: "059669")
            case .matched: return Color(hex: "D97706")
            case .retained: return Color(hex: "059669")
            }
        }

        var backgroundColor: Color {
            switch self {
            case .submitted: return Color(hex: "E5E7EB")
            case .underReview: return Color(hex: "DBEAFE")
            case .qualified: return Color(hex: "D1FAE5")
            case .matched: return Color(hex: "FEF3C7")
            case .retained: return Color(hex: "D1FAE5")
            }
        }

        var step: Int {
            switch self {
            case .submitted: return 1
            case .underReview: return 2
            case .qualified: return 3
            case .matched: return 4
            case .retained: return 5
            }
        }
    }
}

// MARK: - Account View Model
class AccountViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var currentUser: User?
    @Published var userCases: [LegalCase] = []
    @Published var showSignInSheet: Bool = false

    // Demo data
    private let demoUser = User(
        name: "John Doe",
        email: "john@example.com",
        phone: "(555) 123-4567",
        memberSince: Calendar.current.date(byAdding: .month, value: -2, to: Date()) ?? Date()
    )

    private let demoCases: [LegalCase] = [
        LegalCase(
            id: UUID(),
            caseType: "Personal Injury",
            caseNumber: "PI-2026-0042",
            status: .underReview,
            lastUpdated: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            description: "Car Accident Case - Rear-ended at intersection"
        ),
        LegalCase(
            id: UUID(),
            caseType: "Insurance Bad Faith",
            caseNumber: "IB-2026-0015",
            status: .qualified,
            lastUpdated: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            description: "Denied claim for water damage"
        )
    ]

    func signIn(email: String, password: String) {
        // Demo: simulate sign-in
        isSignedIn = true
        currentUser = demoUser
        userCases = demoCases
        showSignInSheet = false
    }

    func signInWithApple() {
        // Demo: simulate Apple sign-in
        isSignedIn = true
        currentUser = User(
            name: "Apple User",
            email: "user@icloud.com",
            phone: "",
            memberSince: Date()
        )
        userCases = demoCases
        showSignInSheet = false
    }

    func signOut() {
        isSignedIn = false
        currentUser = nil
        userCases = []
    }
}

// MARK: - Contact View (Account Screen)
struct ContactView: View {
    @StateObject private var viewModel = AccountViewModel()
    @State private var accidentModeEnabled = true
    @State private var notificationsEnabled = true

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    if viewModel.isSignedIn {
                        signedInView
                    } else {
                        signedOutView
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(Color.claimBackground)
            .navigationTitle("My Cases")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if viewModel.isSignedIn {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Sign Out") {
                            viewModel.signOut()
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.claimPrimary)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showSignInSheet) {
                SignInSheet(viewModel: viewModel)
            }
        }
    }

    // MARK: - Signed Out View
    private var signedOutView: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                GradientIconView(
                    systemName: "person.circle.fill",
                    size: 80,
                    iconSize: 36,
                    gradient: LinearGradient.claimPrimaryGradient
                )

                Text("Track Your Fight")
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundColor(.claimTextPrimary)

                Text("Track the status of your submitted claims and see which attorney has been assigned to your case.")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.claimTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.vertical, 8)

            // Sign In Buttons
            VStack(spacing: 12) {
                // Primary Sign In Button
                Button(action: {
                    viewModel.showSignInSheet = true
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 18, weight: .bold))
                        Text("Sign In")
                            .font(.system(size: 17, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(LinearGradient.claimPrimaryGradient)
                    .cornerRadius(14)
                    .shadow(color: .claimPrimary.opacity(0.35), radius: 12, y: 6)
                }

                // Sign in with Apple
                Button(action: {
                    viewModel.signInWithApple()
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "applelogo")
                            .font(.system(size: 18, weight: .bold))
                        Text("Sign in with Apple")
                            .font(.system(size: 17, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.black)
                    .cornerRadius(14)
                }
            }
            .padding(.top, 8)

            // Benefits List
            VStack(alignment: .leading, spacing: 16) {
                Text("What you can do")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.claimTextPrimary)

                VStack(spacing: 12) {
                    AccountBenefitRow(icon: "chart.line.uptrend.xyaxis", text: "Track your case status in real-time")
                    AccountBenefitRow(icon: "doc.fill", text: "Upload documents securely")
                    AccountBenefitRow(icon: "bell.fill", text: "Get notifications on updates")
                    AccountBenefitRow(icon: "message.fill", text: "Message your legal team")
                }
            }
            .padding(20)
            .background(Color.claimCardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.claimBorder, lineWidth: 1)
            )
            .claimShadowSmall()
        }
    }

    // MARK: - Signed In View
    private var signedInView: some View {
        VStack(spacing: 24) {
            // User Profile Card
            if let user = viewModel.currentUser {
                userProfileCard(user: user)
            }

            // My Cases Section
            myCasesSection

            // Settings Section
            settingsSection

            // Help Section
            helpSection
        }
    }

    // MARK: - User Profile Card
    private func userProfileCard(user: User) -> some View {
        HStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(LinearGradient.claimPrimaryGradient)
                    .frame(width: 60, height: 60)

                Text(String(user.name.prefix(1)).uppercased())
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.claimTextPrimary)

                Text(user.email)
                    .font(.system(size: 14))
                    .foregroundColor(.claimTextSecondary)

                Text("Member since \(user.memberSince, formatter: monthYearFormatter)")
                    .font(.system(size: 12))
                    .foregroundColor(.claimTextMuted)
            }

            Spacer()
        }
        .padding(16)
        .background(Color.claimCardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }

    // MARK: - My Cases Section
    private var myCasesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("My Cases")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.claimTextPrimary)

                Spacer()

                if !viewModel.userCases.isEmpty {
                    Text("\(viewModel.userCases.count) active")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.claimTextMuted)
                }
            }

            if viewModel.userCases.isEmpty {
                // Empty state
                VStack(spacing: 12) {
                    Image(systemName: "folder.badge.plus")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.claimTextMuted)

                    Text("No active cases")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.claimTextSecondary)

                    Text("Start a free case review to get matched with an attorney.")
                        .font(.system(size: 13))
                        .foregroundColor(.claimTextMuted)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(32)
                .background(Color.claimCardBackground)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.claimBorder, lineWidth: 1)
                )
            } else {
                // Case cards
                VStack(spacing: 12) {
                    ForEach(viewModel.userCases) { legalCase in
                        CaseCard(legalCase: legalCase)
                    }
                }
            }
        }
    }

    // MARK: - Settings Section
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Settings")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.claimTextPrimary)

            VStack(spacing: 0) {
                // Document Upload
                SettingsRow(
                    icon: "doc.fill",
                    title: "Upload Documents",
                    subtitle: "Share files with your legal team"
                ) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.claimTextMuted)
                }

                Divider().padding(.leading, 56)

                // Notifications Toggle
                SettingsRow(
                    icon: "bell.fill",
                    title: "Push Notifications",
                    subtitle: "Case updates and reminders"
                ) {
                    Toggle("", isOn: $notificationsEnabled)
                        .labelsHidden()
                        .tint(.claimPrimary)
                }

                Divider().padding(.leading, 56)

                // Accident Mode Toggle
                SettingsRow(
                    icon: "exclamationmark.triangle.fill",
                    title: "Accident Mode",
                    subtitle: "Emergency evidence collection"
                ) {
                    Toggle("", isOn: $accidentModeEnabled)
                        .labelsHidden()
                        .tint(.claimAccent)
                }
            }
            .background(Color.claimCardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.claimBorder, lineWidth: 1)
            )
            .claimShadowSmall()
        }
    }

    // MARK: - Help Section
    private var helpSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Help & Legal")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.claimTextPrimary)

            VStack(spacing: 0) {
                HelpRow(icon: "questionmark.circle.fill", title: "FAQ")
                Divider().padding(.leading, 56)
                HelpRow(icon: "doc.text.fill", title: "Terms of Service")
                Divider().padding(.leading, 56)
                HelpRow(icon: "hand.raised.fill", title: "Privacy Policy")
                Divider().padding(.leading, 56)
                HelpRow(icon: "envelope.fill", title: "Contact Support")
            }
            .background(Color.claimCardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.claimBorder, lineWidth: 1)
            )
            .claimShadowSmall()
        }
    }
}

// MARK: - Sign In Sheet
struct SignInSheet: View {
    @ObservedObject var viewModel: AccountViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    ClaimItLogo(size: 48)

                    Text("Welcome Back")
                        .font(.system(size: 24, weight: .heavy))
                        .foregroundColor(.claimTextPrimary)

                    Text("Sign in to access your cases")
                        .font(.system(size: 15))
                        .foregroundColor(.claimTextSecondary)
                }
                .padding(.top, 24)

                // Form
                VStack(spacing: 16) {
                    // Email Field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.claimTextSecondary)

                        TextField("john@example.com", text: $email)
                            .textFieldStyle(ClaimTextFieldStyle())
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }

                    // Password Field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.claimTextSecondary)

                        SecureField("Enter password", text: $password)
                            .textFieldStyle(ClaimTextFieldStyle())
                            .textContentType(.password)
                    }
                }
                .padding(.horizontal, 20)

                // Sign In Button
                Button(action: {
                    viewModel.signIn(email: email, password: password)
                }) {
                    Text("Sign In")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(LinearGradient.claimPrimaryGradient)
                        .cornerRadius(14)
                }
                .padding(.horizontal, 20)

                // Divider
                HStack {
                    Rectangle()
                        .fill(Color.claimBorder)
                        .frame(height: 1)
                    Text("or continue with")
                        .font(.system(size: 13))
                        .foregroundColor(.claimTextMuted)
                    Rectangle()
                        .fill(Color.claimBorder)
                        .frame(height: 1)
                }
                .padding(.horizontal, 20)

                // Sign in with Apple
                Button(action: {
                    viewModel.signInWithApple()
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "applelogo")
                            .font(.system(size: 18, weight: .bold))
                        Text("Sign in with Apple")
                            .font(.system(size: 17, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.black)
                    .cornerRadius(14)
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .background(Color.claimBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.claimTextSecondary)
                }
            }
        }
    }
}

// MARK: - Claim Text Field Style
struct ClaimTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(14)
            .background(Color.claimCardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.claimBorder, lineWidth: 1)
            )
    }
}

// MARK: - Case Card
struct CaseCard: View {
    let legalCase: LegalCase

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(legalCase.caseType)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.claimTextPrimary)

                    Text(legalCase.caseNumber)
                        .font(.system(size: 12))
                        .foregroundColor(.claimTextMuted)
                }

                Spacer()

                // Status Badge
                Text(legalCase.status.rawValue)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(legalCase.status.color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(legalCase.status.backgroundColor)
                    .cornerRadius(6)
            }

            // Description
            Text(legalCase.description)
                .font(.system(size: 13))
                .foregroundColor(.claimTextSecondary)
                .lineLimit(2)

            // Progress Bar
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { step in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(step <= legalCase.status.step ? Color.claimPrimary : Color.claimBorder)
                            .frame(height: 4)
                    }
                }

                HStack {
                    Text("Last updated: \(legalCase.lastUpdated, formatter: relativeDateFormatter)")
                        .font(.system(size: 11))
                        .foregroundColor(.claimTextMuted)

                    Spacer()

                    Text("Step \(legalCase.status.step) of 5")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.claimTextSecondary)
                }
            }
        }
        .padding(16)
        .background(Color.claimCardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }
}

// MARK: - Account Benefit Row
struct AccountBenefitRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.claimPrimary)
                .frame(width: 24)

            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.claimTextSecondary)

            Spacer()
        }
    }
}

// MARK: - Settings Row
struct SettingsRow<Trailing: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    @ViewBuilder let trailing: () -> Trailing

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.claimPrimary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.claimTextPrimary)

                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.claimTextMuted)
            }

            Spacer()

            trailing()
        }
        .padding(16)
    }
}

// MARK: - Help Row
struct HelpRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.claimPrimary)
                .frame(width: 24)

            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.claimTextPrimary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.claimTextMuted)
        }
        .padding(16)
    }
}

// MARK: - Date Formatters
private let monthYearFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    return formatter
}()

private let relativeDateFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .abbreviated
    return formatter
}()

#Preview {
    ContactView()
}
