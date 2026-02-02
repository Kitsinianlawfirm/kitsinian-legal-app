//
//  OnboardingView.swift
//  KitsinianLegal
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0

    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Legal Help When You Need It",
            subtitle: "Get connected with the right attorney for your situation—fast and free.",
            icon: "hand.raised.fill",
            color: Color("Primary")
        ),
        OnboardingPage(
            title: "We Handle What We Do Best",
            subtitle: "Personal injury, premises liability, property damage, insurance disputes, and lemon law—we handle these directly.",
            icon: "checkmark.shield.fill",
            color: Color("Primary")
        ),
        OnboardingPage(
            title: "Trusted Referral Network",
            subtitle: "For other legal matters, we connect you with vetted California attorneys who specialize in your specific needs.",
            icon: "person.2.fill",
            color: Color("Secondary")
        ),
        OnboardingPage(
            title: "Free Legal Resources",
            subtitle: "Access guides, checklists, and know-your-rights information—no account required.",
            icon: "book.fill",
            color: Color("Primary")
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Page content
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Page indicator and button
            VStack(spacing: 24) {
                // Custom page indicator
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color("Primary") : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.2), value: currentPage)
                    }
                }

                // Continue / Get Started button
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        appState.hasCompletedOnboarding = true
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color("Primary"))
                        .cornerRadius(12)
                }

                // Skip button (not on last page)
                if currentPage < pages.count - 1 {
                    Button("Skip") {
                        appState.hasCompletedOnboarding = true
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
        .background(Color("Background"))
    }
}

// MARK: - Onboarding Page Model
struct OnboardingPage {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
}

// MARK: - Onboarding Page View
struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Icon
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.1))
                    .frame(width: 160, height: 160)

                Image(systemName: page.icon)
                    .font(.system(size: 64))
                    .foregroundColor(page.color)
            }

            // Text
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 32)

            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
