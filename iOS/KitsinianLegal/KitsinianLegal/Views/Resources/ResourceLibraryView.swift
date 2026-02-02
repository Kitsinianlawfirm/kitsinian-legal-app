//
//  ResourceLibraryView.swift
//  KitsinianLegal
//

import SwiftUI

struct ResourceLibraryView: View {
    @State private var searchText = ""
    @State private var selectedCategory: LegalResource.Category?

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
            ScrollView {
                VStack(spacing: 24) {
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
            }
            .background(Color("Background"))
            .navigationTitle("Resources")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search resources")
        }
    }

    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
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
            .padding(.horizontal)
        }
    }

    // MARK: - Featured Section
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Featured")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(LegalResource.featuredResources) { resource in
                        NavigationLink(destination: ResourceDetailView(resource: resource)) {
                            FeaturedResourceCard(resource: resource)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Resources Section
    private var resourcesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(selectedCategory?.displayName ?? "All Resources")
                .font(.headline)
                .padding(.horizontal)

            if filteredResources.isEmpty {
                emptyState
            } else {
                VStack(spacing: 12) {
                    ForEach(filteredResources) { resource in
                        NavigationLink(destination: ResourceDetailView(resource: resource)) {
                            ResourceListCard(resource: resource)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("No resources found")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("Try adjusting your search or filters")
                .font(.subheadline)
                .foregroundColor(.secondary)
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
                        .font(.caption)
                }
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color("Primary") : Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
            )
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
                Image(systemName: resource.icon)
                    .font(.title2)
                    .foregroundColor(Color("Primary"))

                Spacer()

                Text("\(resource.readTime) min")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(resource.title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Text(resource.summary)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)

            Spacer()

            Text(resource.category.displayName)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(Color("Primary"))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color("Primary").opacity(0.1))
                .cornerRadius(4)
        }
        .frame(width: 200, height: 180)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
    }
}

// MARK: - Resource List Card
struct ResourceListCard: View {
    let resource: LegalResource

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: resource.icon)
                .font(.title2)
                .foregroundColor(Color("Primary"))
                .frame(width: 50, height: 50)
                .background(Color("Primary").opacity(0.1))
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                Text(resource.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)

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
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 5, y: 2)
    }
}

#Preview {
    ResourceLibraryView()
}
