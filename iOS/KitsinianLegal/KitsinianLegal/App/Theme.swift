//
//  Theme.swift
//  ClaimIt
//
//  ClaimIt Design System
//  Modern, clean design with bold branding
//

import SwiftUI

// MARK: - App Colors
extension Color {
    // Primary Brand Colors
    static let claimPrimary = Color(hex: "0066FF")
    static let claimPrimaryLight = Color(hex: "4D94FF")
    static let claimPrimaryDark = Color(hex: "0047B3")

    // Accent Colors
    static let claimAccent = Color(hex: "FF6B35")
    static let claimAccentLight = Color(hex: "FF8855")

    // Semantic Colors
    static let claimSuccess = Color(hex: "00C48C")
    static let claimWarning = Color(hex: "F59E0B")
    static let claimGold = Color(hex: "F59E0B")

    // Neutral Colors
    static let claimBackground = Color(hex: "F8FAFC")
    static let claimCardBackground = Color.white
    static let claimBorder = Color(hex: "E5E7EB")

    // Text Colors
    static let claimTextPrimary = Color(hex: "111827")
    static let claimTextSecondary = Color(hex: "4B5563")
    static let claimTextMuted = Color(hex: "9CA3AF")

    // Hex initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Gradients
extension LinearGradient {
    static let claimPrimaryGradient = LinearGradient(
        colors: [.claimPrimary, .claimPrimaryLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let claimAccentGradient = LinearGradient(
        colors: [.claimAccent, .claimAccentLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let claimSuccessGradient = LinearGradient(
        colors: [.claimSuccess, Color(hex: "00D9A0")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let claimHeroGradient = LinearGradient(
        colors: [.claimPrimary, .claimPrimaryDark],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Shadows
extension View {
    func claimShadowSmall() -> some View {
        self.shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 1)
    }

    func claimShadowMedium() -> some View {
        self.shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
    }

    func claimShadowLarge() -> some View {
        self.shadow(color: .black.opacity(0.12), radius: 24, x: 0, y: 8)
    }
}

// MARK: - Card Style
struct ClaimCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.claimCardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.claimBorder, lineWidth: 1)
            )
            .claimShadowSmall()
    }
}

extension View {
    func claimCard() -> some View {
        modifier(ClaimCardStyle())
    }
}

// MARK: - Primary Button Style
struct ClaimPrimaryButtonStyle: ButtonStyle {
    var isAccent: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                isAccent ? LinearGradient.claimAccentGradient : LinearGradient.claimPrimaryGradient
            )
            .cornerRadius(14)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Secondary Button Style
struct ClaimSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.claimPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color.white)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.claimPrimary, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Logo View
struct ClaimItLogo: View {
    var size: CGFloat = 56
    var showText: Bool = true
    var textColor: Color = .white

    var body: some View {
        HStack(spacing: 10) {
            // Shield with lightning bolt
            ZStack {
                // Shield shape
                Image(systemName: "shield.fill")
                    .font(.system(size: size * 0.85))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.claimGold, .claimAccent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Lightning bolt
                Image(systemName: "bolt.fill")
                    .font(.system(size: size * 0.4))
                    .foregroundColor(.white)
            }
            .frame(width: size, height: size)

            if showText {
                HStack(spacing: 0) {
                    Text("Claim")
                        .font(.system(size: size * 0.55, weight: .heavy))
                        .foregroundColor(textColor)
                    Text("It")
                        .font(.system(size: size * 0.55, weight: .heavy))
                        .foregroundColor(.claimGold)
                }
            }
        }
    }
}

// MARK: - Icon with Gradient Background
struct GradientIconView: View {
    let systemName: String
    var size: CGFloat = 44
    var iconSize: CGFloat = 22
    var gradient: LinearGradient = .claimPrimaryGradient

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.27)
                .fill(gradient)
                .frame(width: size, height: size)

            Image(systemName: systemName)
                .font(.system(size: iconSize, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Trust Badge
struct TrustBadge: View {
    let value: String
    let label: String
    var compact: Bool = false

    var body: some View {
        VStack(spacing: compact ? 2 : 4) {
            Text(value)
                .font(.system(size: compact ? 18 : 22, weight: .heavy))
                .foregroundColor(.claimPrimary)

            Text(label.uppercased())
                .font(.system(size: compact ? 9 : 11, weight: .semibold))
                .foregroundColor(.claimTextSecondary)
                .tracking(0.3)
        }
        .frame(minWidth: compact ? 80 : 90)
        .padding(.vertical, compact ? 10 : 14)
        .padding(.horizontal, compact ? 12 : 16)
        .background(Color.white)
        .cornerRadius(16)
        .claimShadowMedium()
    }
}

#Preview("Logo") {
    ZStack {
        Color.claimPrimary
        ClaimItLogo(size: 60)
    }
}

#Preview("Buttons") {
    VStack(spacing: 20) {
        Button("Primary Button") {}
            .buttonStyle(ClaimPrimaryButtonStyle())

        Button("Accent Button") {}
            .buttonStyle(ClaimPrimaryButtonStyle(isAccent: true))

        Button("Secondary Button") {}
            .buttonStyle(ClaimSecondaryButtonStyle())
    }
    .padding()
}
