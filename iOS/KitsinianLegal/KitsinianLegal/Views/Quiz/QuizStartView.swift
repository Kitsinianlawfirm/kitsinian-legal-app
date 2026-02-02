//
//  QuizStartView.swift
//  KitsinianLegal
//

import SwiftUI

struct QuizStartView: View {
    @State private var isQuizActive = false

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(Color("Primary"))

                    Text("Free Case Evaluation")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Answer a few questions to understand your legal options and get connected with the right help.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 40)

                // Benefits
                VStack(alignment: .leading, spacing: 16) {
                    BenefitRow(icon: "clock.fill", text: "Takes less than 2 minutes")
                    BenefitRow(icon: "lock.fill", text: "Your information is confidential")
                    BenefitRow(icon: "dollarsign.circle.fill", text: "100% free, no obligation")
                    BenefitRow(icon: "person.fill.checkmark", text: "Get matched with the right attorney")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
                .padding(.horizontal)

                // Start Button
                NavigationLink(destination: QuizFlowView()) {
                    Text("Start Evaluation")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color("Primary"))
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                // Disclaimer
                Text("This is not legal advice. Results are for informational purposes only.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer(minLength: 40)
            }
        }
        .background(Color("Background"))
        .navigationTitle("Get Help")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BenefitRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color("Primary"))
                .frame(width: 32)

            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    NavigationStack {
        QuizStartView()
    }
}
