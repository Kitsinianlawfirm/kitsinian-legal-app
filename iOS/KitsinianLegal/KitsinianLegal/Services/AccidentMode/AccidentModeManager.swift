//
//  AccidentModeManager.swift
//  ClaimIt
//
//  Central manager for Accident Mode state and flow
//

import SwiftUI
import Combine

// MARK: - Accident Mode Manager
@MainActor
class AccidentModeManager: ObservableObject {
    // MARK: - Published Properties
    @Published var isEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isEnabled, forKey: "accidentModeEnabled")
        }
    }
    @Published var isActive: Bool = false
    @Published var currentStep: AccidentModeStep = .safetyCheck
    @Published var currentReport: AccidentReport?

    // MARK: - Steps
    enum AccidentModeStep: Int, CaseIterable {
        case safetyCheck = 0
        case photoCapture = 1
        case voiceRecording = 2
        case witnessInfo = 3
        case reminders = 4
        case review = 5
        case success = 6

        var title: String {
            switch self {
            case .safetyCheck: return "Safety Check"
            case .photoCapture: return "Photo Evidence"
            case .voiceRecording: return "Voice Recording"
            case .witnessInfo: return "Witness Info"
            case .reminders: return "Critical Reminders"
            case .review: return "Review Evidence"
            case .success: return "Submitted"
            }
        }

        var progress: Double {
            Double(self.rawValue) / Double(AccidentModeStep.allCases.count - 1)
        }
    }

    // MARK: - Singleton
    static let shared = AccidentModeManager()

    // MARK: - Initialization
    private init() {
        self.isEnabled = UserDefaults.standard.bool(forKey: "accidentModeEnabled")
        // Default to enabled if not set
        if !UserDefaults.standard.bool(forKey: "accidentModeEnabledSet") {
            self.isEnabled = true
            UserDefaults.standard.set(true, forKey: "accidentModeEnabledSet")
        }
    }

    // MARK: - Flow Control
    func startAccidentMode() {
        guard isEnabled else { return }
        currentReport = AccidentReport()
        currentStep = .safetyCheck
        isActive = true
    }

    func exitAccidentMode() {
        isActive = false
        // Don't clear report - user might want to resume
    }

    func goToStep(_ step: AccidentModeStep) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = step
        }
    }

    func nextStep() {
        guard let nextIndex = AccidentModeStep.allCases.firstIndex(of: currentStep)?.advanced(by: 1),
              nextIndex < AccidentModeStep.allCases.count else { return }
        goToStep(AccidentModeStep.allCases[nextIndex])
    }

    func previousStep() {
        guard let prevIndex = AccidentModeStep.allCases.firstIndex(of: currentStep)?.advanced(by: -1),
              prevIndex >= 0 else { return }
        goToStep(AccidentModeStep.allCases[prevIndex])
    }

    // MARK: - Safety Check
    func completeSafetyCheck(isSafe: Bool, calledEmergency: Bool = false) {
        currentReport?.safetyCheck = SafetyCheck(isSafe: isSafe, calledEmergency: calledEmergency)
        nextStep()
    }

    // MARK: - Photos
    func addPhoto(type: AccidentPhoto.PhotoType, localPath: String) {
        let photo = AccidentPhoto(type: type, localPath: localPath)
        currentReport?.photos.append(photo)
    }

    func hasPhoto(ofType type: AccidentPhoto.PhotoType) -> Bool {
        currentReport?.photos.contains { $0.type == type } ?? false
    }

    func photoCount() -> Int {
        currentReport?.photos.count ?? 0
    }

    // MARK: - Voice Recording
    func setVoiceRecording(localPath: String, duration: TimeInterval) {
        currentReport?.voiceRecording = VoiceRecording(
            localPath: localPath,
            duration: duration,
            recordedAt: Date()
        )
    }

    // MARK: - Witnesses
    func addWitness(name: String, phone: String, email: String? = nil, notes: String? = nil) {
        let witness = Witness(name: name, phone: phone, email: email, notes: notes)
        currentReport?.witnesses.append(witness)
    }

    func removeWitness(at index: Int) {
        guard let report = currentReport, index < report.witnesses.count else { return }
        currentReport?.witnesses.remove(at: index)
    }

    // MARK: - Reminders
    func acknowledgeReminders() {
        currentReport?.remindersAcknowledged = true
    }

    // MARK: - Submission
    func submitReport() async throws {
        guard var report = currentReport else { return }

        report.status = .submitted
        report.submittedAt = Date()
        currentReport = report

        // TODO: Upload to backend
        // try await APIService.shared.submitAccidentReport(report)

        goToStep(.success)
    }

    // MARK: - Reset
    func resetReport() {
        currentReport = nil
        currentStep = .safetyCheck
        isActive = false
    }

    // MARK: - Computed Properties
    var canProceedFromPhotos: Bool {
        photoCount() >= 3 // At least 3 photos required
    }

    var evidenceSummary: String {
        var parts: [String] = []
        if let count = currentReport?.photos.count, count > 0 {
            parts.append("\(count) photos")
        }
        if currentReport?.voiceRecording != nil {
            parts.append("voice memo")
        }
        if let count = currentReport?.witnesses.count, count > 0 {
            parts.append("\(count) witness\(count == 1 ? "" : "es")")
        }
        return parts.isEmpty ? "No evidence collected" : parts.joined(separator: ", ")
    }
}
