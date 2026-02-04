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
    // Primary Brand Colors (consistent across themes)
    static let claimPrimary = Color(hex: "0066FF")
    static let claimPrimaryLight = Color(hex: "4D94FF")
    static let claimPrimaryDark = Color(hex: "0047B3")

    // Accent Colors (consistent across themes)
    static let claimAccent = Color(hex: "FF6B35")
    static let claimAccentLight = Color(hex: "FF8855")

    // Semantic Colors (consistent across themes)
    static let claimSuccess = Color(hex: "00C48C")
    static let claimWarning = Color(hex: "F59E0B")
    static let claimError = Color(hex: "EF4444")
    static let claimGold = Color(hex: "F59E0B")

    // Emergency/Accident Mode Colors (always visible regardless of theme)
    static let claimEmergencyRed = Color(hex: "DC2626")
    static let claimEmergencyRedDark = Color(hex: "B91C1C")

    // MARK: - Adaptive Colors (Light/Dark Mode)

    // Background Colors - Adaptive
    static let claimBackground = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "0F172A")  // Dark: slate-900
                : UIColor(hex: "F8FAFC")  // Light: slate-50
        }
    )

    static let claimBackgroundSecondary = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "1E293B")  // Dark: slate-800
                : UIColor(hex: "F1F5F9")  // Light: slate-100
        }
    )

    static let claimCardBackground = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "1E293B")  // Dark: slate-800
                : UIColor.white
        }
    )

    static let claimCardBackgroundElevated = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "334155")  // Dark: slate-700
                : UIColor.white
        }
    )

    // Border Colors - Adaptive
    static let claimBorder = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "334155")  // Dark: slate-700
                : UIColor(hex: "E5E7EB")  // Light: gray-200
        }
    )

    static let claimBorderLight = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "475569")  // Dark: slate-600
                : UIColor(hex: "F3F4F6")  // Light: gray-100
        }
    )

    // Text Colors - Adaptive
    static let claimTextPrimary = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "F8FAFC")  // Dark: slate-50
                : UIColor(hex: "111827")  // Light: gray-900
        }
    )

    static let claimTextSecondary = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "CBD5E1")  // Dark: slate-300
                : UIColor(hex: "4B5563")  // Light: gray-600
        }
    )

    static let claimTextMuted = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "94A3B8")  // Dark: slate-400 (improved WCAG AA contrast)
                : UIColor(hex: "9CA3AF")  // Light: gray-400
        }
    )

    // MARK: - Interactive State Colors (Light/Dark Mode)

    // Selected/Highlighted state backgrounds
    static let claimSelectedBackground = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "0066FF").withAlphaComponent(0.15)  // Dark: primary with opacity
                : UIColor(hex: "FFF5F0")  // Light: warm accent tint
        }
    )

    static let claimSelectedBackgroundAlt = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "1E3A5F")  // Dark: deep blue
                : UIColor(hex: "EBF5FF")  // Light: light blue
        }
    )

    // Input field backgrounds
    static let claimInputBackground = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "334155")  // Dark: slate-700 (elevated)
                : UIColor.white
        }
    )

    // MARK: - Status Badge Colors (Adaptive)

    static let claimStatusSubmittedBg = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "E5E7EB").withAlphaComponent(0.15)
                : UIColor(hex: "E5E7EB")
        }
    )

    static let claimStatusSubmittedText = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "CBD5E1")  // Dark: slate-300
                : UIColor(hex: "4B5563")  // Light: gray-600
        }
    )

    static let claimStatusReviewBg = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "3B82F6").withAlphaComponent(0.2)
                : UIColor(hex: "DBEAFE")
        }
    )

    static let claimStatusReviewText = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "93C5FD")  // Dark: blue-300
                : UIColor(hex: "1D4ED8")  // Light: blue-700
        }
    )

    static let claimStatusQualifiedBg = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "10B981").withAlphaComponent(0.2)
                : UIColor(hex: "D1FAE5")
        }
    )

    static let claimStatusQualifiedText = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "6EE7B7")  // Dark: emerald-300
                : UIColor(hex: "059669")  // Light: emerald-600
        }
    )

    static let claimStatusMatchedBg = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "F59E0B").withAlphaComponent(0.2)
                : UIColor(hex: "FEF3C7")
        }
    )

    static let claimStatusMatchedText = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "FCD34D")  // Dark: amber-300
                : UIColor(hex: "D97706")  // Light: amber-600
        }
    )

    // Toggle/Switch track colors
    static let claimToggleOff = Color(
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: "334155")  // Dark: slate-700
                : UIColor(hex: "E5E7EB")  // Light: gray-200
        }
    )

    // Hex initializer for Color
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

// MARK: - UIColor Hex Extension
extension UIColor {
    convenience init(hex: String) {
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
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
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
        colors: [Color(hex: "0066FF"), Color(hex: "00D4FF")],
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
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .background(Color.claimCardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.claimBorder, lineWidth: 1)
            )
            .shadow(
                color: colorScheme == .dark ? .black.opacity(0.25) : .black.opacity(0.08),
                radius: 3,
                x: 0,
                y: 1
            )
    }
}

// MARK: - Elevated Card Style (for modals, popovers)
struct ClaimElevatedCardStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .background(Color.claimCardBackgroundElevated)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.claimBorder, lineWidth: 1)
            )
            .shadow(
                color: colorScheme == .dark ? .black.opacity(0.4) : .black.opacity(0.12),
                radius: 16,
                x: 0,
                y: 8
            )
    }
}

extension View {
    func claimCard() -> some View {
        modifier(ClaimCardStyle())
    }

    func claimElevatedCard() -> some View {
        modifier(ClaimElevatedCardStyle())
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
            .background(Color.claimCardBackground)
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
        .background(Color.claimCardBackground)
        .cornerRadius(16)
        .claimShadowMedium()
    }
}

// MARK: - Dark Mode Aware Shadow
extension View {
    func claimShadowAdaptive(radius: CGFloat = 12, y: CGFloat = 4) -> some View {
        self.modifier(AdaptiveShadowModifier(radius: radius, y: y))
    }
}

struct AdaptiveShadowModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let radius: CGFloat
    let y: CGFloat

    func body(content: Content) -> some View {
        content.shadow(
            color: colorScheme == .dark
                ? .black.opacity(0.3)
                : .black.opacity(0.08),
            radius: radius,
            x: 0,
            y: y
        )
    }
}

// MARK: - Status Badge View
enum CaseStatus: String {
    case submitted = "Submitted"
    case underReview = "Under Review"
    case qualified = "Qualified"
    case matched = "Matched"
    case retained = "Retained"

    var backgroundColor: Color {
        switch self {
        case .submitted: return .claimStatusSubmittedBg
        case .underReview: return .claimStatusReviewBg
        case .qualified, .retained: return .claimStatusQualifiedBg
        case .matched: return .claimStatusMatchedBg
        }
    }

    var textColor: Color {
        switch self {
        case .submitted: return .claimStatusSubmittedText
        case .underReview: return .claimStatusReviewText
        case .qualified, .retained: return .claimStatusQualifiedText
        case .matched: return .claimStatusMatchedText
        }
    }
}

struct StatusBadge: View {
    let status: CaseStatus

    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(status.textColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(status.backgroundColor)
            .cornerRadius(8)
    }
}

// MARK: - Glass Card Style (for overlays/modals)
struct GlassCardModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .background(
                colorScheme == .dark
                    ? Color(hex: "1E293B").opacity(0.85)
                    : Color.white.opacity(0.9)
            )
            .background(.ultraThinMaterial)
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        colorScheme == .dark
                            ? Color.white.opacity(0.1)
                            : Color.white.opacity(0.5),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: colorScheme == .dark ? .black.opacity(0.4) : .black.opacity(0.15),
                radius: 20,
                x: 0,
                y: 10
            )
    }
}

extension View {
    func glassCard() -> some View {
        modifier(GlassCardModifier())
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
