//
//  Spacing.swift
//  ClaimIt
//
//  Spacing and corner radius constants for consistent layouts
//

import SwiftUI

// MARK: - Spacing System
enum Spacing {
    /// 2pt - Hairline spacing
    static let xxs: CGFloat = 2

    /// 4pt - Tight spacing (icon gaps, inline elements)
    static let xs: CGFloat = 4

    /// 6pt - Small internal padding
    static let xsPlus: CGFloat = 6

    /// 8pt - Standard small spacing
    static let sm: CGFloat = 8

    /// 10pt - Between small elements
    static let smPlus: CGFloat = 10

    /// 12pt - Default internal padding
    static let md: CGFloat = 12

    /// 14pt - Medium-large internal padding
    static let mdPlus: CGFloat = 14

    /// 16pt - Standard content padding
    static let lg: CGFloat = 16

    /// 20pt - Section spacing
    static let xl: CGFloat = 20

    /// 24pt - Large section spacing
    static let xxl: CGFloat = 24

    /// 32pt - Major section dividers
    static let xxxl: CGFloat = 32

    /// 40pt - Large gaps
    static let huge: CGFloat = 40

    /// 48pt - Hero spacing
    static let massive: CGFloat = 48

    /// 64pt - Extra large spacing
    static let giant: CGFloat = 64
}

// MARK: - Corner Radius
enum CornerRadius {
    /// 4pt - Small elements (badges, pills)
    static let sm: CGFloat = 4

    /// 8pt - Inputs, small cards
    static let md: CGFloat = 8

    /// 12pt - Buttons, icon containers
    static let lg: CGFloat = 12

    /// 14pt - Primary buttons
    static let lgPlus: CGFloat = 14

    /// 16pt - Cards, quiz options
    static let xl: CGFloat = 16

    /// 20pt - Large cards
    static let xxl: CGFloat = 20

    /// 24pt - Hero cards, modals
    static let xxxl: CGFloat = 24

    /// 9999pt - Full pill/circle
    static let pill: CGFloat = 9999
}

// MARK: - Icon Sizes
enum IconSize {
    /// 12pt - Inline icons
    static let xs: CGFloat = 12

    /// 16pt - Small icons
    static let sm: CGFloat = 16

    /// 20pt - Standard icons
    static let md: CGFloat = 20

    /// 24pt - Large icons
    static let lg: CGFloat = 24

    /// 28pt - Extra large icons
    static let xl: CGFloat = 28

    /// 32pt - Hero icons
    static let xxl: CGFloat = 32

    /// 44pt - Touch target minimum
    static let touchTarget: CGFloat = 44

    /// 48pt - Large touch targets
    static let largeTouchTarget: CGFloat = 48
}

// MARK: - Content Width
enum ContentWidth {
    /// Maximum content width for iPhone
    static let iPhone: CGFloat = .infinity

    /// Maximum content width for iPad (readable width)
    static let iPad: CGFloat = 650

    /// Maximum form width for iPad
    static let formIPad: CGFloat = 600

    /// Maximum modal width for iPad
    static let modalIPad: CGFloat = 500
}

// MARK: - View Extensions
extension View {
    /// Apply standard content padding
    func contentPadding(_ size: CGFloat = Spacing.lg) -> some View {
        self.padding(size)
    }

    /// Apply horizontal content padding
    func horizontalPadding(_ size: CGFloat = Spacing.lg) -> some View {
        self.padding(.horizontal, size)
    }

    /// Apply vertical section spacing
    func sectionSpacing(_ size: CGFloat = Spacing.xxl) -> some View {
        self.padding(.vertical, size)
    }
}

// MARK: - iPad Spacing Variants
extension Spacing {
    static func scaled(for sizeClass: UserInterfaceSizeClass?) -> SpacingScale {
        sizeClass == .regular ? .iPad : .iPhone
    }
}

enum SpacingScale {
    case iPhone
    case iPad

    var contentPadding: CGFloat {
        switch self {
        case .iPhone: return Spacing.lg
        case .iPad: return Spacing.xxl
        }
    }

    var sectionSpacing: CGFloat {
        switch self {
        case .iPhone: return Spacing.xxl
        case .iPad: return Spacing.xxxl
        }
    }

    var cardPadding: CGFloat {
        switch self {
        case .iPhone: return Spacing.lg
        case .iPad: return Spacing.xl
        }
    }

    var itemSpacing: CGFloat {
        switch self {
        case .iPhone: return Spacing.md
        case .iPad: return Spacing.lg
        }
    }
}
