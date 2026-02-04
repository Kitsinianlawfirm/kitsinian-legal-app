//
//  QuizStartView.swift
//  ClaimIt
//

import SwiftUI

struct QuizStartView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject var appState: AppState

    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }

    // Comfortable reading width for iPad
    private var maxContentWidth: CGFloat {
        isIPad ? 600 : .infinity
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: isIPad ? 32 : 24) {
                // Header
                VStack(spacing: isIPad ? 20 : 16) {
                    GradientIconView(
                        systemName: "bolt.fill",
                        size: isIPad ? 88 : 72,
                        iconSize: isIPad ? 44 : 36,
                        gradient: LinearGradient.claimAccentGradient
                    )

                    Text("Free Case Evaluation")
                        .font(.system(size: isIPad ? 36 : 28, weight: .heavy))
                        .foregroundColor(.claimTextPrimary)

                    Text("Answer a few questions to understand your legal options and get connected with the right help.")
                        .font(.system(size: isIPad ? 17 : 15, weight: .medium))
                        .foregroundColor(.claimTextSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 8)
                }
                .padding(.top, isIPad ? 48 : 32)
                .padding(.horizontal, isIPad ? 24 : 20)

                // Benefits
                VStack(spacing: 0) {
                    BenefitRow(icon: "clock.fill", text: "Takes less than 2 minutes", color: .claimPrimary, isIPad: isIPad)
                    Divider().padding(.leading, isIPad ? 64 : 56)
                    BenefitRow(icon: "lock.fill", text: "Your information is confidential", color: .claimPrimary, isIPad: isIPad)
                    Divider().padding(.leading, isIPad ? 64 : 56)
                    BenefitRow(icon: "dollarsign.circle.fill", text: "100% free, no obligation", color: .claimSuccess, isIPad: isIPad)
                    Divider().padding(.leading, isIPad ? 64 : 56)
                    BenefitRow(icon: "person.fill.checkmark", text: "Get matched with the right attorney", color: .claimPrimary, isIPad: isIPad)
                }
                .background(Color.claimCardBackground)
                .cornerRadius(isIPad ? 20 : 16)
                .overlay(
                    RoundedRectangle(cornerRadius: isIPad ? 20 : 16)
                        .stroke(Color.claimBorder, lineWidth: 1)
                )
                .claimShadowSmall()
                .padding(.horizontal, isIPad ? 24 : 20)

                // Start Button
                NavigationLink(destination: QuizFlowView()) {
                    HStack(spacing: 10) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: isIPad ? 20 : 18, weight: .bold))
                        Text("Start Evaluation")
                            .font(.system(size: isIPad ? 18 : 17, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: isIPad ? 58 : 54)
                    .background(LinearGradient.claimAccentGradient)
                    .cornerRadius(isIPad ? 16 : 14)
                    .shadow(color: .claimAccent.opacity(0.35), radius: 12, y: 6)
                }
                .padding(.horizontal, isIPad ? 24 : 20)

                // Disclaimer
                Text("This is not legal advice. Results are for informational purposes only.")
                    .font(.system(size: isIPad ? 14 : 12, weight: .medium))
                    .foregroundColor(.claimTextMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, isIPad ? 40 : 32)

                Spacer(minLength: 40)
            }
            .frame(maxWidth: maxContentWidth)
            .frame(maxWidth: .infinity)
        }
        .background(Color.claimBackground)
        .navigationTitle("Claim")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BenefitRow: View {
    let icon: String
    let text: String
    var color: Color = .claimPrimary
    var isIPad: Bool = false

    var body: some View {
        HStack(spacing: isIPad ? 18 : 16) {
            GradientIconView(
                systemName: icon,
                size: isIPad ? 44 : 40,
                iconSize: isIPad ? 20 : 18,
                gradient: LinearGradient(colors: [color, color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
            )

            Text(text)
                .font(.system(size: isIPad ? 17 : 15, weight: .semibold))
                .foregroundColor(.claimTextPrimary)

            Spacer()
        }
        .padding(.horizontal, isIPad ? 20 : 16)
        .padding(.vertical, isIPad ? 16 : 14)
    }
}

#Preview {
    NavigationStack {
        QuizStartView()
            .environmentObject(AppState())
    }
}
