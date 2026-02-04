//
//  VoiceRecordingView.swift
//  ClaimIt
//
//  Voice recording for accident details
//

import SwiftUI

struct VoiceRecordingView: View {
    @StateObject private var manager = AccidentModeManager.shared
    @State private var isRecording = false
    @State private var recordingDuration: TimeInterval = 0
    @State private var hasRecording = false
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 24) {
            // Title
            VStack(spacing: 8) {
                Text("Voice Recording")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(.white)

                Text("Record what happened while it's fresh")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.top, 16)

            Spacer()

            // Recording Circle
            ZStack {
                // Outer ring
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 4)
                    .frame(width: 200, height: 200)

                // Progress ring (when recording)
                if isRecording {
                    Circle()
                        .trim(from: 0, to: min(recordingDuration / 120, 1)) // Max 2 minutes
                        .stroke(Color(hex: "DC2626"), lineWidth: 4)
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: recordingDuration)
                }

                // Inner circle
                Circle()
                    .fill(isRecording ? Color(hex: "DC2626") : Color.white.opacity(0.1))
                    .frame(width: 180, height: 180)

                // Icon/Timer
                VStack(spacing: 8) {
                    if isRecording {
                        // Recording indicator
                        Circle()
                            .fill(Color.white)
                            .frame(width: 16, height: 16)
                            .opacity(recordingDuration.truncatingRemainder(dividingBy: 1) < 0.5 ? 1 : 0.5)
                    } else {
                        Image(systemName: hasRecording ? "checkmark" : "mic.fill")
                            .font(.system(size: 48))
                            .foregroundColor(hasRecording ? Color(hex: "00C48C") : .white)
                    }

                    Text(formatDuration(recordingDuration))
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                }
            }

            // Recording status
            Text(isRecording ? "Recording..." : (hasRecording ? "Recording saved" : "Tap to start"))
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))

            Spacer()

            // Tips
            VStack(alignment: .leading, spacing: 12) {
                Text("Tips for your recording:")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)

                tipRow(icon: "checkmark.circle", text: "Describe what happened in order")
                tipRow(icon: "checkmark.circle", text: "Include the time and location")
                tipRow(icon: "checkmark.circle", text: "Mention weather and road conditions")
                tipRow(icon: "xmark.circle", text: "Don't admit fault or apologize", isWarning: true)
            }
            .padding(16)
            .background(Color.white.opacity(0.1))
            .cornerRadius(16)
            .padding(.horizontal, 16)

            // Buttons
            VStack(spacing: 12) {
                // Record/Stop Button
                Button {
                    if isRecording {
                        stopRecording()
                    } else {
                        startRecording()
                    }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                            .font(.system(size: 20))
                        Text(isRecording ? "Stop Recording" : (hasRecording ? "Record Again" : "Start Recording"))
                            .font(.system(size: 17, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(isRecording ? Color(hex: "DC2626") : Color.white.opacity(0.2))
                    .cornerRadius(14)
                }
                .padding(.horizontal, 16)

                // Continue Button
                Button {
                    manager.nextStep()
                } label: {
                    Text(hasRecording ? "Continue" : "Skip for Now")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(hasRecording ? Color(hex: "00C48C") : Color.white.opacity(0.1))
                        .cornerRadius(14)
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 16)
        }
        .background(Color.black)
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func tipRow(icon: String, text: String, isWarning: Bool = false) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(isWarning ? Color(hex: "DC2626") : Color(hex: "00C48C"))
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.8))
        }
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func startRecording() {
        isRecording = true
        recordingDuration = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            recordingDuration += 0.1
        }
        // TODO: Implement actual audio recording
    }

    private func stopRecording() {
        isRecording = false
        timer?.invalidate()
        timer = nil
        hasRecording = true

        // Save recording info
        let path = "recordings/\(UUID().uuidString).m4a"
        manager.setVoiceRecording(localPath: path, duration: recordingDuration)
    }
}

#Preview {
    VoiceRecordingView()
}
