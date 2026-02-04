//
//  SafetyCheckView.swift
//  ClaimIt
//
//  Safety check - first step in accident mode
//

import SwiftUI

struct SafetyCheckView: View {
    @StateObject private var manager = AccidentModeManager.shared
    @State private var showingEmergencyAlert = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Icon
            ZStack {
                Circle()
                    .fill(Color(hex: "DC2626").opacity(0.2))
                    .frame(width: 120, height: 120)

                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 56))
                    .foregroundColor(Color(hex: "DC2626"))
            }

            // Title
            Text("Are You Safe?")
                .font(.system(size: 32, weight: .heavy))
                .foregroundColor(.white)

            Text("Your safety is the top priority.\nIf anyone is injured, call 911 first.")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()

            // Emergency Call Button
            Button {
                showingEmergencyAlert = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 20))
                    Text("Call 911")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color(hex: "DC2626"))
                .cornerRadius(16)
            }
            .padding(.horizontal, 24)
            .alert("Call Emergency Services?", isPresented: $showingEmergencyAlert) {
                Button("Call 911", role: .destructive) {
                    if let url = URL(string: "tel://911") {
                        UIApplication.shared.open(url)
                    }
                    manager.completeSafetyCheck(isSafe: false, calledEmergency: true)
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will dial 911 for emergency assistance.")
            }

            // Safe Button
            Button {
                manager.completeSafetyCheck(isSafe: true)
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 20))
                    Text("I'm Safe - Continue")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(Color(hex: "059669"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color(hex: "00C48C").opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "00C48C"), lineWidth: 2)
                )
                .cornerRadius(16)
            }
            .padding(.horizontal, 24)

            Spacer().frame(height: 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

#Preview {
    SafetyCheckView()
}
