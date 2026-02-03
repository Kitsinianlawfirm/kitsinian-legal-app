//
//  ClaimItApp.swift
//  ClaimIt
//
//  ClaimIt - Get What You Deserve
//  California Legal Triage & Referral Network
//

import SwiftUI

@main
struct ClaimItApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }
    @Published var currentLead: Lead?
    @Published var selectedPracticeArea: PracticeArea?
    @Published var selectedIncidentType: String?

    init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }

    func resetOnboarding() {
        hasCompletedOnboarding = false
    }

    func startQuizWithIncident(_ incidentType: String) {
        selectedIncidentType = incidentType
        hasCompletedOnboarding = true
    }
}
