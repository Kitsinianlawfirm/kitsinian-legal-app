//
//  ContentView.swift
//  ClaimIt
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: Tab = .home

    enum Tab: String {
        case home = "Home"
        case claim = "Claim"
        case learn = "Learn"
        case contact = "Contact"

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .claim: return "bolt.fill"
            case .learn: return "book.fill"
            case .contact: return "bubble.left.fill"
            }
        }
    }

    var body: some View {
        Group {
            if !appState.hasCompletedOnboarding {
                OnboardingView()
            } else {
                mainTabView
            }
        }
    }

    private var mainTabView: some View {
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
