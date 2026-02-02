//
//  Quiz.swift
//  KitsinianLegal
//

import Foundation

// MARK: - Quiz Question
struct QuizQuestion: Identifiable {
    let id: String
    let text: String
    let subtext: String?
    let options: [QuizOption]
    let allowsMultiple: Bool
    let nextQuestionLogic: ((Set<String>) -> String?)?  // Returns next question ID or nil to end

    init(
        id: String,
        text: String,
        subtext: String? = nil,
        options: [QuizOption],
        allowsMultiple: Bool = false,
        nextQuestionLogic: ((Set<String>) -> String?)? = nil
    ) {
        self.id = id
        self.text = text
        self.subtext = subtext
        self.options = options
        self.allowsMultiple = allowsMultiple
        self.nextQuestionLogic = nextQuestionLogic
    }
}

// MARK: - Quiz Option
struct QuizOption: Identifiable {
    let id: String
    let text: String
    let icon: String?
    let leadsTo: String?  // Next question ID, or nil to determine result
    let resultArea: String?  // Practice area ID if this ends the quiz

    init(
        id: String,
        text: String,
        icon: String? = nil,
        leadsTo: String? = nil,
        resultArea: String? = nil
    ) {
        self.id = id
        self.text = text
        self.icon = icon
        self.leadsTo = leadsTo
        self.resultArea = resultArea
    }
}

// MARK: - Quiz Result
struct QuizResult {
    let practiceArea: PracticeArea
    let confidence: Double  // 0-1 how confident we are in this match
    let summary: String
    let nextSteps: [String]
}

// MARK: - Quiz Flow Definition
struct LegalQuiz {

    // MARK: - Main Category Question
    static let mainCategoryQuestion = QuizQuestion(
        id: "main_category",
        text: "What type of legal issue are you facing?",
        subtext: "Select the category that best describes your situation",
        options: [
            QuizOption(id: "injury", text: "I was injured", icon: "bandage.fill", leadsTo: "injury_type"),
            QuizOption(id: "vehicle", text: "Vehicle/property damage", icon: "car.fill", leadsTo: "vehicle_type"),
            QuizOption(id: "insurance", text: "Insurance dispute", icon: "shield.slash.fill", leadsTo: "insurance_type"),
            QuizOption(id: "family", text: "Family matter", icon: "figure.2.and.child.holdinghands", resultArea: "family-law"),
            QuizOption(id: "criminal", text: "Criminal charges", icon: "building.columns.fill", resultArea: "criminal-defense"),
            QuizOption(id: "employment", text: "Employment/workplace", icon: "briefcase.fill", leadsTo: "employment_type"),
            QuizOption(id: "business", text: "Business matter", icon: "building.fill", resultArea: "business-law"),
            QuizOption(id: "estate", text: "Estate planning/probate", icon: "doc.text.fill", resultArea: "estate-planning"),
            QuizOption(id: "immigration", text: "Immigration", icon: "globe.americas.fill", resultArea: "immigration"),
            QuizOption(id: "debt", text: "Debt/bankruptcy", icon: "chart.line.downtrend.xyaxis", resultArea: "bankruptcy"),
            QuizOption(id: "realestate", text: "Real estate/housing", icon: "house.and.flag.fill", resultArea: "real-estate-law"),
            QuizOption(id: "other", text: "Something else", icon: "questionmark.circle.fill", leadsTo: "describe_issue")
        ]
    )

    // MARK: - Injury Questions
    static let injuryTypeQuestion = QuizQuestion(
        id: "injury_type",
        text: "How were you injured?",
        options: [
            QuizOption(id: "car_accident", text: "Car, truck, or motorcycle accident", icon: "car.fill", leadsTo: "injury_severity"),
            QuizOption(id: "slip_fall", text: "Slip, trip, or fall", icon: "figure.fall", leadsTo: "fall_location"),
            QuizOption(id: "work_injury", text: "Injury at work", icon: "hammer.fill", leadsTo: "work_injury_type"),
            QuizOption(id: "medical", text: "Medical treatment went wrong", icon: "cross.case.fill", resultArea: "medical-malpractice"),
            QuizOption(id: "dog_bite", text: "Dog bite or animal attack", icon: "pawprint.fill", leadsTo: "injury_severity"),
            QuizOption(id: "rideshare", text: "Uber/Lyft accident", icon: "car.fill", leadsTo: "injury_severity"),
            QuizOption(id: "pedestrian", text: "Hit as pedestrian or cyclist", icon: "figure.walk", leadsTo: "injury_severity"),
            QuizOption(id: "product", text: "Defective product", icon: "exclamationmark.triangle.fill", leadsTo: "injury_severity"),
            QuizOption(id: "assault", text: "Assault or attack", icon: "exclamationmark.shield.fill", leadsTo: "assault_location"),
            QuizOption(id: "other_injury", text: "Other injury", icon: "bandage.fill", leadsTo: "injury_severity")
        ]
    )

    static let fallLocationQuestion = QuizQuestion(
        id: "fall_location",
        text: "Where did the fall occur?",
        options: [
            QuizOption(id: "store", text: "Store or shopping center", icon: "cart.fill", resultArea: "premises-liability"),
            QuizOption(id: "restaurant", text: "Restaurant or bar", icon: "fork.knife", resultArea: "premises-liability"),
            QuizOption(id: "apartment", text: "Apartment building", icon: "building.2.fill", resultArea: "premises-liability"),
            QuizOption(id: "sidewalk", text: "Sidewalk or public property", icon: "figure.walk", resultArea: "premises-liability"),
            QuizOption(id: "work", text: "At my workplace", icon: "briefcase.fill", leadsTo: "work_injury_type"),
            QuizOption(id: "private_home", text: "Someone's private home", icon: "house.fill", resultArea: "premises-liability"),
            QuizOption(id: "other_location", text: "Other location", icon: "mappin.circle.fill", resultArea: "premises-liability")
        ]
    )

    static let assaultLocationQuestion = QuizQuestion(
        id: "assault_location",
        text: "Where did this happen?",
        subtext: "Property owners may be liable for inadequate security",
        options: [
            QuizOption(id: "parking", text: "Parking lot or garage", icon: "car.fill", resultArea: "premises-liability"),
            QuizOption(id: "apartment", text: "Apartment complex", icon: "building.2.fill", resultArea: "premises-liability"),
            QuizOption(id: "bar", text: "Bar or nightclub", icon: "wineglass.fill", resultArea: "premises-liability"),
            QuizOption(id: "hotel", text: "Hotel or motel", icon: "bed.double.fill", resultArea: "premises-liability"),
            QuizOption(id: "store", text: "Store or business", icon: "cart.fill", resultArea: "premises-liability"),
            QuizOption(id: "public", text: "Public street", icon: "road.lanes", resultArea: "personal-injury"),
            QuizOption(id: "other", text: "Other location", icon: "mappin.circle.fill", resultArea: "personal-injury")
        ]
    )

    static let injurySeverityQuestion = QuizQuestion(
        id: "injury_severity",
        text: "How serious are your injuries?",
        options: [
            QuizOption(id: "emergency", text: "Required emergency room visit", icon: "cross.circle.fill", resultArea: "personal-injury"),
            QuizOption(id: "ongoing", text: "Required ongoing medical treatment", icon: "stethoscope", resultArea: "personal-injury"),
            QuizOption(id: "minor", text: "Minor injuries, mostly recovered", icon: "bandage.fill", resultArea: "personal-injury"),
            QuizOption(id: "unknown", text: "Still being evaluated", icon: "questionmark.circle.fill", resultArea: "personal-injury")
        ]
    )

    // MARK: - Work Injury Questions
    static let workInjuryTypeQuestion = QuizQuestion(
        id: "work_injury_type",
        text: "Tell us more about your work injury",
        options: [
            QuizOption(id: "sudden", text: "Sudden accident (fall, struck by object, etc.)", icon: "bolt.fill", resultArea: "workers-comp"),
            QuizOption(id: "repetitive", text: "Repetitive stress (carpal tunnel, back problems)", icon: "arrow.triangle.2.circlepath", resultArea: "workers-comp"),
            QuizOption(id: "exposure", text: "Toxic exposure or illness", icon: "aqi.medium", resultArea: "workers-comp"),
            QuizOption(id: "third_party", text: "Caused by someone other than employer", icon: "person.fill.questionmark", leadsTo: "third_party_work"),
            QuizOption(id: "denied", text: "Workers' comp claim was denied", icon: "xmark.circle.fill", resultArea: "workers-comp")
        ]
    )

    static let thirdPartyWorkQuestion = QuizQuestion(
        id: "third_party_work",
        text: "Who caused your injury?",
        subtext: "You may have claims beyond workers' compensation",
        options: [
            QuizOption(id: "contractor", text: "Another company/contractor", icon: "building.fill", resultArea: "personal-injury"),
            QuizOption(id: "driver", text: "Another driver (while working)", icon: "car.fill", resultArea: "personal-injury"),
            QuizOption(id: "product", text: "Defective equipment/product", icon: "exclamationmark.triangle.fill", resultArea: "personal-injury"),
            QuizOption(id: "property", text: "Unsafe property conditions", icon: "building.2.fill", resultArea: "premises-liability"),
            QuizOption(id: "unsure", text: "Not sure", icon: "questionmark.circle.fill", resultArea: "workers-comp")
        ]
    )

    // MARK: - Vehicle/Property Questions
    static let vehicleTypeQuestion = QuizQuestion(
        id: "vehicle_type",
        text: "What happened to your vehicle or property?",
        options: [
            QuizOption(id: "accident_damage", text: "Damaged in an accident", icon: "car.fill", leadsTo: "accident_injuries"),
            QuizOption(id: "totaled", text: "Vehicle totaled, unfair offer", icon: "xmark.circle.fill", resultArea: "property-damage"),
            QuizOption(id: "lemon", text: "Recurring mechanical problems", icon: "exclamationmark.triangle.fill", leadsTo: "lemon_questions"),
            QuizOption(id: "diminished", text: "Diminished value after repair", icon: "chart.line.downtrend.xyaxis", resultArea: "property-damage"),
            QuizOption(id: "theft", text: "Stolen or vandalized", icon: "lock.slash.fill", leadsTo: "theft_insurance"),
            QuizOption(id: "other_property", text: "Other property damage", icon: "house.fill", resultArea: "property-damage")
        ]
    )

    static let accidentInjuriesQuestion = QuizQuestion(
        id: "accident_injuries",
        text: "Were you injured in the accident?",
        options: [
            QuizOption(id: "yes_injured", text: "Yes, I was injured", icon: "bandage.fill", resultArea: "personal-injury"),
            QuizOption(id: "no_property_only", text: "No, just property damage", icon: "car.fill", resultArea: "property-damage")
        ]
    )

    static let lemonQuestions = QuizQuestion(
        id: "lemon_questions",
        text: "How many repair attempts for the same problem?",
        options: [
            QuizOption(id: "two_plus", text: "2 or more (safety issue)", icon: "exclamationmark.triangle.fill", resultArea: "lemon-law"),
            QuizOption(id: "four_plus", text: "4 or more (any issue)", icon: "wrench.and.screwdriver.fill", resultArea: "lemon-law"),
            QuizOption(id: "thirty_days", text: "In shop 30+ days total", icon: "calendar", resultArea: "lemon-law"),
            QuizOption(id: "one_attempt", text: "Just one attempt so far", icon: "1.circle.fill", resultArea: "lemon-law"),
            QuizOption(id: "not_sure", text: "Not sure if it qualifies", icon: "questionmark.circle.fill", resultArea: "lemon-law")
        ]
    )

    static let theftInsuranceQuestion = QuizQuestion(
        id: "theft_insurance",
        text: "How is your insurance claim going?",
        options: [
            QuizOption(id: "denied", text: "Claim was denied", icon: "xmark.circle.fill", resultArea: "insurance-bad-faith"),
            QuizOption(id: "lowball", text: "Offer is too low", icon: "chart.line.downtrend.xyaxis", resultArea: "property-damage"),
            QuizOption(id: "delayed", text: "Taking too long", icon: "clock.fill", resultArea: "insurance-bad-faith"),
            QuizOption(id: "not_filed", text: "Haven't filed yet", icon: "doc.fill", resultArea: "property-damage")
        ]
    )

    // MARK: - Insurance Questions
    static let insuranceTypeQuestion = QuizQuestion(
        id: "insurance_type",
        text: "What kind of insurance issue?",
        options: [
            QuizOption(id: "claim_denied", text: "My claim was denied", icon: "xmark.circle.fill", leadsTo: "insurance_claim_type"),
            QuizOption(id: "lowball", text: "Lowball settlement offer", icon: "chart.line.downtrend.xyaxis", leadsTo: "insurance_claim_type"),
            QuizOption(id: "delayed", text: "Unreasonable delays", icon: "clock.fill", resultArea: "insurance-bad-faith"),
            QuizOption(id: "coverage_dispute", text: "Coverage dispute", icon: "questionmark.diamond.fill", resultArea: "insurance-bad-faith"),
            QuizOption(id: "bad_communication", text: "Won't return calls/respond", icon: "phone.down.fill", resultArea: "insurance-bad-faith")
        ]
    )

    static let insuranceClaimTypeQuestion = QuizQuestion(
        id: "insurance_claim_type",
        text: "What type of claim is this?",
        options: [
            QuizOption(id: "auto", text: "Auto insurance", icon: "car.fill", resultArea: "insurance-bad-faith"),
            QuizOption(id: "health", text: "Health insurance", icon: "heart.fill", resultArea: "insurance-bad-faith"),
            QuizOption(id: "homeowners", text: "Homeowners insurance", icon: "house.fill", resultArea: "insurance-bad-faith"),
            QuizOption(id: "life", text: "Life insurance", icon: "person.fill", resultArea: "insurance-bad-faith"),
            QuizOption(id: "disability", text: "Disability insurance", icon: "figure.roll", resultArea: "insurance-bad-faith"),
            QuizOption(id: "other", text: "Other type", icon: "shield.fill", resultArea: "insurance-bad-faith")
        ]
    )

    // MARK: - Employment Questions
    static let employmentTypeQuestion = QuizQuestion(
        id: "employment_type",
        text: "What's your employment issue?",
        options: [
            QuizOption(id: "injured", text: "I was injured at work", icon: "bandage.fill", leadsTo: "work_injury_type"),
            QuizOption(id: "fired", text: "I was fired/let go", icon: "person.fill.xmark", resultArea: "employment-law"),
            QuizOption(id: "discrimination", text: "Discrimination", icon: "person.fill.questionmark", resultArea: "employment-law"),
            QuizOption(id: "harassment", text: "Harassment", icon: "exclamationmark.bubble.fill", resultArea: "employment-law"),
            QuizOption(id: "wages", text: "Unpaid wages/overtime", icon: "dollarsign.circle.fill", resultArea: "employment-law"),
            QuizOption(id: "retaliation", text: "Retaliation", icon: "arrow.uturn.backward.circle.fill", resultArea: "employment-law"),
            QuizOption(id: "contract", text: "Contract dispute", icon: "doc.text.fill", resultArea: "employment-law")
        ]
    )

    // MARK: - Catch-all
    static let describeIssueQuestion = QuizQuestion(
        id: "describe_issue",
        text: "Let us help you find the right direction",
        subtext: "We'll review your situation and connect you with the right resources",
        options: [
            QuizOption(id: "contact_us", text: "Contact us to discuss", icon: "phone.fill", resultArea: "personal-injury")
        ]
    )

    // MARK: - All Questions Dictionary
    static let allQuestions: [String: QuizQuestion] = [
        "main_category": mainCategoryQuestion,
        "injury_type": injuryTypeQuestion,
        "fall_location": fallLocationQuestion,
        "assault_location": assaultLocationQuestion,
        "injury_severity": injurySeverityQuestion,
        "work_injury_type": workInjuryTypeQuestion,
        "third_party_work": thirdPartyWorkQuestion,
        "vehicle_type": vehicleTypeQuestion,
        "accident_injuries": accidentInjuriesQuestion,
        "lemon_questions": lemonQuestions,
        "theft_insurance": theftInsuranceQuestion,
        "insurance_type": insuranceTypeQuestion,
        "insurance_claim_type": insuranceClaimTypeQuestion,
        "employment_type": employmentTypeQuestion,
        "describe_issue": describeIssueQuestion
    ]

    static func getQuestion(id: String) -> QuizQuestion? {
        allQuestions[id]
    }
}
