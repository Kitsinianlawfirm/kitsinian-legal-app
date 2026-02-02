//
//  PracticeAreasListView.swift
//  KitsinianLegal
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
            return category == .inHouse ? "What We Handle" : "Referral Network"
        }
        return "Practice Areas"
    }

    var body: some View {
        ScrollView {
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
        .background(Color("Background"))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if category == .inHouse {
                Text("We handle these cases directly with no upfront fees. You only pay if we win.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else if category == .referral {
                Text("For cases outside our focus, we connect you with trusted California attorneys who specialize in these areas.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 8)
    }

    // MARK: - Areas List
    private var areasListSection: some View {
        VStack(spacing: 12) {
            ForEach(areas) { area in
                NavigationLink(destination: PracticeAreaDetailView(practiceArea: area)) {
                    PracticeAreaCard(practiceArea: area)
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - In-House Section
    private var inHouseSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "checkmark.shield.fill")
                    .foregroundColor(Color("Primary"))
                Text("We Handle Directly")
                    .font(.headline)
            }
            .padding(.horizontal)

            VStack(spacing: 12) {
                ForEach(PracticeArea.inHouseAreas) { area in
                    NavigationLink(destination: PracticeAreaDetailView(practiceArea: area)) {
                        PracticeAreaCard(practiceArea: area)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Referral Section
    private var referralSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "person.2.fill")
                    .foregroundColor(Color("Secondary"))
                Text("Trusted Referral Network")
                    .font(.headline)
            }
            .padding(.horizontal)

            VStack(spacing: 12) {
                ForEach(PracticeArea.referralAreas) { area in
                    NavigationLink(destination: PracticeAreaDetailView(practiceArea: area)) {
                        PracticeAreaCard(practiceArea: area)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Practice Area Card
struct PracticeAreaCard: View {
    let practiceArea: PracticeArea

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: practiceArea.icon)
                .font(.title2)
                .foregroundColor(practiceArea.category == .inHouse ? Color("Primary") : Color("Secondary"))
                .frame(width: 50, height: 50)
                .background(
                    (practiceArea.category == .inHouse ? Color("Primary") : Color("Secondary")).opacity(0.1)
                )
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(practiceArea.name)
                        .font(.headline)
                        .foregroundColor(.primary)

                    if practiceArea.category == .inHouse {
                        Text("We Handle")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color("Primary"))
                            .cornerRadius(4)
                    }
                }

                Text(practiceArea.shortDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

#Preview {
    NavigationStack {
        PracticeAreasListView()
    }
}
