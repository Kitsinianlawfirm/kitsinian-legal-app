//
//  ResourceLibraryView.swift
//  ClaimIt
//

import SwiftUI

struct ResourceLibraryView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var searchText = ""
    @State private var selectedCategory: LegalResource.Category?

    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }

    var filteredResources: [LegalResource] {
        var resources = LegalResource.allResources

        if let category = selectedCategory {
            resources = resources.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            resources = resources.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.summary.localizedCaseInsensitiveContains(searchText)
            }
        }

        return resources
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: isIPad ? 32 : 24) {
                    // Category Filter
                    categoryFilter

                    // Featured Section (when no filter)
                    if selectedCategory == nil && searchText.isEmpty {
                        featuredSection
                    }

                    // All Resources
                    resourcesSection
                }
                .padding(.bottom, 32)
                .frame(maxWidth: isIPad ? 900 : .infinity)
                .frame(maxWidth: .infinity)
            }
            .background(Color.claimBackground)
            .navigationTitle("Learn")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search resources")
        }
    }

    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                CategoryChip(
                    title: "All",
                    isSelected: selectedCategory == nil,
                    action: { selectedCategory = nil }
                )

                ForEach(LegalResource.Category.allCases, id: \.self) { category in
                    CategoryChip(
                        title: category.displayName,
                        icon: category.icon,
                        isSelected: selectedCategory == category,
                        action: { selectedCategory = category }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Featured Section
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Featured")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.claimTextPrimary)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(LegalResource.featuredResources) { resource in
                        NavigationLink(destination: ResourceDetailView(resource: resource)) {
                            FeaturedResourceCard(resource: resource)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: - Resources Section
    private var resourcesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(selectedCategory?.displayName ?? "All Resources")
                .font(.system(size: isIPad ? 20 : 17, weight: .bold))
                .foregroundColor(.claimTextPrimary)
                .padding(.horizontal, isIPad ? 24 : 20)

            if filteredResources.isEmpty {
                emptyState
            } else {
                if isIPad {
                    // iPad: 2-column grid
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 340, maximum: 420), spacing: 16)], spacing: 16) {
                        ForEach(filteredResources) { resource in
                            NavigationLink(destination: ResourceDetailView(resource: resource)) {
                                ResourceListCard(resource: resource)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                } else {
                    // iPhone: Single column
                    VStack(spacing: 10) {
                        ForEach(filteredResources) { resource in
                            NavigationLink(destination: ResourceDetailView(resource: resource)) {
                                ResourceListCard(resource: resource)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            GradientIconView(
                systemName: "magnifyingglass",
                size: 72,
                iconSize: 32,
                gradient: LinearGradient(colors: [.claimTextMuted, .claimTextSecondary], startPoint: .topLeading, endPoint: .bottomTrailing)
            )

            Text("No resources found")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.claimTextSecondary)

            Text("Try adjusting your search or filters")
                .font(.system(size: 14))
                .foregroundColor(.claimTextMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let title: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 14, weight: isSelected ? .bold : .medium))
            }
            .foregroundColor(isSelected ? .white : .claimTextPrimary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? LinearGradient.claimPrimaryGradient : LinearGradient(colors: [.white, .white], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.clear : Color.claimBorder, lineWidth: 1)
            )
            .claimShadowSmall()
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Featured Resource Card
struct FeaturedResourceCard: View {
    let resource: LegalResource

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                GradientIconView(
                    systemName: resource.icon,
                    size: 44,
                    iconSize: 20,
                    gradient: resource.gradient
                )

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 10))
                    Text("\(resource.readTime) min")
                        .font(.system(size: 11, weight: .medium))
                }
                .foregroundColor(.claimTextMuted)
            }

            Text(resource.title)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.claimTextPrimary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)

            Text(resource.summary)
                .font(.system(size: 12))
                .foregroundColor(.claimTextSecondary)
                .lineLimit(2)

            Spacer()

            Text(resource.category.displayName)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.claimPrimary)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.claimPrimary.opacity(0.1))
                .cornerRadius(6)
        }
        .frame(width: 200, height: 190)
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

// MARK: - Resource List Card
struct ResourceListCard: View {
    let resource: LegalResource

    var body: some View {
        HStack(spacing: 14) {
            GradientIconView(
                systemName: resource.icon,
                size: 50,
                iconSize: 22,
                gradient: resource.gradient
            )

            VStack(alignment: .leading, spacing: 5) {
                Text(resource.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    Text(resource.category.displayName)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.claimPrimary)

                    Text("\(resource.readTime) min read")
                        .font(.system(size: 12))
                        .foregroundColor(.claimTextMuted)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.claimTextMuted)
        }
        .padding(14)
        .background(Color.claimCardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }
}

#Preview {
    ResourceLibraryView()
}
