//
//  Typography.swift
//  ClaimIt
//
//  Typography scale for consistent text styling
//

import SwiftUI

// MARK: - Typography System
enum Typography {
    // MARK: - Display (Hero titles)
    static let display = Font.system(size: 42, weight: .black)
    static let displaySmall = Font.system(size: 36, weight: .black)

    // MARK: - Headings
    static let h1 = Font.system(size: 34, weight: .heavy)
    static let h2 = Font.system(size: 28, weight: .bold)
    static let h3 = Font.system(size: 22, weight: .bold)
    static let h4 = Font.system(size: 18, weight: .semibold)
    static let h5 = Font.system(size: 16, weight: .semibold)

    // MARK: - Body Text
    static let bodyLarge = Font.system(size: 17, weight: .regular)
    static let body = Font.system(size: 15, weight: .regular)
    static let bodySmall = Font.system(size: 13, weight: .regular)

    // MARK: - Labels
    static let label = Font.system(size: 14, weight: .medium)
    static let labelSmall = Font.system(size: 12, weight: .medium)
    static let labelTiny = Font.system(size: 10, weight: .medium)

    // MARK: - Buttons
    static let buttonLarge = Font.system(size: 17, weight: .bold)
    static let button = Font.system(size: 16, weight: .semibold)
    static let buttonSmall = Font.system(size: 14, weight: .semibold)

    // MARK: - Caption/Meta
    static let caption = Font.system(size: 12, weight: .regular)
    static let captionSmall = Font.system(size: 10, weight: .regular)

    // MARK: - Numbers (for stats, badges)
    static let statLarge = Font.system(size: 32, weight: .heavy)
    static let stat = Font.system(size: 24, weight: .heavy)
    static let statSmall = Font.system(size: 20, weight: .bold)
}

// MARK: - iPad Typography Variants
extension Typography {
    static func scaled(for sizeClass: UserInterfaceSizeClass?) -> TypographyScale {
        sizeClass == .regular ? .iPad : .iPhone
    }
}

enum TypographyScale {
    case iPhone
    case iPad

    var h1: Font {
        switch self {
        case .iPhone: return Typography.h1
        case .iPad: return Font.system(size: 38, weight: .heavy)
        }
    }

    var h2: Font {
        switch self {
        case .iPhone: return Typography.h2
        case .iPad: return Font.system(size: 32, weight: .bold)
        }
    }

    var h3: Font {
        switch self {
        case .iPhone: return Typography.h3
        case .iPad: return Font.system(size: 26, weight: .bold)
        }
    }

    var body: Font {
        switch self {
        case .iPhone: return Typography.body
        case .iPad: return Font.system(size: 17, weight: .regular)
        }
    }

    var label: Font {
        switch self {
        case .iPhone: return Typography.label
        case .iPad: return Font.system(size: 15, weight: .medium)
        }
    }
}

// MARK: - View Extension for Typography
extension View {
    func typography(_ font: Font, color: Color = .claimTextPrimary) -> some View {
        self
            .font(font)
            .foregroundColor(color)
    }
}
