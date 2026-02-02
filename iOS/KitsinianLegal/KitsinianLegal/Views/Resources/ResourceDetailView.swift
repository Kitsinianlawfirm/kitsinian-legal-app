//
//  ResourceDetailView.swift
//  KitsinianLegal
//

import SwiftUI

struct ResourceDetailView: View {
    let resource: LegalResource
    @State private var showingShareSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
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
            .padding()
        }
        .background(Color("Background"))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
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
                Label(resource.category.displayName, systemImage: resource.category.icon)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Primary"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color("Primary").opacity(0.1))
                    .cornerRadius(16)

                Spacer()

                Label("\(resource.readTime) min read", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // Title
            Text(resource.title)
                .font(.title2)
                .fontWeight(.bold)

            // Summary
            Text(resource.summary)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }

    // MARK: - Content Section
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            MarkdownView(content: resource.content)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }

    // MARK: - Related Practice Areas
    private var relatedAreasSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Related Practice Areas")
                .font(.headline)

            VStack(spacing: 8) {
                ForEach(resource.practiceAreas, id: \.self) { areaId in
                    if let area = PracticeArea.allAreas.first(where: { $0.id == areaId }) {
                        NavigationLink(destination: PracticeAreaDetailView(practiceArea: area)) {
                            HStack {
                                Image(systemName: area.icon)
                                    .font(.title3)
                                    .foregroundColor(Color("Primary"))
                                    .frame(width: 36, height: 36)
                                    .background(Color("Primary").opacity(0.1))
                                    .cornerRadius(8)

                                Text(area.name)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color("Background"))
                            .cornerRadius(12)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }

    // MARK: - CTA Section
    private var ctaSection: some View {
        VStack(spacing: 16) {
            Text("Need Legal Help?")
                .font(.headline)

            Text("If you're dealing with a situation like this, we're here to help.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

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
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
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
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 8)

        case .h2:
            Text(element.content)
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.top, 6)

        case .h3:
            Text(element.content)
                .font(.headline)
                .padding(.top, 4)

        case .paragraph:
            Text(formatInlineStyles(element.content))
                .font(.body)
                .foregroundColor(.primary)

        case .bullet:
            HStack(alignment: .top, spacing: 8) {
                Text("•")
                    .foregroundColor(Color("Primary"))
                Text(formatInlineStyles(element.content))
                    .font(.body)
            }

        case .checkbox:
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: element.isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(element.isChecked ? Color("Primary") : .secondary)
                Text(element.content)
                    .font(.body)
                    .strikethrough(element.isChecked)
                    .foregroundColor(element.isChecked ? .secondary : .primary)
            }

        case .bold:
            Text(element.content)
                .font(.body)
                .fontWeight(.semibold)

        case .tableRow:
            // Simplified table rendering
            if !element.content.contains("---") {
                Text(element.content.replacingOccurrences(of: "|", with: "  "))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private func formatInlineStyles(_ text: String) -> AttributedString {
        var result = AttributedString(text)
        // Basic formatting - could be enhanced
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
