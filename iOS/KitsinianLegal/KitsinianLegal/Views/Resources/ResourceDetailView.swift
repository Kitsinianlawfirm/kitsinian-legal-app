//
//  ResourceDetailView.swift
//  ClaimIt
//

import SwiftUI

struct ResourceDetailView: View {
    let resource: LegalResource
    @State private var showingShareSheet = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                headerSection

                // Content
                contentSection

                // Related Practice Areas
                relatedAreasSection

                // CTA
                ctaSection

                Spacer(minLength: 40)
            }
            .padding(16)
        }
        .background(Color.claimBackground)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.claimPrimary)
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [resource.title, resource.summary])
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Category & Read Time
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: resource.category.icon)
                        .font(.system(size: 12, weight: .semibold))
                    Text(resource.category.displayName)
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(.claimPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.claimPrimary.opacity(0.1))
                .cornerRadius(16)

                Spacer()

                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                    Text("\(resource.readTime) min read")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(.claimTextMuted)
            }

            // Title
            Text(resource.title)
                .font(.system(size: 24, weight: .heavy))
                .foregroundColor(.claimTextPrimary)

            // Summary
            Text(resource.summary)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.claimTextSecondary)
                .lineSpacing(4)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }

    // MARK: - Content Section
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            MarkdownView(content: resource.content)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }

    // MARK: - Related Practice Areas
    private var relatedAreasSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                GradientIconView(
                    systemName: "link",
                    size: 32,
                    iconSize: 14,
                    gradient: LinearGradient.claimPrimaryGradient
                )
                Text("Related Practice Areas")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
            }

            VStack(spacing: 10) {
                ForEach(resource.practiceAreas, id: \.self) { areaId in
                    if let area = PracticeArea.allAreas.first(where: { $0.id == areaId }) {
                        NavigationLink(destination: PracticeAreaDetailView(practiceArea: area)) {
                            HStack(spacing: 14) {
                                GradientIconView(
                                    systemName: area.icon,
                                    size: 40,
                                    iconSize: 18,
                                    gradient: LinearGradient.claimPrimaryGradient
                                )

                                Text(area.name)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.claimTextPrimary)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.claimTextMuted)
                            }
                            .padding(12)
                            .background(Color.claimBackground)
                            .cornerRadius(12)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }

    // MARK: - CTA Section
    private var ctaSection: some View {
        VStack(spacing: 16) {
            GradientIconView(
                systemName: "bolt.fill",
                size: 56,
                iconSize: 26,
                gradient: LinearGradient.claimAccentGradient
            )

            Text("Need Legal Help?")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.claimTextPrimary)

            Text("If you're dealing with a situation like this, we're here to help.")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.claimTextSecondary)
                .multilineTextAlignment(.center)

            NavigationLink(destination: QuizStartView()) {
                HStack(spacing: 10) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 18, weight: .bold))
                    Text("Start Free Case Evaluation")
                        .font(.system(size: 17, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(LinearGradient.claimAccentGradient)
                .cornerRadius(14)
                .shadow(color: .claimAccent.opacity(0.35), radius: 12, y: 6)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }
}

// MARK: - Simple Markdown View
struct MarkdownView: View {
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(parseContent(), id: \.id) { element in
                renderElement(element)
            }
        }
    }

    private func parseContent() -> [ContentElement] {
        var elements: [ContentElement] = []
        let lines = content.components(separatedBy: "\n")
        var currentId = 0

        for line in lines {
            currentId += 1
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            if trimmed.isEmpty {
                continue
            } else if trimmed.hasPrefix("# ") {
                elements.append(ContentElement(id: currentId, type: .h1, content: String(trimmed.dropFirst(2))))
            } else if trimmed.hasPrefix("## ") {
                elements.append(ContentElement(id: currentId, type: .h2, content: String(trimmed.dropFirst(3))))
            } else if trimmed.hasPrefix("### ") {
                elements.append(ContentElement(id: currentId, type: .h3, content: String(trimmed.dropFirst(4))))
            } else if trimmed.hasPrefix("- [ ] ") {
                elements.append(ContentElement(id: currentId, type: .checkbox, content: String(trimmed.dropFirst(6)), isChecked: false))
            } else if trimmed.hasPrefix("- [x] ") || trimmed.hasPrefix("- [X] ") {
                elements.append(ContentElement(id: currentId, type: .checkbox, content: String(trimmed.dropFirst(6)), isChecked: true))
            } else if trimmed.hasPrefix("- ") {
                elements.append(ContentElement(id: currentId, type: .bullet, content: String(trimmed.dropFirst(2))))
            } else if trimmed.hasPrefix("| ") {
                elements.append(ContentElement(id: currentId, type: .tableRow, content: trimmed))
            } else if trimmed.hasPrefix("**") && trimmed.hasSuffix("**") {
                let text = String(trimmed.dropFirst(2).dropLast(2))
                elements.append(ContentElement(id: currentId, type: .bold, content: text))
            } else {
                elements.append(ContentElement(id: currentId, type: .paragraph, content: trimmed))
            }
        }

        return elements
    }

    @ViewBuilder
    private func renderElement(_ element: ContentElement) -> some View {
        switch element.type {
        case .h1:
            Text(element.content)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.claimTextPrimary)
                .padding(.top, 8)

        case .h2:
            Text(element.content)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.claimTextPrimary)
                .padding(.top, 6)

        case .h3:
            Text(element.content)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.claimTextPrimary)
                .padding(.top, 4)

        case .paragraph:
            Text(formatInlineStyles(element.content))
                .font(.system(size: 15))
                .foregroundColor(.claimTextPrimary)
                .lineSpacing(4)

        case .bullet:
            HStack(alignment: .top, spacing: 10) {
                Circle()
                    .fill(Color.claimPrimary)
                    .frame(width: 6, height: 6)
                    .padding(.top, 7)
                Text(formatInlineStyles(element.content))
                    .font(.system(size: 15))
                    .foregroundColor(.claimTextPrimary)
            }

        case .checkbox:
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: element.isChecked ? "checkmark.square.fill" : "square")
                    .font(.system(size: 18))
                    .foregroundColor(element.isChecked ? .claimSuccess : .claimTextMuted)
                Text(element.content)
                    .font(.system(size: 15))
                    .strikethrough(element.isChecked)
                    .foregroundColor(element.isChecked ? .claimTextMuted : .claimTextPrimary)
            }

        case .bold:
            Text(element.content)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.claimTextPrimary)

        case .tableRow:
            // Simplified table rendering
            if !element.content.contains("---") {
                Text(element.content.replacingOccurrences(of: "|", with: "  "))
                    .font(.system(size: 13))
                    .foregroundColor(.claimTextSecondary)
            }
        }
    }

    private func formatInlineStyles(_ text: String) -> AttributedString {
        var result = AttributedString(text)
        return result
    }
}

struct ContentElement: Identifiable {
    let id: Int
    let type: ElementType
    let content: String
    var isChecked: Bool = false

    enum ElementType {
        case h1, h2, h3, paragraph, bullet, checkbox, bold, tableRow
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationStack {
        ResourceDetailView(resource: .afterCarAccident)
    }
}
