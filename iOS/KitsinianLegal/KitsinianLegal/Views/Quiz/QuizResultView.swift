//
//  QuizResultView.swift
//  ClaimIt
//

import SwiftUI

struct QuizResultView: View {
    let result: QuizResult?
    @State private var showingContactForm = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
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
            .padding(16)
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
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.claimSuccess.opacity(0.15))
                    .frame(width: 100, height: 100)

                GradientIconView(
                    systemName: "checkmark.circle.fill",
                    size: 72,
                    iconSize: 36,
                    gradient: LinearGradient.claimSuccessGradient
                )
            }

            Text("We Can Help!")
                .font(.system(size: 28, weight: .heavy))
                .foregroundColor(.claimTextPrimary)

            if let result = result {
                HStack(spacing: 8) {
                    Image(systemName: result.practiceArea.icon)
                        .font(.system(size: 16, weight: .semibold))
                    Text(result.practiceArea.name)
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(.claimPrimary)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.claimPrimary.opacity(0.1))
                .cornerRadius(24)
            }
        }
        .padding(.vertical, 16)
    }

    // MARK: - Summary Card
    private func summaryCard(result: QuizResult) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                GradientIconView(
                    systemName: "doc.text.fill",
                    size: 36,
                    iconSize: 16,
                    gradient: LinearGradient.claimPrimaryGradient
                )
                Text("Your Situation")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
            }

            Text(result.summary)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.claimTextSecondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }

    // MARK: - Next Steps Card
    private func nextStepsCard(result: QuizResult) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                GradientIconView(
                    systemName: "arrow.right.circle.fill",
                    size: 36,
                    iconSize: 16,
                    gradient: LinearGradient.claimAccentGradient
                )
                Text("What Happens Next")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
            }

            VStack(alignment: .leading, spacing: 14) {
                ForEach(Array(result.nextSteps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 14) {
                        Text("\(index + 1)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 28, height: 28)
                            .background(LinearGradient.claimPrimaryGradient)
                            .clipShape(Circle())

                        Text(step)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.claimTextPrimary)
                            .padding(.top, 4)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }

    // MARK: - CTA Buttons
    private var ctaButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
                showingContactForm = true
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 18, weight: .bold))
                    Text("Request Free Consultation")
                        .font(.system(size: 17, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(LinearGradient.claimAccentGradient)
                .cornerRadius(14)
                .shadow(color: .claimAccent.opacity(0.35), radius: 12, y: 6)
            }

            Button(action: {
                if let url = URL(string: "tel://+1YOURNUMBER") {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 18, weight: .bold))
                    Text("Call Now")
                        .font(.system(size: 17, weight: .bold))
                }
                .foregroundColor(.claimPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color.white)
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.claimPrimary, lineWidth: 2)
                )
            }
        }
    }

    // MARK: - Practice Area Preview
    private func practiceAreaPreview(result: QuizResult) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("About This Practice Area")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.claimTextPrimary)

            Text(result.practiceArea.fullDescription)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.claimTextSecondary)
                .lineSpacing(4)

            NavigationLink(destination: PracticeAreaDetailView(practiceArea: result.practiceArea)) {
                HStack(spacing: 6) {
                    Text("Learn More")
                        .font(.system(size: 14, weight: .bold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(.claimPrimary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
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
