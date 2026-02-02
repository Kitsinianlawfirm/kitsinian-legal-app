//
//  ContentView.swift
//  KitsinianLegal
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: Tab = .home

    enum Tab {
        case home
        case quiz
        case resources
        case contact
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
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(Tab.home)

            QuizStartView()
                .tabItem {
                    Image(systemName: "questionmark.circle.fill")
                    Text("Get Help")
                }
                .tag(Tab.quiz)

            ResourceLibraryView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Resources")
                }
                .tag(Tab.resources)

            ContactView()
                .tabItem {
                    Image(systemName: "phone.fill")
                    Text("Contact")
                }
                .tag(Tab.contact)
        }
        .tint(Color("Primary"))
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
