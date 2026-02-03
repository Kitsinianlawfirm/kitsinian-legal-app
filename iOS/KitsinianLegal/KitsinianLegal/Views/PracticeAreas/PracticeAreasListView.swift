//
//  PracticeAreasListView.swift
//  ClaimIt
//

import SwiftUI

struct PracticeAreasListView: View {
    let category: PracticeArea.Category?

    init(category: PracticeArea.Category? = nil) {
        self.category = category
    }

    var areas: [PracticeArea] {
        if let category = category {
            return category == .inHouse ? PracticeArea.inHouseAreas : PracticeArea.referralAreas
        }
        return PracticeArea.allAreas
    }

    var title: String {
        if let category = category {
            return category == .inHouse ? "We Fight For" : "Referral Network"
        }
        return "Practice Areas"
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Header description
                headerSection

                // In-House or Referral Areas
                if category == nil {
                    // Show both sections
                    inHouseSection
                    referralSection
                } else {
                    // Show filtered list
                    areasListSection
                }
            }
            .padding(.bottom, 32)
        }
        .background(Color.claimBackground)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if category == .inHouse {
                Text("We handle these cases directly with no upfront fees. You only pay if we win.")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.claimTextSecondary)
                    .lineSpacing(4)
            } else if category == .referral {
                Text("For cases outside our focus, we connect you with trusted California attorneys who specialize in these areas.")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.claimTextSecondary)
                    .lineSpacing(4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    // MARK: - Areas List
    private var areasListSection: some View {
        VStack(spacing: 10) {
            ForEach(areas) { area in
                NavigationLink(destination: PracticeAreaDetailView(practiceArea: area)) {
                    PracticeAreaListCard(practiceArea: area)
                }
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - In-House Section
    private var inHouseSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                GradientIconView(
                    systemName: "checkmark.shield.fill",
                    size: 36,
                    iconSize: 16,
                    gradient: LinearGradient.claimPrimaryGradient
                )
                Text("We Handle Directly")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
            }
            .padding(.horizontal, 20)

            VStack(spacing: 10) {
                ForEach(PracticeArea.inHouseAreas) { area in
                    NavigationLink(destination: PracticeAreaDetailView(practiceArea: area)) {
                        PracticeAreaListCard(practiceArea: area)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Referral Section
    private var referralSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                GradientIconView(
                    systemName: "person.2.fill",
                    size: 36,
                    iconSize: 16,
                    gradient: LinearGradient.claimAccentGradient
                )
                Text("Trusted Referral Network")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
            }
            .padding(.horizontal, 20)

            VStack(spacing: 10) {
                ForEach(PracticeArea.referralAreas) { area in
                    NavigationLink(destination: PracticeAreaDetailView(practiceArea: area)) {
                        PracticeAreaListCard(practiceArea: area)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Practice Area List Card
struct PracticeAreaListCard: View {
    let practiceArea: PracticeArea

    var body: some View {
        HStack(spacing: 14) {
            GradientIconView(
                systemName: practiceArea.icon,
                size: 50,
                iconSize: 22,
                gradient: practiceArea.category == .inHouse
                    ? LinearGradient.claimPrimaryGradient
                    : LinearGradient.claimAccentGradient
            )

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 8) {
                    Text(practiceArea.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.claimTextPrimary)

                    if practiceArea.category == .inHouse {
                        Text("We Handle")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(LinearGradient.claimSuccessGradient)
                            .cornerRadius(5)
                    }
                }

                Text(practiceArea.shortDescription)
                    .font(.system(size: 13))
                    .foregroundColor(.claimTextSecondary)
                    .lineLimit(2)
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

#Preview {
    NavigationStack {
        PracticeAreasListView()
    }
}
