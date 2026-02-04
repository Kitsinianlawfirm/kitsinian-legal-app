//
//  QuizViewModel.swift
//  ClaimIt
//
//  Extracted ViewModel for Quiz flow management
//

import SwiftUI

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
        // These IDs must match the question IDs defined in Quiz.swift
        switch incidentType {
        case "car-accident":
            currentQuestionId = "injury_severity"  // Car accidents go to injury severity
        case "injury":
            currentQuestionId = "injury_type"  // General injury asks about type
        case "slip-fall":
            currentQuestionId = "fall_location"  // Slip/fall asks about location
        case "insurance":
            currentQuestionId = "insurance_type"  // Insurance asks about type
        case "lemon":
            currentQuestionId = "lemon_questions"  // Lemon asks about repair attempts
        case "property":
            currentQuestionId = "vehicle_type"  // Property damage asks about type
        default:
            currentQuestionId = "main_category"  // Default to main category
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
