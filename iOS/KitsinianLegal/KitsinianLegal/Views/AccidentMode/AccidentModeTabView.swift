//
//  AccidentModeTabView.swift
//  ClaimIt
//
//  Main Accident Mode tab - settings, status, and manual entry
//

import SwiftUI

struct AccidentModeTabView: View {
    @StateObject private var manager = AccidentModeManager.shared
    @State private var showingAccidentFlow = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    headerSection

                    // Status Card
                    statusCard
                        .padding(.horizontal, 16)
                        .padding(.top, -20)

                    // Info Section
                    infoSection
                        .padding(.horizontal, 16)
                        .padding(.top, 20)

                    // Enter Button
                    enterButton
                        .padding(.horizontal, 16)
                        .padding(.top, 8)

                    Spacer(minLength: 100)
                }
            }
            .background(Color.claimBackground)
            .ignoresSafeArea(edges: .top)
            .fullScreenCover(isPresented: $showingAccidentFlow) {
                AccidentModeFlowView()
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        ZStack {
            // Red gradient background
            LinearGradient(
                colors: [Color(hex: "DC2626"), Color(hex: "B91C1C")],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 200)

            VStack(spacing: 8) {
                Spacer().frame(height: 60)

                // Icon and title
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 24))
                    Text("Accident Mode")
                        .font(.system(size: 20, weight: .heavy))
                }
                .foregroundColor(.white)

                Text("Emergency Evidence")
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundColor(.white)

                Text("Capture critical information after an accident")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.85))

                Spacer()
            }
        }
    }

    // MARK: - Status Card
    private var statusCard: some View {
        VStack(spacing: 16) {
            // Status Badge
            HStack(spacing: 8) {
                Image(systemName: manager.isEnabled ? "checkmark.circle.fill" : "minus.circle.fill")
                    .font(.system(size: 16))
                Text(manager.isEnabled ? "Enabled & Ready" : "Disabled")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(manager.isEnabled ? Color(hex: "059669") : Color.claimTextMuted)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                manager.isEnabled
                    ? Color(hex: "00C48C").opacity(0.15)
                    : Color.gray.opacity(0.15)
            )
            .cornerRadius(20)

            Text("When enabled, you'll receive a notification to quickly collect evidence if an accident is detected.")
                .font(.system(size: 14))
                .foregroundColor(.claimTextSecondary)
                .multilineTextAlignment(.center)

            // Toggle
            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Accident Mode")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.claimTextPrimary)
                    Text("Enable crash detection alerts")
                        .font(.system(size: 13))
                        .foregroundColor(.claimTextMuted)
                }
                Spacer()
                Toggle("", isOn: $manager.isEnabled)
                    .labelsHidden()
                    .tint(Color(hex: "00C48C"))
            }
            .padding(.top, 8)
        }
        .padding(24)
        .background(Color.claimCardBackground)
        .cornerRadius(20)
        .claimShadowMedium()
    }

    // MARK: - Info Section
    private var infoSection: some View {
        VStack(spacing: 16) {
            // How It Works
            infoCard(
                icon: "info.circle",
                title: "How It Works",
                content: """
                When an accident is detected or you manually activate Accident Mode, ClaimIt guides you through collecting critical evidence:

                • **Photo Checklist** - Capture all necessary scene photos
                • **Voice Recording** - Record what happened while it's fresh
                • **Witness Info** - Collect contact details
                • **Critical Reminders** - Know what NOT to say
                """
            )

            // Automatic Detection
            infoCard(
                icon: "bell.badge",
                title: "Automatic Detection",
                content: "When enabled, ClaimIt can detect sudden impacts and send you an instant notification. Tap the notification to immediately start collecting evidence."
            )
        }
    }

    private func infoCard(icon: String, title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(Color(hex: "DC2626"))
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
            }

            Text(LocalizedStringKey(content))
                .font(.system(size: 14))
                .foregroundColor(.claimTextSecondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.claimCardBackground)
        .cornerRadius(16)
        .claimShadowSmall()
    }

    // MARK: - Enter Button
    private var enterButton: some View {
        VStack(spacing: 12) {
            Button {
                if manager.isEnabled {
                    manager.startAccidentMode()
                    showingAccidentFlow = true
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 20))
                    Text("Enter Accident Mode Now")
                        .font(.system(size: 17, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    manager.isEnabled
                        ? LinearGradient(
                            colors: [Color(hex: "DC2626"), Color(hex: "B91C1C")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                          )
                        : LinearGradient(
                            colors: [Color.gray, Color.gray],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                          )
                )
                .cornerRadius(16)
                .shadow(color: manager.isEnabled ? Color(hex: "DC2626").opacity(0.3) : .clear, radius: 8, y: 4)
            }
            .disabled(!manager.isEnabled)

            Text("Use this if you've just been in an accident")
                .font(.system(size: 12))
                .foregroundColor(.claimTextMuted)
        }
    }
}

#Preview {
    AccidentModeTabView()
}
