//
//  Lead.swift
//  KitsinianLegal
//

import Foundation

// MARK: - Lead Model
struct Lead: Identifiable, Codable {
    var id: UUID = UUID()
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phone: String = ""
    var preferredContact: ContactMethod = .phone
    var practiceArea: String = ""
    var practiceAreaCategory: String = ""
    var incidentDate: Date?
    var description: String = ""
    var quizAnswers: [String: String] = [:]
    var urgency: Urgency = .normal
    var createdAt: Date = Date()
    var source: String = "ios_app"

    enum ContactMethod: String, Codable, CaseIterable {
        case phone = "phone"
        case email = "email"
        case text = "text"

        var displayName: String {
            switch self {
            case .phone: return "Phone Call"
            case .email: return "Email"
            case .text: return "Text Message"
            }
        }

        var icon: String {
            switch self {
            case .phone: return "phone.fill"
            case .email: return "envelope.fill"
            case .text: return "message.fill"
            }
        }
    }

    enum Urgency: String, Codable, CaseIterable {
        case urgent = "urgent"
        case normal = "normal"
        case informational = "informational"

        var displayName: String {
            switch self {
            case .urgent: return "Urgent - Need help immediately"
            case .normal: return "Soon - Within a few days"
            case .informational: return "Just exploring options"
            }
        }
    }

    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }

    var isValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !email.isEmpty &&
        !phone.isEmpty &&
        !practiceArea.isEmpty
    }
}

// MARK: - Lead Submission Response
struct LeadResponse: Codable {
    let success: Bool
    let leadId: String?
    let message: String
    let estimatedResponse: String?
}
