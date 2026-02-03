//
//  QuizStartView.swift
//  ClaimIt
//

import SwiftUI

struct QuizStartView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    GradientIconView(
                        systemName: "bolt.fill",
                        size: 72,
                        iconSize: 36,
                        gradient: LinearGradient.claimAccentGradient
                    )

                    Text("Free Case Evaluation")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(.claimTextPrimary)

                    Text("Answer a few questions to understand your legal options and get connected with the right help.")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.claimTextSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 8)
                }
                .padding(.top, 32)
                .padding(.horizontal, 20)

                // Benefits
                VStack(spacing: 0) {
                    BenefitRow(icon: "clock.fill", text: "Takes less than 2 minutes", color: .claimPrimary)
                    Divider().padding(.leading, 56)
                    BenefitRow(icon: "lock.fill", text: "Your information is confidential", color: .claimPrimary)
                    Divider().padding(.leading, 56)
                    BenefitRow(icon: "dollarsign.circle.fill", text: "100% free, no obligation", color: .claimSuccess)
                    Divider().padding(.leading, 56)
                    BenefitRow(icon: "person.fill.checkmark", text: "Get matched with the right attorney", color: .claimPrimary)
                }
                .background(Color.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.claimBorder, lineWidth: 1)
                )
                .claimShadowSmall()
                .padding(.horizontal, 20)

                // Start Button
                NavigationLink(destination: QuizFlowView()) {
                    HStack(spacing: 10) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 18, weight: .bold))
                        Text("Start Evaluation")
                            .font(.system(size: 17, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(LinearGradient.claimAccentGradient)
                    .cornerRadius(14)
                    .shadow(color: .claimAccent.opacity(0.35), radius: 12, y: 6)
                }
                .padding(.horizontal, 20)

                // Disclaimer
                Text("This is not legal advice. Results are for informational purposes only.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.claimTextMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer(minLength: 40)
            }
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

    var body: some View {
        HStack(spacing: 16) {
            GradientIconView(
                systemName: icon,
                size: 40,
                iconSize: 18,
                gradient: LinearGradient(colors: [color, color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
            )

            Text(text)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.claimTextPrimary)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

#Preview {
    NavigationStack {
        QuizStartView()
            .environmentObject(AppState())
    }
}
