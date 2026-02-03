//
//  QuizFlowView.swift
//  ClaimIt
//

import SwiftUI

struct QuizFlowView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = QuizViewModel()
    @State private var showingResult = false

    var body: some View {
        VStack(spacing: 0) {
            // Progress Bar
            VStack(spacing: 8) {
                HStack {
                    Text("Step \(viewModel.questionHistory.count + 1)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.claimPrimary)

                    Spacer()

                    Text("\(Int(viewModel.progress * 100))%")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.claimTextMuted)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.claimBorder)
                            .frame(height: 8)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(LinearGradient.claimPrimaryGradient)
                            .frame(width: geometry.size.width * viewModel.progress, height: 8)
                    }
                }
                .frame(height: 8)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)

            if viewModel.isComplete {
                QuizResultView(result: viewModel.result)
            } else if let currentQuestion = viewModel.currentQuestion {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Question
                        VStack(alignment: .leading, spacing: 10) {
                            Text(currentQuestion.text)
                                .font(.system(size: 24, weight: .heavy))
                                .foregroundColor(.claimTextPrimary)
                                .lineSpacing(2)

                            if let subtext = currentQuestion.subtext {
                                Text(subtext)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.claimTextSecondary)
                                    .lineSpacing(4)
                            }
                        }
                        .padding(.horizontal, 20)

                        // Options
                        VStack(spacing: 12) {
                            ForEach(currentQuestion.options) { option in
                                QuizOptionButton(
                                    option: option,
                                    isSelected: viewModel.selectedOptions.contains(option.id)
                                ) {
                                    viewModel.selectOption(option)
                                }
                            }
                        }
                        .padding(.horizontal, 16)

                        Spacer(minLength: 100)
                    }
                    .padding(.top, 8)
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
                                .font(.system(size: 14, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 16, weight: .medium))
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
            .background(isSelected ? Color(hex: "FFF5F0") : Color.white)
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

// MARK: - Quiz ViewModel
class QuizViewModel: ObservableObject {
    @Published var currentQuestionId: String = "main_category"
    @Published var selectedOptions: Set<String> = []
    @Published var questionHistory: [String] = []
    @Published var answers: [String: Set<String>] = [:]
    @Published var isComplete = false
    @Published var result: QuizResult?

    var currentQuestion: QuizQuestion? {
        LegalQuiz.getQuestion(id: currentQuestionId)
    }

    var progress: Double {
        let totalQuestions = 4.0  // Average path length
        return min(Double(questionHistory.count + 1) / totalQuestions, 1.0)
    }

    func setIncidentType(_ incidentType: String) {
        // Map incident type to appropriate question flow
        switch incidentType {
        case "car-accident":
            currentQuestionId = "car_accident_details"
        case "injury":
            currentQuestionId = "injury_details"
        case "slip-fall":
            currentQuestionId = "premises_details"
        case "insurance":
            currentQuestionId = "insurance_details"
        case "lemon":
            currentQuestionId = "lemon_details"
        case "property":
            currentQuestionId = "property_details"
        default:
            currentQuestionId = "main_category"
        }
    }

    func selectOption(_ option: QuizOption) {
        selectedOptions.insert(option.id)
        answers[currentQuestionId] = selectedOptions

        // Small delay for visual feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.processSelection(option)
        }
    }

    private func processSelection(_ option: QuizOption) {
        // Check if this leads to a result
        if let resultAreaId = option.resultArea {
            completeQuiz(with: resultAreaId)
            return
        }

        // Check if this leads to another question
        if let nextQuestionId = option.leadsTo {
            questionHistory.append(currentQuestionId)
            selectedOptions = []
            currentQuestionId = nextQuestionId
        }
    }

    private func completeQuiz(with practiceAreaId: String) {
        guard let practiceArea = PracticeArea.allAreas.first(where: { $0.id == practiceAreaId }) else {
            return
        }

        let isInHouse = practiceArea.category == .inHouse
        let summary = isInHouse
            ? "Based on your answers, this appears to be a \(practiceArea.name.lowercased()) matter that we handle directly."
            : "Based on your answers, this appears to be a \(practiceArea.name.lowercased()) matter. We can connect you with a trusted specialist."

        let nextSteps: [String] = isInHouse
            ? [
                "We'll review your case at no cost",
                "Free consultation with our team",
                "No fee unless we win your case"
            ]
            : [
                "We'll connect you with a vetted attorney",
                "Your consultation may be free or low-cost",
                "We follow up to ensure quality service"
            ]

        result = QuizResult(
            practiceArea: practiceArea,
            confidence: 0.9,
            summary: summary,
            nextSteps: nextSteps
        )

        withAnimation {
            isComplete = true
        }
    }

    func goBack() {
        guard let previousQuestionId = questionHistory.popLast() else { return }
        selectedOptions = answers[previousQuestionId] ?? []
        currentQuestionId = previousQuestionId
        answers.removeValue(forKey: currentQuestionId)
    }

    func reset() {
        currentQuestionId = "main_category"
        selectedOptions = []
        questionHistory = []
        answers = [:]
        isComplete = false
        result = nil
    }
}

#Preview {
    NavigationStack {
        QuizFlowView()
            .environmentObject(AppState())
    }
}
