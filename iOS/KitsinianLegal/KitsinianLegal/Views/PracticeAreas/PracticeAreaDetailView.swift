//
//  PracticeAreaDetailView.swift
//  KitsinianLegal
//

import SwiftUI

struct PracticeAreaDetailView: View {
    let practiceArea: PracticeArea
    @State private var showingContactForm = false
    @State private var expandedFAQ: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection

                // What We Do / How We Help
                whatWeDoSection

                // Common Causes
                commonCausesSection

                // FAQ
                faqSection

                // Related Resources
                relatedResourcesSection

                // CTA
                ctaSection

                Spacer(minLength: 40)
            }
            .padding()
        }
        .background(Color("Background"))
        .navigationTitle(practiceArea.name)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingContactForm) {
            NavigationStack {
                LeadFormView(practiceArea: practiceArea)
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Category Badge
            HStack {
                Image(systemName: practiceArea.category == .inHouse ? "checkmark.shield.fill" : "person.2.fill")
                Text(practiceArea.category == .inHouse ? "We Handle Directly" : "Referral Network")
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(practiceArea.category == .inHouse ? Color("Primary") : Color("Secondary"))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                (practiceArea.category == .inHouse ? Color("Primary") : Color("Secondary")).opacity(0.1)
            )
            .cornerRadius(20)

            // Description
            Text(practiceArea.fullDescription)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - What We Do Section
    private var whatWeDoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(practiceArea.category == .inHouse ? "What We Do" : "How We Help",
                  systemImage: practiceArea.category == .inHouse ? "checkmark.circle.fill" : "arrow.right.circle.fill")
                .font(.headline)
                .foregroundColor(Color("Primary"))

            VStack(alignment: .leading, spacing: 12) {
                ForEach(practiceArea.whatWeDo, id: \.self) { item in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color("Primary"))
                            .padding(.top, 2)

                        Text(item)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }

    // MARK: - Common Causes Section
    private var commonCausesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Common Situations", systemImage: "list.bullet.circle.fill")
                .font(.headline)
                .foregroundColor(Color("Primary"))

            FlowLayout(spacing: 8) {
                ForEach(practiceArea.commonCauses, id: \.self) { cause in
                    Text(cause)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color("Background"))
                        .cornerRadius(8)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }

    // MARK: - FAQ Section
    private var faqSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Common Questions", systemImage: "questionmark.circle.fill")
                .font(.headline)
                .foregroundColor(Color("Primary"))

            VStack(spacing: 8) {
                ForEach(practiceArea.faq, id: \.question) { faq in
                    FAQDisclosureView(
                        faq: faq,
                        isExpanded: expandedFAQ == faq.question,
                        onToggle: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if expandedFAQ == faq.question {
                                    expandedFAQ = nil
                                } else {
                                    expandedFAQ = faq.question
                                }
                            }
                        }
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }

    // MARK: - Related Resources Section
    @ViewBuilder
    private var relatedResourcesSection: some View {
        let resources = LegalResource.resources(for: practiceArea.id)
        if !resources.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                Label("Related Resources", systemImage: "book.fill")
                    .font(.headline)
                    .foregroundColor(Color("Primary"))

                VStack(spacing: 8) {
                    ForEach(resources.prefix(3)) { resource in
                        NavigationLink(destination: ResourceDetailView(resource: resource)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(resource.title)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)

                                    Text("\(resource.readTime) min read")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
        }
    }

    // MARK: - CTA Section
    private var ctaSection: some View {
        VStack(spacing: 12) {
            Button(action: {
                showingContactForm = true
            }) {
                HStack {
                    Image(systemName: "envelope.fill")
                    Text(practiceArea.category == .inHouse ? "Get Free Consultation" : "Request Referral")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color("Primary"))
                .cornerRadius(12)
            }

            Button(action: {
                if let url = URL(string: "tel://+1YOURNUMBER") {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack {
                    Image(systemName: "phone.fill")
                    Text("Call Now")
                }
                .font(.headline)
                .foregroundColor(Color("Primary"))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("Primary"), lineWidth: 2)
                )
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - FAQ Disclosure View
struct FAQDisclosureView: View {
    let faq: PracticeArea.FAQ
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: onToggle) {
                HStack {
                    Text(faq.question)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                Text(faq.answer)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color("Background"))
        .cornerRadius(8)
    }
}

// MARK: - Flow Layout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return layoutSizes(sizes, in: proposal.width ?? 0).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let layout = layoutSizes(sizes, in: bounds.width)

        for (index, subview) in subviews.enumerated() {
            let position = layout.positions[index]
            subview.place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                         proposal: ProposedViewSize(sizes[index]))
        }
    }

    private func layoutSizes(_ sizes: [CGSize], in width: CGFloat) -> (positions: [CGPoint], size: CGSize) {
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxWidth: CGFloat = 0

        for size in sizes {
            if currentX + size.width > width && currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }

            positions.append(CGPoint(x: currentX, y: currentY))
            currentX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
            maxWidth = max(maxWidth, currentX - spacing)
        }

        return (positions, CGSize(width: maxWidth, height: currentY + lineHeight))
    }
}

#Preview {
    NavigationStack {
        PracticeAreaDetailView(practiceArea: .personalInjury)
    }
}
