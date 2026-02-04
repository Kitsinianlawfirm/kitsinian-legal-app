//
//  EvidenceReviewView.swift
//  ClaimIt
//
//  Review collected evidence before submission
//

import SwiftUI

struct EvidenceReviewView: View {
    @StateObject private var manager = AccidentModeManager.shared
    @State private var isSubmitting = false

    var body: some View {
        VStack(spacing: 0) {
            // Title
            VStack(spacing: 8) {
                Text("Review Evidence")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(.white)

                Text("Review what you've collected before submitting")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.top, 16)
            .padding(.bottom, 20)

            // Content
            ScrollView {
                VStack(spacing: 16) {
                    // Photos Section
                    evidenceSection(
                        icon: "camera.fill",
                        title: "Photos",
                        count: manager.currentReport?.photos.count ?? 0,
                        description: photosDescription,
                        color: Color(hex: "3B82F6")
                    )

                    // Voice Recording Section
                    evidenceSection(
                        icon: "mic.fill",
                        title: "Voice Recording",
                        count: manager.currentReport?.voiceRecording != nil ? 1 : 0,
                        description: voiceDescription,
                        color: Color(hex: "8B5CF6")
                    )

                    // Witnesses Section
                    evidenceSection(
                        icon: "person.2.fill",
                        title: "Witnesses",
                        count: manager.currentReport?.witnesses.count ?? 0,
                        description: witnessesDescription,
                        color: Color(hex: "F59E0B")
                    )

                    // Timestamp
                    if let report = manager.currentReport {
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.white.opacity(0.5))
                                Text("Evidence collected at:")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            Text(report.createdAt, style: .date)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            Text(report.createdAt, style: .time)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.top, 16)
                    }

                    // Disclaimer
                    Text("By submitting, you agree to share this evidence with Kitsinian Law Firm for case evaluation. This does not create an attorney-client relationship.")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }

            // Submit Button
            VStack(spacing: 12) {
                Button {
                    submitEvidence()
                } label: {
                    HStack(spacing: 10) {
                        if isSubmitting {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 18))
                        }
                        Text(isSubmitting ? "Submitting..." : "Submit Evidence")
                            .font(.system(size: 17, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "00C48C"), Color(hex: "00A876")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(14)
                }
                .disabled(isSubmitting)
                .padding(.horizontal, 16)

                // Edit button
                Button {
                    manager.goToStep(.photoCapture)
                } label: {
                    Text("Go Back and Edit")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(.vertical, 16)
            .background(Color.black.opacity(0.9))
        }
        .background(Color.black)
    }

    private func evidenceSection(icon: String, title: String, count: Int, description: String, color: Color) -> some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    if count > 0 {
                        Text("(\(count))")
                            .font(.system(size: 14))
                            .foregroundColor(color)
                    }
                }
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            // Status
            Image(systemName: count > 0 ? "checkmark.circle.fill" : "minus.circle")
                .font(.system(size: 24))
                .foregroundColor(count > 0 ? Color(hex: "00C48C") : .white.opacity(0.3))
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(14)
    }

    // MARK: - Computed Properties

    private var photosDescription: String {
        let count = manager.currentReport?.photos.count ?? 0
        if count == 0 {
            return "No photos captured"
        }
        return "\(count) photo\(count == 1 ? "" : "s") of the scene"
    }

    private var voiceDescription: String {
        if let recording = manager.currentReport?.voiceRecording {
            let minutes = Int(recording.duration) / 60
            let seconds = Int(recording.duration) % 60
            return String(format: "%d:%02d recording", minutes, seconds)
        }
        return "No recording made"
    }

    private var witnessesDescription: String {
        let count = manager.currentReport?.witnesses.count ?? 0
        if count == 0 {
            return "No witness contacts"
        }
        return "\(count) witness\(count == 1 ? "" : "es") documented"
    }

    // MARK: - Actions

    private func submitEvidence() {
        isSubmitting = true
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000) // Simulate network delay
            try? await manager.submitReport()
            isSubmitting = false
        }
    }
}

#Preview {
    EvidenceReviewView()
}
