//
//  QuizFlowView.swift
//  ClaimIt
//

import SwiftUI

struct QuizFlowView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = QuizViewModel()
    @State private var showingResult = false

    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }

    // Comfortable reading width for iPad
    private var maxContentWidth: CGFloat {
        isIPad ? 650 : .infinity
    }

    var body: some View {
        VStack(spacing: 0) {
            // Progress Bar
            VStack(spacing: 8) {
                HStack {
                    Text("Step \(viewModel.questionHistory.count + 1)")
                        .font(.system(size: isIPad ? 14 : 12, weight: .bold))
                        .foregroundColor(.claimPrimary)

                    Spacer()

                    Text("\(Int(viewModel.progress * 100))%")
                        .font(.system(size: isIPad ? 14 : 12, weight: .bold))
                        .foregroundColor(.claimTextMuted)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.claimBorder)
                            .frame(height: isIPad ? 10 : 8)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(LinearGradient.claimPrimaryGradient)
                            .frame(width: geometry.size.width * viewModel.progress, height: isIPad ? 10 : 8)
                    }
                }
                .frame(height: isIPad ? 10 : 8)
            }
            .frame(maxWidth: maxContentWidth)
            .padding(.horizontal, isIPad ? 32 : 20)
            .padding(.top, isIPad ? 24 : 16)
            .padding(.bottom, isIPad ? 28 : 20)
            .frame(maxWidth: .infinity)

            if viewModel.isComplete {
                QuizResultView(result: viewModel.result)
            } else if let currentQuestion = viewModel.currentQuestion {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: isIPad ? 32 : 24) {
                        // Question
                        VStack(alignment: .leading, spacing: isIPad ? 14 : 10) {
                            Text(currentQuestion.text)
                                .font(.system(size: isIPad ? 32 : 24, weight: .heavy))
                                .foregroundColor(.claimTextPrimary)
                                .lineSpacing(2)

                            if let subtext = currentQuestion.subtext {
                                Text(subtext)
                                    .font(.system(size: isIPad ? 17 : 15, weight: .medium))
                                    .foregroundColor(.claimTextSecondary)
                                    .lineSpacing(4)
                            }
                        }
                        .padding(.horizontal, isIPad ? 32 : 20)

                        // Options
                        VStack(spacing: isIPad ? 16 : 12) {
                            ForEach(currentQuestion.options) { option in
                                QuizOptionButton(
                                    option: option,
                                    isSelected: viewModel.selectedOptions.contains(option.id)
                                ) {
                                    viewModel.selectOption(option)
                                }
                            }
                        }
                        .padding(.horizontal, isIPad ? 24 : 16)

                        Spacer(minLength: 100)
                    }
                    .padding(.top, 8)
                    .frame(maxWidth: maxContentWidth)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .background(Color.claimBackground)
        .navigationTitle("Case Evaluation")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(viewModel.questionHistory.count > 0)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if viewModel.questionHistory.count > 0 {
                    Button(action: {
                        viewModel.goBack()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: isIPad ? 16 : 14, weight: .semibold))
                            Text("Back")
                                .font(.system(size: isIPad ? 18 : 16, weight: .medium))
                        }
                        .foregroundColor(.claimPrimary)
                    }
                }
            }
        }
        .onAppear {
            // If coming from onboarding with pre-selected incident
            if let incidentType = appState.selectedIncidentType {
                viewModel.setIncidentType(incidentType)
                appState.selectedIncidentType = nil
            }
        }
    }
}

// MARK: - Quiz Option Button
struct QuizOptionButton: View {
    let option: QuizOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                if let icon = option.icon {
                    GradientIconView(
                        systemName: icon,
                        size: 48,
                        iconSize: 22,
                        gradient: isSelected ? LinearGradient.claimAccentGradient : LinearGradient.claimPrimaryGradient
                    )
                }

                Text(option.text)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.claimTextPrimary)
                    .multilineTextAlignment(.leading)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.claimAccent)
                } else {
                    Circle()
                        .stroke(Color.claimBorder, lineWidth: 2)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(16)
            .background(isSelected ? Color.claimSelectedBackground : Color.claimCardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.claimAccent : Color.claimBorder, lineWidth: isSelected ? 2 : 1)
            )
            .claimShadowSmall()
        }
        .buttonStyle(.plain)
    }
}

// QuizViewModel is now in ViewModels/QuizViewModel.swift

#Preview {
    NavigationStack {
        QuizFlowView()
            .environmentObject(AppState())
    }
}
