//
//  AccidentModeFlowView.swift
//  ClaimIt
//
//  Main flow controller for accident evidence collection
//

import SwiftUI

struct AccidentModeFlowView: View {
    @StateObject private var manager = AccidentModeManager.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Dark background
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header with progress
                headerView

                // Content based on current step
                TabView(selection: $manager.currentStep) {
                    SafetyCheckView()
                        .tag(AccidentModeManager.AccidentModeStep.safetyCheck)

                    PhotoCaptureView()
                        .tag(AccidentModeManager.AccidentModeStep.photoCapture)

                    VoiceRecordingView()
                        .tag(AccidentModeManager.AccidentModeStep.voiceRecording)

                    WitnessFormView()
                        .tag(AccidentModeManager.AccidentModeStep.witnessInfo)

                    RemindersView()
                        .tag(AccidentModeManager.AccidentModeStep.reminders)

                    EvidenceReviewView()
                        .tag(AccidentModeManager.AccidentModeStep.review)

                    SubmissionSuccessView()
                        .tag(AccidentModeManager.AccidentModeStep.success)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: manager.currentStep)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Header
    private var headerView: some View {
        VStack(spacing: 12) {
            // Status bar area
            HStack {
                // Exit button
                Button {
                    manager.exitAccidentMode()
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Exit")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(20)
                }

                Spacer()

                // Step indicator
                Text(manager.currentStep.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                // Placeholder for balance
                Color.clear
                    .frame(width: 60, height: 32)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Background
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 4)

                    // Progress
                    Capsule()
                        .fill(Color(hex: "DC2626"))
                        .frame(width: geo.size.width * manager.currentStep.progress, height: 4)
                        .animation(.easeInOut(duration: 0.3), value: manager.currentStep)
                }
            }
            .frame(height: 4)
            .padding(.horizontal, 16)

            // Step dots
            HStack(spacing: 8) {
                ForEach(Array(AccidentModeManager.AccidentModeStep.allCases.enumerated()), id: \.element) { index, step in
                    Circle()
                        .fill(step.rawValue <= manager.currentStep.rawValue ? Color(hex: "DC2626") : Color.white.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 8)
        }
        .background(
            LinearGradient(
                colors: [Color(hex: "DC2626"), Color(hex: "B91C1C")],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

#Preview {
    AccidentModeFlowView()
}
