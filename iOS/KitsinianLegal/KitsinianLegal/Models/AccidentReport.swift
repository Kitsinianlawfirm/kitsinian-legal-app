//
//  AccidentReport.swift
//  ClaimIt
//
//  Model for accident evidence collection
//

import Foundation
import CoreLocation

// MARK: - Accident Report Model
struct AccidentReport: Identifiable, Codable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var location: AccidentLocation?
    var safetyCheck: SafetyCheck?
    var photos: [AccidentPhoto] = []
    var voiceRecording: VoiceRecording?
    var witnesses: [Witness] = []
    var remindersAcknowledged: Bool = false
    var status: ReportStatus = .inProgress
    var submittedAt: Date?

    enum ReportStatus: String, Codable {
        case inProgress = "in_progress"
        case readyToSubmit = "ready_to_submit"
        case submitted = "submitted"
        case synced = "synced"
    }
}

// MARK: - Location
struct AccidentLocation: Codable {
    var latitude: Double
    var longitude: Double
    var address: String?
    var timestamp: Date

    init(coordinate: CLLocationCoordinate2D, address: String? = nil) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.address = address
        self.timestamp = Date()
    }
}

// MARK: - Safety Check
struct SafetyCheck: Codable {
    var isSafe: Bool
    var calledEmergency: Bool
    var timestamp: Date

    init(isSafe: Bool, calledEmergency: Bool = false) {
        self.isSafe = isSafe
        self.calledEmergency = calledEmergency
        self.timestamp = Date()
    }
}

// MARK: - Photo Evidence
struct AccidentPhoto: Identifiable, Codable {
    var id: UUID = UUID()
    var type: PhotoType
    var localPath: String?
    var capturedAt: Date = Date()
    var isUploaded: Bool = false

    enum PhotoType: String, Codable, CaseIterable {
        case sceneOverview = "scene_overview"
        case vehicleFront = "vehicle_front"
        case vehicleSide = "vehicle_side"
        case vehicleRear = "vehicle_rear"
        case otherVehicle = "other_vehicle"
        case licensePlates = "license_plates"
        case insuranceCards = "insurance_cards"
        case roadConditions = "road_conditions"

        var displayName: String {
            switch self {
            case .sceneOverview: return "Scene Overview"
            case .vehicleFront: return "Your Vehicle - Front"
            case .vehicleSide: return "Your Vehicle - Side"
            case .vehicleRear: return "Your Vehicle - Rear"
            case .otherVehicle: return "Other Vehicle Damage"
            case .licensePlates: return "License Plates"
            case .insuranceCards: return "Insurance Cards"
            case .roadConditions: return "Road Conditions"
            }
        }

        var description: String {
            switch self {
            case .sceneOverview: return "Wide shot showing the full accident scene"
            case .vehicleFront: return "Document all front damage to your vehicle"
            case .vehicleSide: return "Capture side damage from multiple angles"
            case .vehicleRear: return "Document any rear damage"
            case .otherVehicle: return "Photograph the other vehicle's condition"
            case .licensePlates: return "Both vehicles' license plates"
            case .insuranceCards: return "Both drivers' insurance information"
            case .roadConditions: return "Signs, weather, road hazards"
            }
        }

        var icon: String {
            switch self {
            case .sceneOverview: return "camera.viewfinder"
            case .vehicleFront: return "car.front.waves.up"
            case .vehicleSide: return "car.side"
            case .vehicleRear: return "car.rear"
            case .otherVehicle: return "car.2"
            case .licensePlates: return "rectangle.and.text.magnifyingglass"
            case .insuranceCards: return "creditcard"
            case .roadConditions: return "road.lanes"
            }
        }
    }
}

// MARK: - Voice Recording
struct VoiceRecording: Codable {
    var localPath: String
    var duration: TimeInterval
    var recordedAt: Date
    var transcription: String?
    var isUploaded: Bool = false
}

// MARK: - Witness
struct Witness: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var phone: String
    var email: String?
    var notes: String?
    var addedAt: Date = Date()
}

// MARK: - Critical Reminders
struct CriticalReminders {
    static let dos: [(icon: String, text: String)] = [
        ("checkmark.shield", "Check for injuries first"),
        ("phone.arrow.up.right", "Call 911 if anyone is hurt"),
        ("camera", "Take photos of EVERYTHING"),
        ("person.2", "Get witness contact info"),
        ("doc.text", "Get police report number"),
        ("cross.case", "Seek medical attention within 24 hours")
    ]

    static let donts: [(icon: String, text: String)] = [
        ("xmark.circle", "Admit fault or apologize"),
        ("signature", "Sign anything at the scene"),
        ("mic.slash", "Give recorded statement to insurance"),
        ("dollarsign.circle", "Accept first settlement offer"),
        ("iphone", "Post about accident on social media")
    ]
}
