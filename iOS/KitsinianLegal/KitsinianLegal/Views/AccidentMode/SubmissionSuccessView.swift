//
//  SubmissionSuccessView.swift
//  ClaimIt
//
//  Success screen after evidence submission
//

import SwiftUI

struct SubmissionSuccessView: View {
    @StateObject private var manager = AccidentModeManager.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Success Animation
            ZStack {
                Circle()
                    .fill(Color(hex: "00C48C").opacity(0.2))
                    .frame(width: 140, height: 140)

                Circle()
                    .fill(Color(hex: "00C48C"))
                    .frame(width: 100, height: 100)

                Image(systemName: "checkmark")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
            }

            // Title
            VStack(spacing: 8) {
                Text("Evidence Submitted!")
                    .font(.system(size: 32, weight: .heavy))
                    .foregroundColor(.white)

                Text("Your evidence has been securely sent to our team")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            // Summary
            VStack(spacing: 8) {
                Text(manager.evidenceSummary)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "00C48C"))

                if let report = manager.currentReport, let submittedAt = report.submittedAt {
                    Text("Submitted at \(submittedAt, style: .time)")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.5))
                }
            }

            Spacer()

            // Next Steps Card
            VStack(alignment: .leading, spacing: 16) {
                Text("What Happens Next")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)

                nextStepRow(number: 1, text: "Our team will review your evidence")
                nextStepRow(number: 2, text: "An attorney will contact you within 24 hours")
                nextStepRow(number: 3, text: "We'll discuss your options at no cost")
            }
            .padding(20)
            .background(Color.white.opacity(0.08))
            .cornerRadius(16)
            .padding(.horizontal, 16)

            // Emergency Contact
            VStack(spacing: 8) {
                Text("Need immediate assistance?")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.5))

                Button {
                    if let url = URL(string: "tel://1234567890") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(Color(hex: "00C48C"))
                        Text("(XXX) XXX-XXXX")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.top, 8)

            Spacer()

            // Done Button
            Button {
                manager.resetReport()
                dismiss()
            } label: {
                Text("Done")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(hex: "00C48C"))
                    .cornerRadius(14)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color.black)
    }

    private func nextStepRow(number: Int, text: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(hex: "00C48C"))
                    .frame(width: 28, height: 28)
                Text("\(number)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }

            Text(text)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.85))

            Spacer()
        }
    }
}

#Preview {
    SubmissionSuccessView()
}
