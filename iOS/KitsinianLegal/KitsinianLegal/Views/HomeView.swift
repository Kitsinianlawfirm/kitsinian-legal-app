//
//  HomeView.swift
//  KitsinianLegal
//

import SwiftUI

struct HomeView: View {
    @State private var showingQuiz = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Hero Section
                    heroSection

                    // Quick Actions
                    quickActionsSection

                    // What We Handle Section
                    whatWeHandleSection

                    // Referral Network Section
                    referralNetworkSection

                    // Featured Resources Section
                    featuredResourcesSection
                }
                .padding(.bottom, 32)
            }
            .background(Color("Background"))
            .navigationTitle("Kitsinian Law")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: 16) {
            Text("Need Legal Help?")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Find out if you have a case in 2 minutes")
                .font(.subheadline)
                .foregroundColor(.secondary)

            NavigationLink(destination: QuizStartView()) {
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                    Text("Start Free Case Evaluation")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color("Primary"))
                .cornerRadius(12)
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
        .padding(.horizontal)
    }

    // MARK: - Quick Actions
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    QuickActionCard(
                        icon: "phone.fill",
                        title: "Call Now",
                        subtitle: "Free consultation",
                        color: Color("Primary")
                    ) {
                        if let url = URL(string: "tel://+1YOURNUMBER") {
                            UIApplication.shared.open(url)
                        }
                    }

                    NavigationLink(destination: QuizStartView()) {
                        QuickActionCardContent(
                            icon: "questionmark.circle.fill",
                            title: "Case Quiz",
                            subtitle: "2 min evaluation",
                            color: Color("Secondary")
                        )
                    }

                    NavigationLink(destination: ResourceLibraryView()) {
                        QuickActionCardContent(
                            icon: "book.fill",
                            title: "Resources",
                            subtitle: "Free guides",
                            color: .blue
                        )
                    }

                    NavigationLink(destination: ContactView()) {
                        QuickActionCardContent(
                            icon: "envelope.fill",
                            title: "Contact",
                            subtitle: "Get in touch",
                            color: .green
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - What We Handle Section
    private var whatWeHandleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("What We Handle")
                    .font(.headline)

                Spacer()

                NavigationLink(destination: PracticeAreasListView(category: .inHouse)) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(Color("Primary"))
                }
            }
            .padding(.horizontal)

            VStack(spacing: 12) {
                ForEach(PracticeArea.inHouseAreas.prefix(3)) { area in
                    NavigationLink(destination: PracticeAreaDetailView(practiceArea: area)) {
                        PracticeAreaRow(practiceArea: area)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Referral Network Section
    private var referralNetworkSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Referral Network")
                    .font(.headline)

                Spacer()

                NavigationLink(destination: PracticeAreasListView(category: .referral)) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(Color("Primary"))
                }
            }
            .padding(.horizontal)

            Text("We partner with trusted California attorneys for cases outside our focus areas.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(PracticeArea.referralAreas.prefix(5)) { area in
                        NavigationLink(destination: PracticeAreaDetailView(practiceArea: area)) {
                            ReferralAreaCard(practiceArea: area)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Featured Resources Section
    private var featuredResourcesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Popular Resources")
                    .font(.headline)

                Spacer()

                NavigationLink(destination: ResourceLibraryView()) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(Color("Primary"))
                }
            }
            .padding(.horizontal)

            VStack(spacing: 12) {
                ForEach(LegalResource.featuredResources.prefix(3)) { resource in
                    NavigationLink(destination: ResourceDetailView(resource: resource)) {
                        ResourceRow(resource: resource)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Quick Action Card
struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            QuickActionCardContent(icon: icon, title: title, subtitle: subtitle, color: color)
        }
    }
}

struct QuickActionCardContent: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 100, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

// MARK: - Practice Area Row
struct PracticeAreaRow: View {
    let practiceArea: PracticeArea

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: practiceArea.icon)
                .font(.title2)
                .foregroundColor(Color("Primary"))
                .frame(width: 44, height: 44)
                .background(Color("Primary").opacity(0.1))
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 4) {
                Text(practiceArea.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(practiceArea.shortDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.03), radius: 5, y: 2)
    }
}

// MARK: - Referral Area Card
struct ReferralAreaCard: View {
    let practiceArea: PracticeArea

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: practiceArea.icon)
                .font(.title2)
                .foregroundColor(Color("Secondary"))

            Text(practiceArea.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(width: 120, height: 100, alignment: .topLeading)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

// MARK: - Resource Row
struct ResourceRow: View {
    let resource: LegalResource

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: resource.icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(resource.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                HStack {
                    Text(resource.category.displayName)
                        .font(.caption)
                        .foregroundColor(Color("Primary"))

                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("\(resource.readTime) min read")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.03), radius: 5, y: 2)
    }
}

#Preview {
    HomeView()
}
