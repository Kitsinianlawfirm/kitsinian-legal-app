//
//  ContactView.swift
//  KitsinianLegal
//

import SwiftUI
import MapKit

struct ContactView: View {
    @State private var showingLeadForm = false

    var body: some View {
        NavigationStack {
            ScrollView {
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
                .padding()
            }
            .background(Color("Background"))
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
        VStack(spacing: 12) {
            Text("Get in Touch")
                .font(.title2)
                .fontWeight(.bold)

            Text("We're here to help. Reach out for a free consultation about your legal matter.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
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
                color: Color("Primary")
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
                color: .blue
            ) {
                if let url = URL(string: "mailto:info@kitsinianlaw.com") {
                    UIApplication.shared.open(url)
                }
            }

            // Form
            ContactMethodCard(
                icon: "doc.text.fill",
                title: "Send a Message",
                subtitle: "Tell us about your situation",
                actionText: "Fill Out Form",
                color: .green
            ) {
                showingLeadForm = true
            }
        }
    }

    // MARK: - Office Info
    private var officeInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Office Information", systemImage: "building.2.fill")
                .font(.headline)
                .foregroundColor(Color("Primary"))

            VStack(alignment: .leading, spacing: 16) {
                // Address
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title3)
                        .foregroundColor(Color("Primary"))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Kitsinian Law Firm, APC")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Text("Los Angeles, California")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Divider()

                // Hours
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "clock.fill")
                        .font(.title3)
                        .foregroundColor(Color("Primary"))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Office Hours")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Text("Monday - Friday: 9:00 AM - 6:00 PM")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text("Weekends: By appointment")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Divider()

                // Service Area
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "map.fill")
                        .font(.title3)
                        .foregroundColor(Color("Primary"))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Service Area")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Text("Serving all of California with focus on Southern California")
                            .font(.caption)
                            .foregroundColor(.secondary)
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

    // MARK: - Quick Form Section
    private var quickFormSection: some View {
        VStack(spacing: 16) {
            Text("Prefer us to contact you?")
                .font(.headline)

            Text("Leave your information and we'll reach out within 24 hours.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(action: {
                showingLeadForm = true
            }) {
                HStack {
                    Image(systemName: "envelope.fill")
                    Text("Request Callback")
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

// MARK: - Contact Method Card
struct ContactMethodCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let actionText: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 50, height: 50)
                    .background(color.opacity(0.1))
                    .cornerRadius(12)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text(actionText)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(color.opacity(0.1))
                    .cornerRadius(16)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContactView()
}
