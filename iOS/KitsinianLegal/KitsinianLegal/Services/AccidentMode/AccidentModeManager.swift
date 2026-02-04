//
//  AccidentModeManager.swift
//  ClaimIt
//
//  Central manager for Accident Mode state and flow
//

import SwiftUI
import Combine

// MARK: - Accident Mode Error
enum AccidentModeError: LocalizedError {
    case noReport
    case noPhotos
    case insufficientEvidence
    case safetyCheckIncomplete
    case submissionFailed(underlying: Error)
    case uploadFailed(photoType: String)

    var errorDescription: String? {
        switch self {
        case .noReport:
            return "No accident report to submit. Please start a new report."
        case .noPhotos:
            return "Please capture at least one photo before submitting."
        case .insufficientEvidence:
            return "Please collect more evidence before submitting."
        case .safetyCheckIncomplete:
            return "Please complete the safety check first."
        case .submissionFailed(let underlying):
            return "Failed to submit report: \(underlying.localizedDescription)"
        case .uploadFailed(let photoType):
            return "Failed to upload \(photoType) photo. Please try again."
        }
    }
}

// MARK: - Submission State
enum SubmissionState: Equatable {
    case idle
    case submitting
    case uploadingPhotos(current: Int, total: Int)
    case uploadingAudio
    case finalizing
    case success
    case failed(message: String)

    var displayMessage: String {
        switch self {
        case .idle:
            return ""
        case .submitting:
            return "Preparing submission..."
        case .uploadingPhotos(let current, let total):
            return "Uploading photos (\(current)/\(total))..."
        case .uploadingAudio:
            return "Uploading voice recording..."
        case .finalizing:
            return "Finalizing report..."
        case .success:
            return "Report submitted successfully!"
        case .failed(let message):
            return message
        }
    }
}

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
    @Published var submissionState: SubmissionState = .idle
    @Published var submissionError: AccidentModeError?

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
        submissionState = .idle
        submissionError = nil
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

    // MARK: - Validation
    func validateReportForSubmission() throws {
        guard let report = currentReport else {
            throw AccidentModeError.noReport
        }

        guard report.safetyCheck != nil else {
            throw AccidentModeError.safetyCheckIncomplete
        }

        guard !report.photos.isEmpty else {
            throw AccidentModeError.noPhotos
        }
    }

    // MARK: - Submission
    func submitReport() async throws {
        // Reset state
        submissionError = nil
        submissionState = .submitting

        do {
            // Validate before submission
            try validateReportForSubmission()

            guard var report = currentReport else {
                throw AccidentModeError.noReport
            }

            // Upload photos
            let totalPhotos = report.photos.count
            for (index, photo) in report.photos.enumerated() {
                submissionState = .uploadingPhotos(current: index + 1, total: totalPhotos)

                // Simulate photo upload (replace with actual upload logic)
                do {
                    try await simulatePhotoUpload(photo)
                    // In production: let url = try await uploadPhoto(photo)
                    // currentReport?.photos[index].uploadedURL = url
                } catch {
                    throw AccidentModeError.uploadFailed(photoType: photo.type.rawValue)
                }
            }

            // Upload voice recording if present
            if let recording = report.voiceRecording {
                submissionState = .uploadingAudio
                try await simulateAudioUpload(recording)
                // In production: let url = try await uploadAudio(recording)
                // currentReport?.voiceRecording?.uploadedURL = url
            }

            // Finalize report
            submissionState = .finalizing
            report.status = .submitted
            report.submittedAt = Date()
            currentReport = report

            // Submit to backend (will use retry logic from APIService)
            // In production: try await APIService.shared.submitAccidentReport(report)
            try await simulateBackendSubmission()

            // Success
            submissionState = .success
            goToStep(.success)
            AppConfiguration.log("Accident report submitted successfully")

        } catch let error as AccidentModeError {
            submissionError = error
            submissionState = .failed(message: error.localizedDescription)
            AppConfiguration.log("Accident report submission failed: \(error.localizedDescription)")
            throw error
        } catch {
            let wrappedError = AccidentModeError.submissionFailed(underlying: error)
            submissionError = wrappedError
            submissionState = .failed(message: wrappedError.localizedDescription)
            AppConfiguration.log("Accident report submission failed: \(error.localizedDescription)")
            throw wrappedError
        }
    }

    // MARK: - Simulated Uploads (Replace with actual implementation)
    private func simulatePhotoUpload(_ photo: AccidentPhoto) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
    }

    private func simulateAudioUpload(_ recording: VoiceRecording) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 800_000_000) // 0.8 seconds
    }

    private func simulateBackendSubmission() async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
    }

    // MARK: - Retry Submission
    func retrySubmission() async {
        do {
            try await submitReport()
        } catch {
            // Error already handled in submitReport
        }
    }

    // MARK: - Reset
    func resetReport() {
        currentReport = nil
        currentStep = .safetyCheck
        submissionState = .idle
        submissionError = nil
        isActive = false
    }

    // MARK: - Clear Error
    func clearError() {
        submissionError = nil
        if case .failed = submissionState {
            submissionState = .idle
        }
    }

    // MARK: - Computed Properties
    var canProceedFromPhotos: Bool {
        photoCount() >= 3 // At least 3 photos required
    }

    var isSubmitting: Bool {
        switch submissionState {
        case .submitting, .uploadingPhotos, .uploadingAudio, .finalizing:
            return true
        default:
            return false
        }
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
