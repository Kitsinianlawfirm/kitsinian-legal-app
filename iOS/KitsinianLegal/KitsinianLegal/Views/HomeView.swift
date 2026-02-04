//
//  HomeView.swift
//  ClaimIt
//

import SwiftUI

struct HomeView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Hero Section with gradient
                    heroSection

                    // Content
                    VStack(spacing: isIPad ? 32 : 20) {
                        // Quick Actions
                        quickActionsSection

                        // What We Fight For
                        whatWeFightForSection

                        // Referral Network
                        referralNetworkSection

                        // Popular Resources
                        popularResourcesSection
                    }
                    .padding(.top, -20)
                    .padding(.bottom, 32)
                }
                .frame(maxWidth: isIPad ? 900 : .infinity)
                .frame(maxWidth: .infinity)
            }
            .background(Color.claimBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ClaimItLogo(size: 32, textColor: .claimTextPrimary)
                }
            }
        }
    }

    // MARK: - Hero Section
    private var heroSection: some View {
        ZStack(alignment: .bottom) {
            // Gradient background
            LinearGradient.claimHeroGradient
                .frame(height: isIPad ? 340 : 280)

            VStack(spacing: isIPad ? 20 : 16) {
                // Badge
                HStack(spacing: 6) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: isIPad ? 14 : 12, weight: .bold))
                    Text("Free Case Evaluation")
                        .font(.system(size: isIPad ? 14 : 12, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, isIPad ? 18 : 14)
                .padding(.vertical, isIPad ? 10 : 8)
                .background(.white.opacity(0.2))
                .cornerRadius(20)

                // Title
                Text("Get What You\nDeserve")
                    .font(.system(size: isIPad ? 42 : 30, weight: .heavy))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .lineSpacing(2)

                // Subtitle
                Text("Find out if you have a case in 2 minutes")
                    .font(.system(size: isIPad ? 18 : 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))

                // Stats Row
                HStack(spacing: isIPad ? 16 : 10) {
                    StatBadge(value: "$50M+", label: "Recovered")
                    StatBadge(value: "5000+", label: "Cases")
                    StatBadge(value: "98%", label: "Success")
                }
                .padding(.top, 8)
            }
            .padding(.bottom, 50)

            // CTA Card
            VStack {
                NavigationLink(destination: QuizStartView()) {
                    HStack(spacing: 10) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: isIPad ? 20 : 18, weight: .bold))
                        Text("Start My Free Claim Review")
                            .font(.system(size: isIPad ? 18 : 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: isIPad ? 400 : .infinity)
                    .frame(height: isIPad ? 56 : 52)
                    .background(LinearGradient.claimAccentGradient)
                    .cornerRadius(14)
                    .shadow(color: .claimAccent.opacity(0.35), radius: 12, y: 6)
                }
            }
            .padding(isIPad ? 20 : 16)
            .background(Color.white)
            .cornerRadius(20)
            .claimShadowLarge()
            .padding(.horizontal, isIPad ? 32 : 16)
            .offset(y: 30)
        }
    }

    // MARK: - Quick Actions
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.claimTextPrimary)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    QuickActionButton(
                        icon: "phone.fill",
                        title: "Call Now",
                        subtitle: "Talk to us"
                    ) {
                        if let url = URL(string: "tel://+1YOURNUMBER") {
                            UIApplication.shared.open(url)
                        }
                    }

                    NavigationLink(destination: ContactView()) {
                        QuickActionContent(icon: "bubble.left.fill", title: "Live Chat", subtitle: "Instant help")
                    }

                    NavigationLink(destination: ResourceLibraryView()) {
                        QuickActionContent(icon: "book.fill", title: "Guides", subtitle: "Free resources")
                    }

                    QuickActionButton(
                        icon: "location.fill",
                        title: "Track Case",
                        subtitle: "Status updates"
                    ) {
                        // Track case action
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 40)
    }

    // MARK: - What We Fight For
    private var whatWeFightForSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("We Fight For")
                    .font(.system(size: isIPad ? 20 : 17, weight: .bold))
                    .foregroundColor(.claimTextPrimary)

                Spacer()

                NavigationLink(destination: PracticeAreasListView(category: .inHouse)) {
                    HStack(spacing: 2) {
                        Text("See All")
                            .font(.system(size: isIPad ? 15 : 13, weight: .semibold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: isIPad ? 13 : 11, weight: .semibold))
                    }
                    .foregroundColor(.claimPrimary)
                }
            }
            .padding(.horizontal, isIPad ? 24 : 20)

            if isIPad {
                // iPad: Grid layout
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 320, maximum: 400), spacing: 16)], spacing: 16) {
                    ForEach(PracticeArea.inHouseAreas.prefix(5)) { area in
                        NavigationLink(destination: PracticeAreaDetailView(practiceArea: area)) {
                            PracticeAreaCard(practiceArea: area, showTopBadge: area == PracticeArea.inHouseAreas.first)
                        }
                    }
                }
                .padding(.horizontal, 20)
            } else {
                // iPhone: Vertical list
                VStack(spacing: 10) {
                    ForEach(PracticeArea.inHouseAreas.prefix(5)) { area in
                        NavigationLink(destination: PracticeAreaDetailView(practiceArea: area)) {
                            PracticeAreaCard(practiceArea: area, showTopBadge: area == PracticeArea.inHouseAreas.first)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: - Referral Network
    private var referralNetworkSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Referral Network")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.claimTextPrimary)

                Spacer()

                NavigationLink(destination: PracticeAreasListView(category: .referral)) {
                    HStack(spacing: 2) {
                        Text("See All")
                            .font(.system(size: 13, weight: .semibold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(.claimPrimary)
                }
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(PracticeArea.referralAreas.prefix(5)) { area in
                        NavigationLink(destination: PracticeAreaDetailView(practiceArea: area)) {
                            ReferralCard(practiceArea: area)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Popular Resources
    private var popularResourcesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Popular Resources")
                    .font(.system(size: isIPad ? 20 : 17, weight: .bold))
                    .foregroundColor(.claimTextPrimary)

                Spacer()

                NavigationLink(destination: ResourceLibraryView()) {
                    HStack(spacing: 2) {
                        Text("See All")
                            .font(.system(size: isIPad ? 15 : 13, weight: .semibold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: isIPad ? 13 : 11, weight: .semibold))
                    }
                    .foregroundColor(.claimPrimary)
                }
            }
            .padding(.horizontal, isIPad ? 24 : 20)

            if isIPad {
                // iPad: Grid layout
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 320, maximum: 400), spacing: 16)], spacing: 16) {
                    ForEach(LegalResource.featuredResources.prefix(4)) { resource in
                        NavigationLink(destination: ResourceDetailView(resource: resource)) {
                            ResourceCard(resource: resource)
                        }
                    }
                }
                .padding(.horizontal, 20)
            } else {
                // iPhone: Vertical list
                VStack(spacing: 10) {
                    ForEach(LegalResource.featuredResources.prefix(3)) { resource in
                        NavigationLink(destination: ResourceDetailView(resource: resource)) {
                            ResourceCard(resource: resource)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - Stat Badge
struct StatBadge: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 20, weight: .heavy))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.white.opacity(0.15))
        .cornerRadius(12)
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            QuickActionContent(icon: icon, title: title, subtitle: subtitle)
        }
    }
}

struct QuickActionContent: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 8) {
            GradientIconView(systemName: icon, size: 44, iconSize: 20)

            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.claimTextPrimary)

            Text(subtitle)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.claimTextMuted)
        }
        .frame(width: 90)
        .padding(.vertical, 14)
        .padding(.horizontal, 12)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }
}

// MARK: - Practice Area Card
struct PracticeAreaCard: View {
    let practiceArea: PracticeArea
    var showTopBadge: Bool = false

    var body: some View {
        HStack(spacing: 14) {
            GradientIconView(systemName: practiceArea.icon, size: 48, iconSize: 22)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 8) {
                    Text(practiceArea.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.claimTextPrimary)

                    if showTopBadge {
                        HStack(spacing: 3) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 8, weight: .bold))
                            Text("Top")
                                .font(.system(size: 9, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(LinearGradient.claimSuccessGradient)
                        .cornerRadius(5)
                    }
                }

                Text(practiceArea.shortDescription)
                    .font(.system(size: 13))
                    .foregroundColor(.claimTextSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.claimTextMuted)
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }
}

// MARK: - Referral Card
struct ReferralCard: View {
    let practiceArea: PracticeArea

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            GradientIconView(
                systemName: practiceArea.icon,
                size: 40,
                iconSize: 18,
                gradient: LinearGradient.claimAccentGradient
            )

            Text(practiceArea.name)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.claimTextPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .frame(width: 110, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }
}

// MARK: - Resource Card
struct ResourceCard: View {
    let resource: LegalResource

    var body: some View {
        HStack(spacing: 14) {
            GradientIconView(
                systemName: resource.icon,
                size: 50,
                iconSize: 24,
                gradient: resource.gradient
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(resource.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text(resource.category.displayName)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.claimPrimary)

                    Text("\(resource.readTime) min")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.claimTextMuted)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.claimTextMuted)
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }
}

// MARK: - Resource Gradient Extension
extension LegalResource {
    var gradient: LinearGradient {
        switch category {
        case .guide:
            return LinearGradient.claimSuccessGradient
        case .checklist:
            return LinearGradient.claimPrimaryGradient
        case .rights:
            return LinearGradient(colors: [Color(hex: "9333EA"), Color(hex: "A855F7")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .faq:
            return LinearGradient(colors: [.claimWarning, Color(hex: "FBBF24")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .timeline:
            return LinearGradient.claimAccentGradient
        }
    }
}

#Preview {
    HomeView()
}
