//
//  OnboardingView.swift
//  ClaimIt
//
//  Modern 2-screen onboarding flow
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentScreen = 1
    @State private var selectedIncident: IncidentType?

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient.claimHeroGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if currentScreen == 1 {
                    onboardingScreen1
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                } else {
                    onboardingScreen2
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                }
            }
        }
        .animation(.easeInOut(duration: 0.35), value: currentScreen)
    }

    // MARK: - Screen 1: Trust & Value
    private var onboardingScreen1: some View {
        VStack(spacing: 0) {
            Spacer()

            // Logo
            VStack(spacing: 12) {
                ClaimItLogo(size: 56)

                Text("Get What You Deserve")
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
                ValuePropRow(icon: "dollarsign.circle.fill", text: "No fees unless you win your case")
                ValuePropRow(icon: "clock.fill", text: "Free case review in under 2 minutes")
                ValuePropRow(icon: "shield.fill", text: "Trusted California attorneys on your side")
            }
            .padding(.horizontal, 20)

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
                }
                .padding(.bottom, 4)

                // Get Started button
                Button(action: {
                    currentScreen = 2
                }) {
                    HStack(spacing: 10) {
                        Text("Get Started")
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

    // MARK: - Screen 2: Quick Quiz Start
    private var onboardingScreen2: some View {
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

                    RoundedRectangle(cornerRadius: 2)
                        .fill(.white)
                        .frame(width: 24, height: 8)
                }
                .padding(.bottom, 4)

                // Start Review button
                Button(action: {
                    if let incident = selectedIncident {
                        appState.startQuizWithIncident(incident.rawValue)
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 18, weight: .bold))

                        Text("Start My Free Review")
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
        case .lemon: return "exclamationmark.triangle.fill"
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
        .background(Color.white)
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
            .background(isSelected ? Color(hex: "FFF5F0") : Color.white)
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
