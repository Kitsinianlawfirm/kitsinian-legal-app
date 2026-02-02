//
//  QuizResultView.swift
//  KitsinianLegal
//

import SwiftUI

struct QuizResultView: View {
    let result: QuizResult?
    @State private var showingContactForm = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
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
            .padding()
        }
        .background(Color("Background"))
        .sheet(isPresented: $showingContactForm) {
            NavigationStack {
                LeadFormView(practiceArea: result?.practiceArea)
            }
        }
    }

    // MARK: - Result Header
    private var resultHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color("Primary").opacity(0.1))
                    .frame(width: 100, height: 100)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(Color("Primary"))
            }

            Text("We Can Help")
                .font(.title)
                .fontWeight(.bold)

            if let result = result {
                HStack {
                    Image(systemName: result.practiceArea.icon)
                    Text(result.practiceArea.name)
                }
                .font(.headline)
                .foregroundColor(Color("Primary"))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color("Primary").opacity(0.1))
                .cornerRadius(20)
            }
        }
        .padding(.top, 20)
    }

    // MARK: - Summary Card
    private func summaryCard(result: QuizResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Your Situation", systemImage: "doc.text.fill")
                .font(.headline)
                .foregroundColor(Color("Primary"))

            Text(result.summary)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }

    // MARK: - Next Steps Card
    private func nextStepsCard(result: QuizResult) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("What Happens Next", systemImage: "arrow.right.circle.fill")
                .font(.headline)
                .foregroundColor(Color("Primary"))

            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(result.nextSteps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Color("Primary"))
                            .clipShape(Circle())

                        Text(step)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }

    // MARK: - CTA Buttons
    private var ctaButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
                showingContactForm = true
            }) {
                HStack {
                    Image(systemName: "envelope.fill")
                    Text("Request Free Consultation")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color("Primary"))
                .cornerRadius(12)
            }

            Button(action: {
                if let url = URL(string: "tel://+1YOURNUMBER") {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack {
                    Image(systemName: "phone.fill")
                    Text("Call Now")
                }
                .font(.headline)
                .foregroundColor(Color("Primary"))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("Primary"), lineWidth: 2)
                )
                .cornerRadius(12)
            }
        }
    }

    // MARK: - Practice Area Preview
    private func practiceAreaPreview(result: QuizResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About This Practice Area")
                .font(.headline)

            Text(result.practiceArea.fullDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)

            NavigationLink(destination: PracticeAreaDetailView(practiceArea: result.practiceArea)) {
                Text("Learn More")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Primary"))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
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
