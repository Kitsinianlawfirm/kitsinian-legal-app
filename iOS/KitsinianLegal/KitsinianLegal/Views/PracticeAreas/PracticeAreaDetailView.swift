//
//  PracticeAreaDetailView.swift
//  ClaimIt
//

import SwiftUI

struct PracticeAreaDetailView: View {
    let practiceArea: PracticeArea
    @State private var showingContactForm = false
    @State private var expandedFAQ: String?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
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
            .padding(16)
        }
        .background(Color.claimBackground)
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
        VStack(spacing: 20) {
            // Icon
            GradientIconView(
                systemName: practiceArea.icon,
                size: 72,
                iconSize: 32,
                gradient: practiceArea.category == .inHouse
                    ? LinearGradient.claimPrimaryGradient
                    : LinearGradient.claimAccentGradient
            )

            // Category Badge
            HStack(spacing: 8) {
                Image(systemName: practiceArea.category == .inHouse ? "checkmark.shield.fill" : "person.2.fill")
                    .font(.system(size: 14, weight: .semibold))
                Text(practiceArea.category == .inHouse ? "We Handle Directly" : "Referral Network")
                    .font(.system(size: 14, weight: .bold))
            }
            .foregroundColor(practiceArea.category == .inHouse ? .claimPrimary : .claimAccent)
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(
                (practiceArea.category == .inHouse ? Color.claimPrimary : Color.claimAccent).opacity(0.1)
            )
            .cornerRadius(24)

            // Description
            Text(practiceArea.fullDescription)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.claimTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.vertical, 8)
    }

    // MARK: - What We Do Section
    private var whatWeDoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                GradientIconView(
                    systemName: practiceArea.category == .inHouse ? "checkmark.circle.fill" : "arrow.right.circle.fill",
                    size: 36,
                    iconSize: 16,
                    gradient: LinearGradient.claimPrimaryGradient
                )
                Text(practiceArea.category == .inHouse ? "What We Do" : "How We Help")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
            }

            VStack(alignment: .leading, spacing: 12) {
                ForEach(practiceArea.whatWeDo, id: \.self) { item in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.claimSuccess)

                        Text(item)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.claimTextPrimary)
                            .lineSpacing(3)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.claimCardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }

    // MARK: - Common Causes Section
    private var commonCausesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                GradientIconView(
                    systemName: "list.bullet.circle.fill",
                    size: 36,
                    iconSize: 16,
                    gradient: LinearGradient.claimAccentGradient
                )
                Text("Common Situations")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
            }

            FlowLayout(spacing: 8) {
                ForEach(practiceArea.commonCauses, id: \.self) { cause in
                    Text(cause)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.claimTextPrimary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.claimBackground)
                        .cornerRadius(10)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.claimCardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }

    // MARK: - FAQ Section
    private var faqSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                GradientIconView(
                    systemName: "questionmark.circle.fill",
                    size: 36,
                    iconSize: 16,
                    gradient: LinearGradient.claimPrimaryGradient
                )
                Text("Common Questions")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
            }

            VStack(spacing: 10) {
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
        .padding(16)
        .background(Color.claimCardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }

    // MARK: - Related Resources Section
    @ViewBuilder
    private var relatedResourcesSection: some View {
        let resources = LegalResource.resources(for: practiceArea.id)
        if !resources.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 10) {
                    GradientIconView(
                        systemName: "book.fill",
                        size: 36,
                        iconSize: 16,
                        gradient: LinearGradient.claimSuccessGradient
                    )
                    Text("Related Resources")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.claimTextPrimary)
                }

                VStack(spacing: 10) {
                    ForEach(resources.prefix(3)) { resource in
                        NavigationLink(destination: ResourceDetailView(resource: resource)) {
                            HStack(spacing: 14) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(resource.title)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.claimTextPrimary)
                                        .lineLimit(1)

                                    Text("\(resource.readTime) min read")
                                        .font(.system(size: 12))
                                        .foregroundColor(.claimTextMuted)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.claimTextMuted)
                            }
                            .padding(14)
                            .background(Color.claimBackground)
                            .cornerRadius(12)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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

    // MARK: - CTA Section
    private var ctaSection: some View {
        VStack(spacing: 12) {
            Button(action: {
                showingContactForm = true
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 18, weight: .bold))
                    Text(practiceArea.category == .inHouse ? "Get Free Consultation" : "Request Referral")
                        .font(.system(size: 17, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(LinearGradient.claimAccentGradient)
                .cornerRadius(14)
                .shadow(color: .claimAccent.opacity(0.35), radius: 12, y: 6)
            }

            Button(action: {
                if let url = URL(string: "tel://+1YOURNUMBER") {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 18, weight: .bold))
                    Text("Call Now")
                        .font(.system(size: 17, weight: .bold))
                }
                .foregroundColor(.claimPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color.claimCardBackground)
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.claimPrimary, lineWidth: 2)
                )
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
        VStack(alignment: .leading, spacing: 10) {
            Button(action: onToggle) {
                HStack(alignment: .top) {
                    Text(faq.question)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.claimTextPrimary)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.claimTextMuted)
                        .padding(.top, 3)
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                Text(faq.answer)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.claimTextSecondary)
                    .lineSpacing(4)
            }
        }
        .padding(14)
        .background(Color.claimBackground)
        .cornerRadius(12)
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
