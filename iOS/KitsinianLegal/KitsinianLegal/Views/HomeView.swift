//
//  HomeView.swift
//  ClaimIt
//

import SwiftUI

struct HomeView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var showPrivacyPolicy = false
    @State private var showTermsOfService = false
    @State private var showDisclaimers = false

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

                        // Trust Seals
                        trustSealsSection

                        // Live Activity Feed (Social Proof)
                        liveActivityFeedSection

                        // What We Fight For
                        whatWeFightForSection

                        // Referral Network
                        referralNetworkSection

                        // How It Works
                        howItWorksSection

                        // Popular Resources
                        popularResourcesSection

                        // FAQ Section
                        faqSection

                        // Legal Footer
                        legalFooterSection
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

            VStack(spacing: isIPad ? 20 : 18) {
                // Badge
                HStack(spacing: 8) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: isIPad ? 15 : 13, weight: .bold))
                    Text("Free Case Evaluation")
                        .font(.system(size: isIPad ? 15 : 13, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, isIPad ? 20 : 16)
                .padding(.vertical, isIPad ? 12 : 10)
                .background(.white.opacity(0.2))
                .cornerRadius(24)

                // Title - matches HTML 34px on iPhone
                Text("Hurt in an Accident?\nGet Paid.")
                    .font(.system(size: isIPad ? 44 : 34, weight: .heavy))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .lineSpacing(4)

                // Subtitle - matches HTML 15px
                Text("The bills are piling up. The insurance company won't call back. We can help.")
                    .font(.system(size: isIPad ? 18 : 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

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
                    ShimmerCTAButton(
                        icon: "bolt.fill",
                        text: "Get My Free Case Review",
                        isIPad: isIPad
                    )
                }
            }
            .padding(isIPad ? 20 : 16)
            .background(Color.claimCardBackground)
            .cornerRadius(20)
            .claimShadowLarge()
            .padding(.horizontal, isIPad ? 32 : 16)
            .offset(y: 30)
        }
    }

    // MARK: - Quick Actions
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Quick Actions")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.claimTextPrimary)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    NavigationLink(destination: QuizStartView()) {
                        QuickActionContent(icon: "bolt.fill", title: "New Claim", subtitle: "Start review")
                    }

                    NavigationLink(destination: ResourceLibraryView()) {
                        QuickActionContent(icon: "book.fill", title: "Guides", subtitle: "Free resources")
                    }

                    NavigationLink(destination: ContactView()) {
                        QuickActionContent(icon: "briefcase.fill", title: "My Cases", subtitle: "Track status")
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 40)
    }

    // MARK: - What We Fight For
    private var whatWeFightForSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("We Fight For")
                    .font(.system(size: isIPad ? 22 : 18, weight: .bold))
                    .foregroundColor(.claimTextPrimary)

                Spacer()

                NavigationLink(destination: PracticeAreasListView(category: .inHouse)) {
                    HStack(spacing: 4) {
                        Text("See All")
                            .font(.system(size: isIPad ? 16 : 14, weight: .semibold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: isIPad ? 14 : 12, weight: .semibold))
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
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Referral Network")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.claimTextPrimary)

                Spacer()

                NavigationLink(destination: PracticeAreasListView(category: .referral)) {
                    HStack(spacing: 4) {
                        Text("See All")
                            .font(.system(size: 14, weight: .semibold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
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
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Popular Resources")
                    .font(.system(size: isIPad ? 22 : 18, weight: .bold))
                    .foregroundColor(.claimTextPrimary)

                Spacer()

                NavigationLink(destination: ResourceLibraryView()) {
                    HStack(spacing: 4) {
                        Text("See All")
                            .font(.system(size: isIPad ? 16 : 14, weight: .semibold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: isIPad ? 14 : 12, weight: .semibold))
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

    // MARK: - Trust Seals Section
    private var trustSealsSection: some View {
        HStack(spacing: isIPad ? 24 : 12) {
            TrustSealView(
                icon: "checkmark.shield.fill",
                title: "Verified",
                subtitle: "CA Attorneys",
                color: .claimSuccess
            )
            TrustSealView(
                icon: "lock.fill",
                title: "256-bit SSL",
                subtitle: "Encrypted",
                color: .claimPrimary
            )
            TrustSealView(
                icon: "doc.badge.checkmark.fill",
                title: "Bar Compliant",
                subtitle: "Ethical",
                color: .claimGold
            )
        }
        .padding(.horizontal, isIPad ? 24 : 16)
    }

    // MARK: - Live Activity Feed Section
    private var liveActivityFeedSection: some View {
        LiveActivityFeed()
            .padding(.horizontal, isIPad ? 24 : 16)
    }

    // MARK: - How It Works Section
    private var howItWorksSection: some View {
        VStack(spacing: 24) {
            VStack(spacing: 6) {
                Text("How It Works")
                    .font(.system(size: isIPad ? 22 : 20, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
                Text("Get help in 3 simple steps")
                    .font(.system(size: isIPad ? 16 : 14))
                    .foregroundColor(.claimTextSecondary)
            }

            HStack(spacing: isIPad ? 16 : 6) {
                HowItWorksStep(
                    number: 1,
                    icon: "doc.text.fill",
                    title: "Tell Us",
                    subtitle: "90 seconds, no paperwork"
                )

                // Connector line
                Rectangle()
                    .fill(Color.claimBorder)
                    .frame(height: 2)
                    .frame(maxWidth: isIPad ? 50 : 40)

                HowItWorksStep(
                    number: 2,
                    icon: "phone.fill",
                    title: "We Call",
                    subtitle: "A real attorney calls you back"
                )

                // Connector line
                Rectangle()
                    .fill(Color.claimBorder)
                    .frame(height: 2)
                    .frame(maxWidth: isIPad ? 50 : 40)

                HowItWorksStep(
                    number: 3,
                    icon: "shield.fill",
                    title: "We Win",
                    subtitle: "We fight until you get paid"
                )
            }
        }
        .padding(isIPad ? 28 : 24)
        .background(Color.claimCardBackground)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
        .padding(.horizontal, isIPad ? 24 : 16)
    }

    // MARK: - FAQ Section
    private var faqSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Common Questions")
                .font(.system(size: isIPad ? 22 : 18, weight: .bold))
                .foregroundColor(.claimTextPrimary)
                .padding(.horizontal, isIPad ? 24 : 20)

            VStack(spacing: 10) {
                FAQItemView(
                    question: "Do I have to pay anything upfront?",
                    answer: "Absolutely not. We work on contingency — meaning we only get paid if YOU get paid. If we don't win, you owe us nothing. Zero."
                )
                FAQItemView(
                    question: "How long does this take?",
                    answer: "The claim check takes 90 seconds. A real attorney (not a call center) will call you within 24 hours — usually much faster."
                )
                FAQItemView(
                    question: "Is my information private?",
                    answer: "Yes. Everything you share is protected by attorney-client privilege and 256-bit encryption. We never sell your information."
                )
                FAQItemView(
                    question: "What if I'm not sure I have a case?",
                    answer: "That's perfectly okay! Our free consultation exists to help you find out. There's no obligation — we'll honestly tell you if we can help."
                )
            }
            .padding(.horizontal, isIPad ? 24 : 16)
        }
    }

    // MARK: - Legal Footer Section
    private var legalFooterSection: some View {
        VStack(spacing: 14) {
            // Divider
            Rectangle()
                .fill(Color.claimBorder)
                .frame(height: 1)
                .padding(.horizontal, 16)

            // Copyright notice
            Text("© 2025 Kitsinian Law Firm, APC. This is attorney advertising. Results vary based on individual circumstances. Using this app does not create an attorney-client relationship.")
                .font(.system(size: 11))
                .foregroundColor(.claimTextMuted)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, 20)

            // Legal links
            HStack(spacing: 14) {
                Button("Privacy Policy") {
                    showPrivacyPolicy = true
                }
                Button("Terms of Service") {
                    showTermsOfService = true
                }
                Button("Disclaimers") {
                    showDisclaimers = true
                }
                Button("Do Not Sell My Info") {
                    showPrivacyPolicy = true
                }
            }
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(.claimPrimary)

            // Powered by
            VStack(spacing: 8) {
                Rectangle()
                    .fill(Color.claimBorder.opacity(0.5))
                    .frame(height: 1)
                    .frame(maxWidth: 200)

                HStack(spacing: 8) {
                    Text("Powered by")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.claimTextMuted)
                        .tracking(1.0)

                    Image("KLFLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 18)
                        .opacity(0.7)
                }
            }
            .padding(.top, 10)
        }
        .padding(.vertical, 20)
        .sheet(isPresented: $showPrivacyPolicy) {
            LegalModalView(title: "Privacy Policy", content: privacyPolicyContent)
        }
        .sheet(isPresented: $showTermsOfService) {
            LegalModalView(title: "Terms of Service", content: termsOfServiceContent)
        }
        .sheet(isPresented: $showDisclaimers) {
            LegalModalView(title: "Legal Disclaimers", content: disclaimersContent)
        }
    }

    private var privacyPolicyContent: String {
        """
        Effective Date: February 2, 2025

        Kitsinian Law Firm, APC ("we," "us," or "our") operates the ClaimIt mobile application. This Privacy Policy explains how we collect, use, disclose, and protect your information.

        INFORMATION WE COLLECT
        • Contact Information: Name, phone number, email address
        • Case Information: Details about your legal matter, including descriptions, dates, and circumstances
        • Device Information: Device type, operating system, and app usage data
        • Location: General location for jurisdictional purposes

        HOW WE USE YOUR INFORMATION
        • To evaluate your potential legal matter
        • To connect you with appropriate legal services
        • To communicate with you about your case
        • To improve our services

        WE DO NOT SELL YOUR PERSONAL INFORMATION

        CALIFORNIA PRIVACY RIGHTS (CCPA)
        California residents have the right to:
        • Know what personal information we collect
        • Request deletion of personal information
        • Opt-out of the sale of personal data (we do not sell your data)
        • Exercise these rights without discrimination

        Contact: privacy@claimit.com
        """
    }

    private var termsOfServiceContent: String {
        """
        Effective Date: February 2, 2025

        Welcome to ClaimIt, operated by Kitsinian Law Firm, APC. By using this application, you agree to these terms.

        NO ATTORNEY-CLIENT RELATIONSHIP
        Using this app does not create an attorney-client relationship. Such a relationship only forms when you sign a written retainer agreement with an attorney.

        ATTORNEY ADVERTISING
        This application constitutes attorney advertising. Kitsinian Law Firm, APC. Principal office located in Los Angeles, California.

        "NO FEE UNLESS WE WIN" EXPLAINED
        "No Fee Unless We Win" means no attorney's fees unless we recover compensation for you. However, you may still be responsible for case costs including filing fees, expert witness fees, and other litigation expenses.

        ELIGIBILITY
        You must be 18 years of age or older to use this application.

        ACCURACY OF INFORMATION
        You agree to provide accurate and complete information when using this app.

        LIMITATION OF LIABILITY
        We are not liable for any damages arising from your use of this application or reliance on information provided herein.
        """
    }

    private var disclaimersContent: String {
        """
        SUCCESS RATE DISCLAIMER
        Statistics represent historical data. Past results do not guarantee future outcomes. Each case is evaluated on its own merits.

        "NO FEE UNLESS WE WIN"
        This means no attorney's fees unless we recover compensation for you. You may still be responsible for case costs (filing fees, expert fees, etc.).

        ATTORNEY ADVERTISING
        This application constitutes attorney advertising. Kitsinian Law Firm, APC. Principal office: Los Angeles, California. Licensed in California state and federal courts.

        NOT LEGAL ADVICE
        Information in this app is for general informational purposes only and should not be construed as legal advice. Every case is unique.

        RESULTS VARY
        Past case results depend upon the specific facts and legal circumstances of each case. Previous results do not guarantee a similar outcome.

        REFERRAL CASES
        For practice areas outside our expertise, we may refer you to other qualified attorneys. Referral arrangements comply with California Rules of Professional Conduct.
        """
    }
}

// MARK: - Trust Seal View
struct TrustSealView: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(color)

            VStack(spacing: 3) {
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.claimTextPrimary)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.claimTextSecondary)
                }
            }
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .padding(.horizontal, 10)
        .background(Color.claimCardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
    }
}

// MARK: - How It Works Step
struct HowItWorksStep: View {
    let number: Int
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(LinearGradient.claimPrimaryGradient)
                    .frame(width: 64, height: 64)

                Image(systemName: icon)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
            }

            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.claimTextPrimary)

            Text(subtitle)
                .font(.system(size: 11))
                .foregroundColor(.claimTextSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - FAQ Item View
struct FAQItemView: View {
    let question: String
    let answer: String
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: { withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() } }) {
                HStack {
                    Text(question)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.claimTextPrimary)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.claimTextMuted)
                }
                .padding(16)
            }

            if isExpanded {
                Text(answer)
                    .font(.system(size: 14))
                    .foregroundColor(.claimTextSecondary)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.claimCardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
    }
}

// MARK: - Stat Badge
struct StatBadge: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 24, weight: .heavy))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
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
        VStack(spacing: 10) {
            GradientIconView(systemName: icon, size: 50, iconSize: 24)

            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.claimTextPrimary)

            Text(subtitle)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.claimTextMuted)
        }
        .frame(width: 100)
        .padding(.vertical, 18)
        .padding(.horizontal, 14)
        .background(Color.claimCardBackground)
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
        HStack(spacing: 16) {
            GradientIconView(systemName: practiceArea.icon, size: 52, iconSize: 24)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(practiceArea.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.claimTextPrimary)

                    if showTopBadge {
                        HStack(spacing: 3) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 8, weight: .bold))
                            Text("Top")
                                .font(.system(size: 9, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(LinearGradient.claimSuccessGradient)
                        .cornerRadius(6)
                    }
                }

                Text(practiceArea.shortDescription)
                    .font(.system(size: 14))
                    .foregroundColor(.claimTextSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.claimTextMuted)
        }
        .padding(16)
        .background(Color.claimCardBackground)
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
        VStack(alignment: .leading, spacing: 12) {
            GradientIconView(
                systemName: practiceArea.icon,
                size: 46,
                iconSize: 22,
                gradient: LinearGradient.claimAccentGradient
            )

            Text(practiceArea.name)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.claimTextPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .frame(width: 120, alignment: .leading)
        .padding(18)
        .background(Color.claimCardBackground)
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
        HStack(spacing: 16) {
            GradientIconView(
                systemName: resource.icon,
                size: 52,
                iconSize: 24,
                gradient: resource.gradient
            )

            VStack(alignment: .leading, spacing: 5) {
                Text(resource.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Text(resource.category.displayName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.claimPrimary)

                    Text("\(resource.readTime) min")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.claimTextMuted)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.claimTextMuted)
        }
        .padding(16)
        .background(Color.claimCardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
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

// MARK: - Legal Modal View
struct LegalModalView: View {
    @Environment(\.dismiss) var dismiss
    let title: String
    let content: String

    var body: some View {
        NavigationStack {
            ScrollView {
                Text(content)
                    .font(.system(size: 14))
                    .foregroundColor(.claimTextPrimary)
                    .lineSpacing(4)
                    .padding(20)
            }
            .background(Color.claimBackground)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.claimPrimary)
                }
            }
        }
    }
}

// MARK: - Shimmer CTA Button
struct ShimmerCTAButton: View {
    let icon: String
    let text: String
    let isIPad: Bool

    @State private var shimmerOffset: CGFloat = -1.0
    @State private var pulseScale: CGFloat = 1.0
    @State private var shadowOpacity: Double = 0.4

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: isIPad ? 22 : 20, weight: .bold))
            Text(text)
                .font(.system(size: isIPad ? 18 : 17, weight: .bold))
        }
        .foregroundColor(.white)
        .frame(maxWidth: isIPad ? 400 : .infinity)
        .frame(height: isIPad ? 58 : 54)
        .background(
            ZStack {
                // Base gradient - matches HTML exactly
                LinearGradient(
                    colors: [
                        Color(hex: "FF7B45"),
                        Color.claimAccent,
                        Color(hex: "E85A25"),
                        Color(hex: "FF6B35")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Shimmer overlay
                GeometryReader { geometry in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.clear, .white.opacity(0.35), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * 0.5)
                        .offset(x: shimmerOffset * geometry.size.width)
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color(hex: "FF6B35").opacity(shadowOpacity), radius: 16, y: 8)
        .scaleEffect(pulseScale)
        .onAppear {
            // Shimmer animation - matches HTML 2.5s
            withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                shimmerOffset = 1.5
            }
            // Pulse animation with shadow intensity change
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                pulseScale = 1.02
                shadowOpacity = 0.6
            }
        }
    }
}

// MARK: - Live Activity Feed
struct LiveActivityFeed: View {
    @State private var currentIndex = 0
    @State private var opacity: Double = 1.0

    private let proofData: [(initials: String, location: String, type: String, action: String, time: String)] = [
        ("MR", "Los Angeles", "Car Accident", "matched with an attorney", "2 min ago"),
        ("JK", "San Diego", "Slip & Fall", "submitted a claim", "5 min ago"),
        ("AT", "Irvine", "Insurance Dispute", "received case update", "8 min ago"),
        ("SL", "Pasadena", "Personal Injury", "claim qualified", "12 min ago"),
        ("DW", "Long Beach", "Property Damage", "started a claim", "15 min ago")
    ]

    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header
            HStack(spacing: 10) {
                // Live pulse dot with glow
                Circle()
                    .fill(Color.claimSuccess)
                    .frame(width: 10, height: 10)
                    .modifier(PulseAnimation())

                Text("LIVE ACTIVITY")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.claimTextSecondary)
                    .tracking(1.0)
            }

            // Current proof item
            HStack(spacing: 14) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(LinearGradient.claimPrimaryGradient)
                        .frame(width: 44, height: 44)
                    Text(proofData[currentIndex].initials)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                }

                // Content
                VStack(alignment: .leading, spacing: 3) {
                    Text("Someone in \(proofData[currentIndex].location)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.claimTextPrimary)
                    Text("\(proofData[currentIndex].action) for \(proofData[currentIndex].type)")
                        .font(.system(size: 14))
                        .foregroundColor(.claimTextSecondary)
                }

                Spacer()

                // Time
                Text(proofData[currentIndex].time)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.claimTextMuted)
            }
            .opacity(opacity)
        }
        .padding(18)
        .background(Color.claimCardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
        .onReceive(timer) { _ in
            withAnimation(.easeOut(duration: 0.3)) {
                opacity = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                currentIndex = (currentIndex + 1) % proofData.count
                withAnimation(.easeIn(duration: 0.3)) {
                    opacity = 1
                }
            }
        }
    }
}

// MARK: - Pulse Animation Modifier with Glow
struct PulseAnimation: ViewModifier {
    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.3 : 1.0)
            .opacity(isAnimating ? 0.6 : 1.0)
            .shadow(color: Color.claimSuccess.opacity(isAnimating ? 0.6 : 0.3), radius: isAnimating ? 8 : 4)
            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}

// MARK: - Shimmer Button Modifier
struct ShimmerButtonStyle: ButtonStyle {
    @State private var shimmerOffset: CGFloat = -1.0

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(
                GeometryReader { geometry in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.clear, .white.opacity(0.3), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * 0.5)
                        .offset(x: shimmerOffset * geometry.size.width)
                        .onAppear {
                            withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                                shimmerOffset = 1.5
                            }
                        }
                }
                .mask(configuration.label)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

#Preview {
    HomeView()
}
