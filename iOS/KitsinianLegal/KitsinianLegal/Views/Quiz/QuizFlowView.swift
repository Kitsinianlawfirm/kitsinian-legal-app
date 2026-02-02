//
//  QuizFlowView.swift
//  KitsinianLegal
//

import SwiftUI

struct QuizFlowView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = QuizViewModel()
    @State private var showingResult = false

    var body: some View {
        VStack(spacing: 0) {
            // Progress Bar
            ProgressView(value: viewModel.progress)
                .tint(Color("Primary"))
                .padding(.horizontal)
                .padding(.top, 8)

            if viewModel.isComplete {
                QuizResultView(result: viewModel.result)
            } else if let currentQuestion = viewModel.currentQuestion {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Question
                        VStack(alignment: .leading, spacing: 8) {
                            Text(currentQuestion.text)
                                .font(.title2)
                                .fontWeight(.semibold)

                            if let subtext = currentQuestion.subtext {
                                Text(subtext)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.top, 24)
                        .padding(.horizontal)

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
                        .padding(.horizontal)

                        Spacer(minLength: 100)
                    }
                }
            }
        }
        .background(Color("Background"))
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
                            Text("Back")
                        }
                    }
                }
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
            HStack(spacing: 16) {
                if let icon = option.icon {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(isSelected ? .white : Color("Primary"))
                        .frame(width: 44, height: 44)
                        .background(isSelected ? Color("Primary") : Color("Primary").opacity(0.1))
                        .cornerRadius(10)
                }

                Text(option.text)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
                    .multilineTextAlignment(.leading)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(isSelected ? Color("Primary") : Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
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
    }
}
