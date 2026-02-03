//
//  ContactView.swift
//  ClaimIt
//

import SwiftUI

struct ContactView: View {
    @State private var showingLeadForm = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    headerSection

                    // Contact Methods
                    contactMethodsSection

                    // Office Info
                    officeInfoSection

                    // Quick Form
                    quickFormSection

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .background(Color.claimBackground)
            .navigationTitle("Contact")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingLeadForm) {
                NavigationStack {
                    LeadFormView(practiceArea: nil)
                }
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            GradientIconView(
                systemName: "bubble.left.and.bubble.right.fill",
                size: 72,
                iconSize: 32,
                gradient: LinearGradient.claimPrimaryGradient
            )

            Text("Get in Touch")
                .font(.system(size: 26, weight: .heavy))
                .foregroundColor(.claimTextPrimary)

            Text("We're here to help. Reach out for a free consultation about your legal matter.")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.claimTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.vertical, 8)
    }

    // MARK: - Contact Methods
    private var contactMethodsSection: some View {
        VStack(spacing: 12) {
            // Call
            ContactMethodCard(
                icon: "phone.fill",
                title: "Call Us",
                subtitle: "Speak with our team directly",
                actionText: "Call Now",
                gradient: LinearGradient.claimSuccessGradient
            ) {
                if let url = URL(string: "tel://+1YOURNUMBER") {
                    UIApplication.shared.open(url)
                }
            }

            // Email
            ContactMethodCard(
                icon: "envelope.fill",
                title: "Email Us",
                subtitle: "We respond within 24 hours",
                actionText: "Send Email",
                gradient: LinearGradient.claimPrimaryGradient
            ) {
                if let url = URL(string: "mailto:info@claimit.com") {
                    UIApplication.shared.open(url)
                }
            }

            // Form
            ContactMethodCard(
                icon: "doc.text.fill",
                title: "Send a Message",
                subtitle: "Tell us about your situation",
                actionText: "Fill Out Form",
                gradient: LinearGradient.claimAccentGradient
            ) {
                showingLeadForm = true
            }
        }
    }

    // MARK: - Office Info
    private var officeInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                GradientIconView(
                    systemName: "building.2.fill",
                    size: 36,
                    iconSize: 16,
                    gradient: LinearGradient.claimPrimaryGradient
                )
                Text("Office Information")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.claimTextPrimary)
            }

            VStack(alignment: .leading, spacing: 16) {
                // Address
                HStack(alignment: .top, spacing: 14) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.claimPrimary)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("ClaimIt Legal")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.claimTextPrimary)

                        Text("Los Angeles, California")
                            .font(.system(size: 13))
                            .foregroundColor(.claimTextSecondary)
                    }
                }

                Divider()

                // Hours
                HStack(alignment: .top, spacing: 14) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.claimPrimary)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Office Hours")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.claimTextPrimary)

                        Text("Monday - Friday: 9:00 AM - 6:00 PM")
                            .font(.system(size: 13))
                            .foregroundColor(.claimTextSecondary)

                        Text("Weekends: By appointment")
                            .font(.system(size: 13))
                            .foregroundColor(.claimTextSecondary)
                    }
                }

                Divider()

                // Service Area
                HStack(alignment: .top, spacing: 14) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.claimPrimary)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Service Area")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.claimTextPrimary)

                        Text("Serving all of California with focus on Southern California")
                            .font(.system(size: 13))
                            .foregroundColor(.claimTextSecondary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.claimBorder, lineWidth: 1)
        )
        .claimShadowSmall()
    }

    // MARK: - Quick Form Section
    private var quickFormSection: some View {
        VStack(spacing: 16) {
            Text("Prefer us to contact you?")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.claimTextPrimary)

            Text("Leave your information and we'll reach out within 24 hours.")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.claimTextSecondary)
                .multilineTextAlignment(.center)

            Button(action: {
                showingLeadForm = true
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 18, weight: .bold))
                    Text("Request Callback")
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

// MARK: - Contact Method Card
struct ContactMethodCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let actionText: String
    let gradient: LinearGradient
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                GradientIconView(
                    systemName: icon,
                    size: 50,
                    iconSize: 22,
                    gradient: gradient
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.claimTextPrimary)

                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.claimTextSecondary)
                }

                Spacer()

                Text(actionText)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.claimPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.claimPrimary.opacity(0.1))
                    .cornerRadius(8)
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
        .buttonStyle(.plain)
    }
}

#Preview {
    ContactView()
}
