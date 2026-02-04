//
//  RemindersView.swift
//  ClaimIt
//
//  Critical DO's and DON'Ts reminders
//

import SwiftUI

struct RemindersView: View {
    @StateObject private var manager = AccidentModeManager.shared
    @State private var acknowledgedDos = false
    @State private var acknowledgedDonts = false

    var canContinue: Bool {
        acknowledgedDos && acknowledgedDonts
    }

    var body: some View {
        VStack(spacing: 0) {
            // Title
            VStack(spacing: 8) {
                Text("Critical Reminders")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(.white)

                Text("Protect your case by following these guidelines")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.top, 16)
            .padding(.bottom, 20)

            // Content
            ScrollView {
                VStack(spacing: 20) {
                    // DO's Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "checkmark.shield.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "00C48C"))
                            Text("DO")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(hex: "00C48C"))
                            Spacer()
                        }

                        ForEach(CriticalReminders.dos, id: \.text) { item in
                            reminderRow(icon: item.icon, text: item.text, isPositive: true)
                        }

                        // Acknowledge checkbox
                        Button {
                            acknowledgedDos.toggle()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: acknowledgedDos ? "checkmark.square.fill" : "square")
                                    .font(.system(size: 22))
                                    .foregroundColor(acknowledgedDos ? Color(hex: "00C48C") : .white.opacity(0.5))
                                Text("I understand these guidelines")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(16)
                    .background(Color(hex: "00C48C").opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "00C48C").opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(16)

                    // DON'Ts Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "xmark.shield.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "DC2626"))
                            Text("DON'T")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(hex: "DC2626"))
                            Spacer()
                        }

                        ForEach(CriticalReminders.donts, id: \.text) { item in
                            reminderRow(icon: item.icon, text: item.text, isPositive: false)
                        }

                        // Acknowledge checkbox
                        Button {
                            acknowledgedDonts.toggle()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: acknowledgedDonts ? "checkmark.square.fill" : "square")
                                    .font(.system(size: 22))
                                    .foregroundColor(acknowledgedDonts ? Color(hex: "DC2626") : .white.opacity(0.5))
                                Text("I understand what NOT to do")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(16)
                    .background(Color(hex: "DC2626").opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "DC2626").opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(16)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }

            // Continue Button
            Button {
                manager.acknowledgeReminders()
                manager.nextStep()
            } label: {
                Text(canContinue ? "Continue to Review" : "Acknowledge All to Continue")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(canContinue ? Color(hex: "00C48C") : Color.white.opacity(0.2))
                    .cornerRadius(14)
            }
            .disabled(!canContinue)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.black.opacity(0.9))
        }
        .background(Color.black)
    }

    private func reminderRow(icon: String, text: String, isPositive: Bool) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(isPositive ? Color(hex: "00C48C") : Color(hex: "DC2626"))
                .frame(width: 24)

            Text(text)
                .font(.system(size: 15))
                .foregroundColor(.white)

            Spacer()
        }
    }
}

#Preview {
    RemindersView()
}
