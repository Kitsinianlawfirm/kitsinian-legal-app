//
//  QuizResultView.swift
//  ClaimIt
//

import SwiftUI

struct QuizResultView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let result: QuizResult?
    @State private var showingContactForm = false

    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }

    // Comfortable reading width for iPad
    private var maxContentWidth: CGFloat {
        isIPad ? 650 : .infinity
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: isIPad ? 28 : 20) {
                // Result Header
                resultHeader

                // Summary Card
                if let result = result {
                    summaryCard(result: result)
                }

                // Next Steps
                if let result = result {
                    nextStepsCard(result: result)
                }

                // CTA Buttons
                ctaButtons

                // Practice Area Info
                if let result = result {
                    practiceAreaPreview(result: result)
                }

                Spacer(minLength: 40)
            }
            .padding(isIPad ? 24 : 16)
            .frame(maxWidth: maxContentWidth)
            .frame(maxWidth: .infinity)
        }
        .background(Color.claimBackground)
        .sheet(isPresented: $showingContactForm) {
            NavigationStack {
                LeadFormView(practiceArea: result?.practiceArea)
            }
        }
    }

    // MARK: - Result Header
    private var resultHeader: some View {
        VStack(spacing: isIPad ? 24 : 20) {
            ZStack {
                Circle()
                    .fill(Color.claimSuccess.opacity(0.15))
                    .frame(width: isIPad ? 120 : 100, height: isIPad ? 120 : 100)

                GradientIconView(
                    systemName: "checkmark.circle.fill",
                    size: isIPad ? 88 : 72,
                    iconSize: isIPad ? 44 : 36,
                    gradient: LinearGradient.claimSuccessGradient
                )
            }

            Text("We Can Help!")
                .font(.system(size: isIPad ? 36 : 28, weight: .heavy))
                .foregroundColor(.claimTextPrimary)

            if let result = result {
                HStack(spacing: 8) {
                    Image(systemName: result.practiceArea.icon)
                        .font(.system(size: isIPad ? 18 : 16, weight: .semibold))
                    Text(result.practiceArea.name)
                        .font(.system(size: isIPad ? 18 : 16, weight: .bold))
                }
                .foregroundColor(.claimPrimary)
                .padding(.horizontal, isIPad ? 24 : 20)
                .padding(.vertical, isIPad ? 14 : 12)
                .background(Color.claimPrimary.opacity(0.1))
                .cornerRadius(24)
            }
        }
        .padding(.vertical, isIPad ? 20 : 16)
    }

    // MARK: - Summary Card
    private func summaryCard(result: QuizResult) -> some View {
        VStack(alignment: .leading, spacing: isIPad ? 18 : 14) {
            HStack(spacing: 10) {
                GradientIconView(
                    systemName: "doc.text.fill",
                    size: isIPad ? 40 : 36,
                    iconSize: isIPad ? 18 : 16,
                    gradient: LinearGradient.claimPrimaryGradient
                )
                Text("Your Situation")
                    .font(.system(size: isIPad ? 20 : 17, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
            }

            Text(result.summary)
                .font(.system(size: isIPad ? 17 : 15, weight: .medium))
                .foregroundColor(.claimTextSecondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(isIPad ? 20 : 16)
        .background(Color.claimCardBackground)
        .cornerRadius(isIPad ? 20 : 16)
        .overlay(
            RoundedRectangle(cornerRadius: isIPad ? 20 : 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }

    // MARK: - Next Steps Card
    private func nextStepsCard(result: QuizResult) -> some View {
        VStack(alignment: .leading, spacing: isIPad ? 20 : 16) {
            HStack(spacing: 10) {
                GradientIconView(
                    systemName: "arrow.right.circle.fill",
                    size: isIPad ? 40 : 36,
                    iconSize: isIPad ? 18 : 16,
                    gradient: LinearGradient.claimAccentGradient
                )
                Text("What Happens Next")
                    .font(.system(size: isIPad ? 20 : 17, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
            }

            VStack(alignment: .leading, spacing: isIPad ? 18 : 14) {
                ForEach(Array(result.nextSteps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: isIPad ? 16 : 14) {
                        Text("\(index + 1)")
                            .font(.system(size: isIPad ? 15 : 13, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: isIPad ? 32 : 28, height: isIPad ? 32 : 28)
                            .background(LinearGradient.claimPrimaryGradient)
                            .clipShape(Circle())

                        Text(step)
                            .font(.system(size: isIPad ? 17 : 15, weight: .medium))
                            .foregroundColor(.claimTextPrimary)
                            .padding(.top, isIPad ? 5 : 4)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(isIPad ? 20 : 16)
        .background(Color.claimCardBackground)
        .cornerRadius(isIPad ? 20 : 16)
        .overlay(
            RoundedRectangle(cornerRadius: isIPad ? 20 : 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }

    // MARK: - CTA Buttons
    private var ctaButtons: some View {
        VStack(spacing: isIPad ? 16 : 12) {
            Button(action: {
                showingContactForm = true
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: isIPad ? 20 : 18, weight: .bold))
                    Text("Request Free Consultation")
                        .font(.system(size: isIPad ? 18 : 17, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: isIPad ? 58 : 54)
                .background(LinearGradient.claimAccentGradient)
                .cornerRadius(isIPad ? 16 : 14)
                .shadow(color: .claimAccent.opacity(0.35), radius: 12, y: 6)
            }

            Button(action: {
                if let url = URL(string: "tel://+1YOURNUMBER") {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: isIPad ? 20 : 18, weight: .bold))
                    Text("Call Now")
                        .font(.system(size: isIPad ? 18 : 17, weight: .bold))
                }
                .foregroundColor(.claimPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: isIPad ? 58 : 54)
                .background(Color.claimCardBackground)
                .cornerRadius(isIPad ? 16 : 14)
                .overlay(
                    RoundedRectangle(cornerRadius: isIPad ? 16 : 14)
                        .stroke(Color.claimPrimary, lineWidth: 2)
                )
            }
        }
    }

    // MARK: - Practice Area Preview
    private func practiceAreaPreview(result: QuizResult) -> some View {
        VStack(alignment: .leading, spacing: isIPad ? 18 : 14) {
            Text("About This Practice Area")
                .font(.system(size: isIPad ? 20 : 17, weight: .bold))
                .foregroundColor(.claimTextPrimary)

            Text(result.practiceArea.fullDescription)
                .font(.system(size: isIPad ? 16 : 14, weight: .medium))
                .foregroundColor(.claimTextSecondary)
                .lineSpacing(4)

            NavigationLink(destination: PracticeAreaDetailView(practiceArea: result.practiceArea)) {
                HStack(spacing: 6) {
                    Text("Learn More")
                        .font(.system(size: isIPad ? 16 : 14, weight: .bold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: isIPad ? 14 : 12, weight: .bold))
                }
                .foregroundColor(.claimPrimary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(isIPad ? 20 : 16)
        .background(Color.claimCardBackground)
        .cornerRadius(isIPad ? 20 : 16)
        .overlay(
            RoundedRectangle(cornerRadius: isIPad ? 20 : 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }
}

#Preview {
    QuizResultView(result: QuizResult(
        practiceArea: .personalInjury,
        confidence: 0.9,
        summary: "Based on your answers, this appears to be a personal injury matter that we handle directly.",
        nextSteps: [
            "We'll review your case at no cost",
            "Free consultation with our team",
            "No fee unless we win your case"
        ]
    ))
}
