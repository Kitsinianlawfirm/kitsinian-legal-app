//
//  OnboardingView.swift
//  ClaimIt
//
//  Modern 3-screen onboarding flow with legal agreement
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentScreen = 1
    @State private var selectedIncident: IncidentType?
    @State private var hasScrolledToBottom = false
    @State private var hasAgreedToTerms = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient.claimHeroGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if currentScreen == 1 {
                    legalAgreementScreen
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                } else if currentScreen == 2 {
                    welcomeScreen
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                } else {
                    incidentSelectionScreen
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                }
            }
        }
        .animation(.easeInOut(duration: 0.35), value: currentScreen)
    }

    // MARK: - Screen 1: Legal Agreement
    private var legalAgreementScreen: some View {
        VStack(spacing: 0) {
            // Mini logo
            ClaimItLogo(size: 40, showText: false)
                .padding(.top, 16)
                .padding(.bottom, 12)

            // Title
            Text("User Agreement")
                .font(.system(size: 22, weight: .heavy))
                .foregroundColor(.white)

            Text("Please review and scroll to continue")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .padding(.bottom, 16)

            // Scrollable legal text
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        legalAgreementContent

                        // Bottom marker for scroll detection
                        Color.clear
                            .frame(height: 1)
                            .id("bottomMarker")
                    }
                    .padding(20)
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: geometry.frame(in: .named("scroll")).maxY
                            )
                        }
                    )
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { maxY in
                    // Check if user has scrolled to near bottom (within 50 points)
                    if maxY < 450 && !hasScrolledToBottom {
                        hasScrolledToBottom = true
                    }
                }
            }
            .background(Color.claimCardBackground)
            .cornerRadius(20)
            .padding(.horizontal, 16)

            // Scroll indicator
            if !hasScrolledToBottom {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 12, weight: .bold))
                    Text("Scroll to read full agreement")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(.white.opacity(0.8))
                .padding(.top, 12)
            }

            Spacer()

            // CTA Section
            VStack(spacing: 14) {
                // Page dots
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.white)
                        .frame(width: 24, height: 8)

                    Circle()
                        .fill(.white.opacity(0.35))
                        .frame(width: 8, height: 8)

                    Circle()
                        .fill(.white.opacity(0.35))
                        .frame(width: 8, height: 8)
                }
                .padding(.bottom, 4)

                // Agreement checkbox
                Button(action: {
                    if hasScrolledToBottom {
                        hasAgreedToTerms.toggle()
                    }
                }) {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(hasAgreedToTerms ? Color.white : Color.white.opacity(0.5), lineWidth: 2)
                                .frame(width: 24, height: 24)

                            if hasAgreedToTerms {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }

                        Text("I agree to the Terms of Service and Privacy Policy")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)

                        Spacer()
                    }
                }
                .opacity(hasScrolledToBottom ? 1 : 0.5)
                .disabled(!hasScrolledToBottom)

                // Continue button
                Button(action: {
                    currentScreen = 2
                }) {
                    Text("I Have Read and Agree")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(hasAgreedToTerms ? .claimPrimary : .claimPrimary.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(hasAgreedToTerms ? Color.white : Color.white.opacity(0.5))
                        .cornerRadius(14)
                        .claimShadowLarge()
                }
                .disabled(!hasAgreedToTerms)

                // Legal ad notice
                Text("ADVERTISEMENT: Kitsinian Law Firm, APC, Los Angeles, CA")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.top, 8)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Legal Agreement Content
    private var legalAgreementContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Terms of Service
            VStack(alignment: .leading, spacing: 8) {
                Text("Terms of Service")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.claimTextPrimary)

                Text("By using ClaimIt, you agree to these terms. This app provides information and connects you with legal services but does not constitute legal advice or create an attorney-client relationship until you formally retain an attorney.")
                    .font(.system(size: 13))
                    .foregroundColor(.claimTextSecondary)
                    .lineSpacing(4)
            }

            Divider()

            // Attorney Advertising Notice
            VStack(alignment: .leading, spacing: 8) {
                Text("Attorney Advertising Notice")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.claimTextPrimary)

                Text("This is an advertisement for legal services. The information contained in this app is intended for general informational purposes and should not be construed as legal advice. Past results do not guarantee future outcomes.")
                    .font(.system(size: 13))
                    .foregroundColor(.claimTextSecondary)
                    .lineSpacing(4)
            }

            Divider()

            // CA Rule 7.3 Consent (Important!)
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.shield.fill")
                        .foregroundColor(.claimAccent)
                    Text("California Rule 7.3 Consent")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.claimTextPrimary)
                }

                Text("By proceeding, you consent to be contacted by Kitsinian Law Firm, APC or its network of affiliated attorneys regarding potential legal representation. You understand that you may receive communications about your legal matter including case evaluation, settlement opportunities, and legal updates.")
                    .font(.system(size: 13))
                    .foregroundColor(.claimTextSecondary)
                    .lineSpacing(4)

                Text("You may opt out of communications at any time by contacting us or using the settings in this app.")
                    .font(.system(size: 13))
                    .foregroundColor(.claimTextSecondary)
                    .lineSpacing(4)
            }

            Divider()

            // Privacy Policy
            VStack(alignment: .leading, spacing: 8) {
                Text("Privacy Policy")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.claimTextPrimary)

                Text("We collect personal information you provide, including name, contact details, and case information. This data is used to evaluate your case and connect you with legal services. We do not sell your personal information.")
                    .font(.system(size: 13))
                    .foregroundColor(.claimTextSecondary)
                    .lineSpacing(4)

                Text("California residents have additional rights under the CCPA including the right to know, delete, and opt-out of data sales.")
                    .font(.system(size: 13))
                    .foregroundColor(.claimTextSecondary)
                    .lineSpacing(4)
            }

            Divider()

            // Accident Mode Consent
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "car.fill")
                        .foregroundColor(.claimPrimary)
                    Text("Accident Mode")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.claimTextPrimary)
                }

                Text("By agreeing, Accident Mode will be enabled by default. This feature helps you collect evidence after an accident including photos, voice recordings, and witness information. You can disable this feature at any time in Settings or the Accident tab.")
                    .font(.system(size: 13))
                    .foregroundColor(.claimTextSecondary)
                    .lineSpacing(4)
            }

            Divider()

            // No Fee Unless You Win
            VStack(alignment: .leading, spacing: 8) {
                Text("No Fee Unless You Win")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.claimTextPrimary)

                Text("For contingency fee cases, attorney fees are only charged if compensation is recovered. Case costs (filing fees, expert fees, etc.) may apply separately. Fee arrangements will be clearly explained before you retain an attorney.")
                    .font(.system(size: 13))
                    .foregroundColor(.claimTextSecondary)
                    .lineSpacing(4)
            }
        }
    }

    // MARK: - Screen 2: Welcome & Trust
    private var welcomeScreen: some View {
        VStack(spacing: 0) {
            Spacer()

            // Logo
            VStack(spacing: 12) {
                ClaimItLogo(size: 56)

                Text("Your Fight. Our Fury.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(.bottom, 32)

            // Trust Badges
            HStack(spacing: 12) {
                TrustBadge(value: "$50M+", label: "Recovered", compact: true)
                TrustBadge(value: "5000+", label: "Cases Won", compact: true)
                TrustBadge(value: "98%", label: "Success", compact: true)
            }
            .padding(.bottom, 28)

            // Value Props
            VStack(spacing: 10) {
                ValuePropRow(icon: "dollarsign.circle.fill", text: "$0 upfront. We only get paid when you do.")
                ValuePropRow(icon: "clock.fill", text: "90-second claim check — no paperwork")
                ValuePropRow(icon: "shield.fill", text: "Aggressive attorneys who've recovered $50M+")
            }
            .padding(.horizontal, 20)

            Spacer()

            // CTA Section
            VStack(spacing: 14) {
                // Page dots
                HStack(spacing: 8) {
                    Circle()
                        .fill(.white.opacity(0.35))
                        .frame(width: 8, height: 8)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(.white)
                        .frame(width: 24, height: 8)

                    Circle()
                        .fill(.white.opacity(0.35))
                        .frame(width: 8, height: 8)
                }
                .padding(.bottom, 4)

                // Check If You Qualify button
                Button(action: {
                    currentScreen = 3
                }) {
                    HStack(spacing: 10) {
                        Text("Check If You Qualify")
                            .font(.system(size: 17, weight: .bold))

                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.claimPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.white)
                    .cornerRadius(14)
                    .claimShadowLarge()
                }

                // Skip link
                Button("I'll explore first") {
                    appState.hasCompletedOnboarding = true
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.75))
                .padding(.top, 4)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Screen 3: Incident Selection
    private var incidentSelectionScreen: some View {
        VStack(spacing: 0) {
            // Mini logo
            ClaimItLogo(size: 40, showText: false)
                .padding(.top, 16)
                .padding(.bottom, 16)

            // Question
            VStack(spacing: 6) {
                Text("What happened to you?")
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundColor(.white)

                Text("Select to start your free case review")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.bottom, 20)

            // Incident Options Grid
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10)
                ], spacing: 10) {
                    ForEach(IncidentType.allCases) { incident in
                        IncidentOptionCard(
                            incident: incident,
                            isSelected: selectedIncident == incident
                        ) {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selectedIncident = incident
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }

            Spacer()

            // CTA Section
            VStack(spacing: 14) {
                // Page dots
                HStack(spacing: 8) {
                    Circle()
                        .fill(.white.opacity(0.35))
                        .frame(width: 8, height: 8)

                    Circle()
                        .fill(.white.opacity(0.35))
                        .frame(width: 8, height: 8)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(.white)
                        .frame(width: 24, height: 8)
                }
                .padding(.bottom, 4)

                // Calculate My Compensation button
                Button(action: {
                    if let incident = selectedIncident {
                        appState.startQuizWithIncident(incident.rawValue)
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 18, weight: .bold))

                        Text("Calculate My Compensation")
                            .font(.system(size: 17, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        LinearGradient.claimAccentGradient
                            .opacity(selectedIncident != nil ? 1 : 0.5)
                    )
                    .cornerRadius(14)
                    .shadow(color: .claimAccent.opacity(selectedIncident != nil ? 0.35 : 0), radius: 12, y: 6)
                }
                .disabled(selectedIncident == nil)

                // Skip link
                Button("Skip for now") {
                    appState.hasCompletedOnboarding = true
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.75))
                .padding(.top, 4)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Scroll Offset Preference Key
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Incident Types
enum IncidentType: String, CaseIterable, Identifiable {
    case carAccident = "car-accident"
    case injury = "injury"
    case slipFall = "slip-fall"
    case insurance = "insurance"
    case lemon = "lemon"
    case property = "property"
    case other = "other"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .carAccident: return "Car Accident"
        case .injury: return "I Was Injured"
        case .slipFall: return "Slip & Fall"
        case .insurance: return "Insurance Issue"
        case .lemon: return "Lemon Vehicle"
        case .property: return "Property Damage"
        case .other: return "Something Else"
        }
    }

    var icon: String {
        switch self {
        case .carAccident: return "car.fill"
        case .injury: return "cross.case.fill"
        case .slipFall: return "figure.fall"
        case .insurance: return "shield.fill"
        case .lemon: return "car.badge.gearshape.fill"
        case .property: return "house.fill"
        case .other: return "questionmark.circle.fill"
        }
    }

    var isFullWidth: Bool {
        self == .other
    }
}

// MARK: - Value Prop Row
struct ValuePropRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient.claimPrimaryGradient)
                    .frame(width: 42, height: 42)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }

            Text(text)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.claimTextPrimary)

            Spacer()
        }
        .padding(14)
        .background(Color.claimCardBackground)
        .cornerRadius(14)
        .claimShadowSmall()
    }
}

// MARK: - Incident Option Card
struct IncidentOptionCard: View {
    let incident: IncidentType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: incident.icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(isSelected ? .claimAccent : .claimPrimary)

                Text(incident.title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: incident.isFullWidth ? 50 : 90)
            .padding(.vertical, incident.isFullWidth ? 8 : 16)
            .padding(.horizontal, 12)
            .background(isSelected ? Color(hex: "FFF5F0") : Color.claimCardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.claimAccent : Color.clear, lineWidth: 3)
            )
            .claimShadowSmall()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
