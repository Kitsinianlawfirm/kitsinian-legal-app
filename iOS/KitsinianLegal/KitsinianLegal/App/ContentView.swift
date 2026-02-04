//
//  ContentView.swift
//  ClaimIt
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selectedTab: Tab = .home

    enum Tab: String, CaseIterable {
        case home = "Home"
        case claim = "Claim"
        case learn = "Learn"
        case accident = "Accident"
        case contact = "Account"

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .claim: return "bolt.fill"
            case .learn: return "book.fill"
            case .accident: return "exclamationmark.triangle.fill"
            case .contact: return "person.fill"
            }
        }
    }

    var body: some View {
        Group {
            if !appState.hasCompletedOnboarding {
                OnboardingView()
            } else {
                if horizontalSizeClass == .regular {
                    iPadNavigationView
                } else {
                    iPhoneTabView
                }
            }
        }
    }

    // MARK: - iPad Navigation (Sidebar)
    private var iPadNavigationView: some View {
        NavigationSplitView {
            List(Tab.allCases, id: \.self, selection: $selectedTab) { tab in
                Label(tab.rawValue, systemImage: tab.icon)
                    .tag(tab)
            }
            .navigationTitle("ClaimIt")
            .listStyle(.sidebar)
        } detail: {
            NavigationStack {
                selectedView
            }
        }
        .tint(.claimPrimary)
        .onAppear {
            if appState.selectedIncidentType != nil {
                selectedTab = .claim
            }
        }
    }

    @ViewBuilder
    private var selectedView: some View {
        switch selectedTab {
        case .home:
            HomeView()
        case .claim:
            QuizStartView()
        case .learn:
            ResourceLibraryView()
        case .accident:
            AccidentModeTabView()
        case .contact:
            ContactView()
        }
    }

    // MARK: - iPhone Navigation (Bottom Tabs)
    private var iPhoneTabView: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(Tab.home.rawValue, systemImage: Tab.home.icon)
                }
                .tag(Tab.home)

            QuizStartView()
                .tabItem {
                    Label(Tab.claim.rawValue, systemImage: Tab.claim.icon)
                }
                .tag(Tab.claim)

            ResourceLibraryView()
                .tabItem {
                    Label(Tab.learn.rawValue, systemImage: Tab.learn.icon)
                }
                .tag(Tab.learn)

            AccidentModeTabView()
                .tabItem {
                    Label(Tab.accident.rawValue, systemImage: Tab.accident.icon)
                }
                .tag(Tab.accident)

            ContactView()
                .tabItem {
                    Label(Tab.contact.rawValue, systemImage: Tab.contact.icon)
                }
                .tag(Tab.contact)
        }
        .tint(.claimPrimary)
        .onAppear {
            // Check if we should jump to quiz from onboarding
            if appState.selectedIncidentType != nil {
                selectedTab = .claim
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
