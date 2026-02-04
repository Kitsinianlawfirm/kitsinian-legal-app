//
//  PracticeArea.swift
//  KitsinianLegal
//

import Foundation

// MARK: - Practice Area Model
struct PracticeArea: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let shortDescription: String
    let fullDescription: String
    let icon: String
    let category: Category
    let commonCauses: [String]
    let whatWeDo: [String]
    let faq: [FAQ]

    enum Category: String, Codable, CaseIterable {
        case inHouse = "in_house"
        case referral = "referral"

        var displayName: String {
            switch self {
            case .inHouse: return "We Handle Directly"
            case .referral: return "Trusted Referral Network"
            }
        }
    }

    struct FAQ: Codable, Hashable {
        let question: String
        let answer: String
    }
}

// MARK: - Practice Areas Data
extension PracticeArea {

    // MARK: - In-House Practice Areas
    static let personalInjury = PracticeArea(
        id: "personal-injury",
        name: "Personal Injury",
        shortDescription: "Accidents, negligence, pain & suffering",
        fullDescription: "When you've been injured because of someone else's carelessness, you deserve fair compensation for your medical bills, lost wages, pain and suffering, and other damages. Our personal injury team has recovered millions for injured Californians.",
        icon: "cross.case.fill",
        category: .inHouse,
        commonCauses: [
            "Car, motorcycle, and truck accidents",
            "Slip and fall incidents",
            "Dog bites and animal attacks",
            "Workplace injuries",
            "Bicycle and pedestrian accidents",
            "Rideshare accidents (Uber/Lyft)"
        ],
        whatWeDo: [
            "Free case evaluation within 24 hours",
            "No fees unless we win your case",
            "Handle all communication with insurance companies",
            "Coordinate with medical providers",
            "Negotiate maximum settlement or take your case to trial",
            "Help with property damage claims"
        ],
        faq: [
            FAQ(question: "How long do I have to file a personal injury claim in California?",
                answer: "In California, you generally have 2 years from the date of injury to file a personal injury lawsuit. However, there are exceptions, so it's crucial to consult with an attorney as soon as possible."),
            FAQ(question: "What if I was partially at fault for my accident?",
                answer: "California follows 'comparative negligence' rules. You can still recover damages even if you were partially at fault, though your recovery may be reduced by your percentage of fault."),
            FAQ(question: "How much is my case worth?",
                answer: "Every case is unique. Factors include severity of injuries, medical expenses, lost income, pain and suffering, and long-term impacts. We provide free consultations to evaluate your specific situation."),
            FAQ(question: "Do I need to go to court?",
                answer: "Most personal injury cases settle before trial. However, we're fully prepared to take your case to court if the insurance company won't offer fair compensation.")
        ]
    )

    static let premisesLiability = PracticeArea(
        id: "premises-liability",
        name: "Premises Liability",
        shortDescription: "Slip & fall, unsafe properties",
        fullDescription: "Property owners and occupiers have a legal obligation to maintain safe conditions. When they fail and you get hurt, they can be held responsible. We handle slip and falls, inadequate security, dangerous conditions, and more.",
        icon: "building.fill",
        category: .inHouse,
        commonCauses: [
            "Wet or slippery floors",
            "Uneven sidewalks or flooring",
            "Poor lighting",
            "Broken stairs or handrails",
            "Inadequate security leading to assault",
            "Swimming pool accidents",
            "Elevator and escalator malfunctions",
            "Falling merchandise in stores"
        ],
        whatWeDo: [
            "Investigate the property conditions",
            "Gather surveillance footage and evidence",
            "Identify all responsible parties",
            "Document building code violations",
            "Calculate full damages including future medical needs",
            "Negotiate with property insurance carriers"
        ],
        faq: [
            FAQ(question: "What do I need to prove in a premises liability case?",
                answer: "You must show: 1) The property owner/occupier owed you a duty of care, 2) They breached that duty through negligence, 3) Their negligence caused your injury, and 4) You suffered damages as a result."),
            FAQ(question: "I fell at a store but didn't report it. Can I still sue?",
                answer: "Yes, but it's more challenging. We can still investigate through surveillance footage, witness statements, and other evidence. The sooner you contact us, the better we can preserve evidence."),
            FAQ(question: "The property owner says I should have been more careful. What now?",
                answer: "This is a common defense. California's comparative negligence law means you can still recover even if you share some fault. We build strong cases showing the property owner's greater responsibility.")
        ]
    )

    static let propertyDamage = PracticeArea(
        id: "property-damage",
        name: "Property Damage",
        shortDescription: "Fire, water, theft, vehicle damage",
        fullDescription: "Insurance companies routinely undervalue property damage claims. Whether your car was totaled in an accident or your property was damaged, we fight to get you the full value you deserve—not the first lowball offer.",
        icon: "house.fill",
        category: .inHouse,
        commonCauses: [
            "Vehicle damage from car accidents",
            "Total loss vehicle claims",
            "Diminished value after repairs",
            "Rental car and loss of use",
            "Personal property inside vehicles",
            "Property damage from negligent parties"
        ],
        whatWeDo: [
            "Challenge unfair insurance valuations",
            "Obtain independent appraisals",
            "Document diminished value",
            "Recover rental car costs",
            "Handle total loss negotiations",
            "Pursue all responsible parties"
        ],
        faq: [
            FAQ(question: "The insurance company's offer seems low. What can I do?",
                answer: "You don't have to accept their first offer. We can obtain independent appraisals, document comparable vehicle sales, and negotiate for fair market value."),
            FAQ(question: "What is diminished value?",
                answer: "Even after repairs, a vehicle that's been in an accident is worth less than one that hasn't. In California, you may be entitled to compensation for this 'diminished value.'"),
            FAQ(question: "My car was totaled. How is the value determined?",
                answer: "Insurance companies use various methods, often undervaluing vehicles. We ensure they account for your specific vehicle's condition, mileage, options, and comparable sales in your area.")
        ]
    )

    static let insuranceBadFaith = PracticeArea(
        id: "insurance-bad-faith",
        name: "Insurance Bad Faith",
        shortDescription: "Denied claims, lowball offers",
        fullDescription: "You pay premiums expecting your insurance company to be there when you need them. When they unreasonably deny, delay, or undervalue your claim, they may be acting in bad faith—and you can hold them accountable for additional damages.",
        icon: "shield.fill",
        category: .inHouse,
        commonCauses: [
            "Unreasonable claim denials",
            "Excessive delays in processing",
            "Lowball settlement offers",
            "Failure to investigate properly",
            "Misrepresenting policy terms",
            "Refusing to defend lawsuits",
            "Failure to communicate",
            "Unreasonable documentation demands"
        ],
        whatWeDo: [
            "Analyze your policy and claim history",
            "Document bad faith conduct",
            "Pursue contract damages plus bad faith penalties",
            "Seek emotional distress damages",
            "In egregious cases, pursue punitive damages",
            "Handle both first-party and third-party claims"
        ],
        faq: [
            FAQ(question: "What makes an insurance denial 'bad faith'?",
                answer: "Bad faith occurs when an insurer unreasonably denies or delays a valid claim, fails to properly investigate, misrepresents policy terms, or prioritizes their profits over your legitimate claim."),
            FAQ(question: "What damages can I recover in a bad faith case?",
                answer: "Beyond the original claim amount, you may recover consequential damages, emotional distress, attorney fees, and in cases of malicious conduct, punitive damages."),
            FAQ(question: "How long does an insurance company have to respond to my claim?",
                answer: "California law requires insurers to acknowledge claims within 15 days, begin investigation immediately, and accept or deny within 40 days of receiving proof of claim.")
        ]
    )

    static let lemonLaw = PracticeArea(
        id: "lemon-law",
        name: "Lemon Law",
        shortDescription: "Defective vehicles, buybacks",
        fullDescription: "California has some of the strongest lemon laws in the country. If your new or used vehicle has recurring problems that the dealer can't fix, you may be entitled to a refund, replacement, or cash compensation.",
        icon: "car.badge.gearshape.fill",
        category: .inHouse,
        commonCauses: [
            "Repeated repair attempts for same issue",
            "Vehicle in shop for extended periods",
            "Safety defects",
            "Engine or transmission problems",
            "Electrical system failures",
            "Problems starting within warranty period"
        ],
        whatWeDo: [
            "Evaluate if your vehicle qualifies as a 'lemon'",
            "Handle all manufacturer communications",
            "Negotiate buyback or replacement",
            "Manufacturer pays our attorney fees",
            "No out-of-pocket cost to you",
            "Handle both new and used vehicle claims"
        ],
        faq: [
            FAQ(question: "What qualifies as a 'lemon' in California?",
                answer: "Generally, if your vehicle has a substantial defect covered by warranty that the dealer can't fix after a reasonable number of attempts (usually 2+ for safety issues, 4+ for other defects), it may qualify."),
            FAQ(question: "Does Lemon Law apply to used cars?",
                answer: "Yes! California's Lemon Law covers used vehicles if they were sold with a manufacturer's new car warranty still in effect or a dealer warranty."),
            FAQ(question: "Will I have to pay attorney fees?",
                answer: "No. Under California law, the manufacturer must pay your attorney fees if you win your case. There's no cost to you."),
            FAQ(question: "Can I still pursue a claim if I've already had many repairs?",
                answer: "Absolutely. In fact, extensive repair history often strengthens your case. The statute of limitations is 4 years from when you first noticed the defect.")
        ]
    )

    // MARK: - Referral Practice Areas
    static let familyLaw = PracticeArea(
        id: "family-law",
        name: "Family Law",
        shortDescription: "Divorce, custody, support—we connect you with experienced family law attorneys.",
        fullDescription: "Family law matters are deeply personal and require specialized expertise. We partner with experienced family law attorneys throughout California who handle divorce, child custody, support, and related matters with compassion and skill.",
        icon: "figure.2.and.child.holdinghands",
        category: .referral,
        commonCauses: [
            "Divorce and legal separation",
            "Child custody and visitation",
            "Child support modifications",
            "Spousal support (alimony)",
            "Property division",
            "Domestic violence restraining orders",
            "Paternity matters",
            "Prenuptial agreements"
        ],
        whatWeDo: [
            "Connect you with vetted family law specialists",
            "Match based on your specific situation",
            "Ensure attorneys in your area",
            "Provide warm introductions",
            "Follow up to ensure quality service"
        ],
        faq: [
            FAQ(question: "Why don't you handle family law directly?",
                answer: "Family law is a specialized field requiring specific expertise. Rather than provide less-than-optimal service, we connect you with attorneys who focus exclusively on these matters."),
            FAQ(question: "How do you choose which attorney to refer me to?",
                answer: "We consider your location, specific needs, case complexity, and the attorney's track record and specialization to find the best match."),
            FAQ(question: "Is there a fee for the referral?",
                answer: "There's no fee to you for the referral. Your initial consultation with the referred attorney may be free or low-cost depending on their practice.")
        ]
    )

    static let criminalDefense = PracticeArea(
        id: "criminal-defense",
        name: "Criminal Defense",
        shortDescription: "Facing charges? Get connected with skilled criminal defense attorneys.",
        fullDescription: "Criminal charges can change your life. You need an experienced defense attorney who knows the local courts and prosecutors. We connect you with skilled criminal defense lawyers throughout California.",
        icon: "building.columns.fill",
        category: .referral,
        commonCauses: [
            "DUI / DWI charges",
            "Drug offenses",
            "Theft and property crimes",
            "Assault and battery",
            "Domestic violence accusations",
            "White collar crimes",
            "Felony charges",
            "Misdemeanor defense"
        ],
        whatWeDo: [
            "Urgent referrals for those in custody",
            "Match with specialists for your charge type",
            "Connect with attorneys familiar with your local court",
            "Provide referrals 24/7 for emergencies"
        ],
        faq: [
            FAQ(question: "I just got arrested. What should I do?",
                answer: "Exercise your right to remain silent and ask for an attorney. Don't discuss your case with anyone except your lawyer. Contact us immediately for an urgent referral."),
            FAQ(question: "How quickly can I get connected with an attorney?",
                answer: "For urgent matters, we can often provide a referral within hours. We understand that criminal matters require immediate attention.")
        ]
    )

    static let estatePlanning = PracticeArea(
        id: "estate-planning",
        name: "Estate Planning",
        shortDescription: "Protect your family's future with proper estate planning.",
        fullDescription: "Wills, trusts, powers of attorney—estate planning ensures your wishes are honored and your loved ones are protected. We connect you with experienced estate planning attorneys.",
        icon: "doc.text.fill",
        category: .referral,
        commonCauses: [
            "Wills and living trusts",
            "Powers of attorney",
            "Healthcare directives",
            "Probate matters",
            "Trust administration",
            "Estate tax planning",
            "Guardianship designations",
            "Business succession"
        ],
        whatWeDo: [
            "Connect with estate planning specialists",
            "Match based on estate complexity",
            "Referrals for probate matters",
            "Help with trust administration questions"
        ],
        faq: [
            FAQ(question: "Do I need an estate plan if I don't have much?",
                answer: "Yes. Estate planning isn't just for the wealthy. It ensures your wishes are followed, avoids probate hassles for your family, and designates who makes decisions if you're incapacitated."),
            FAQ(question: "What's the difference between a will and a trust?",
                answer: "A will goes through probate court, which is public and can take months. A trust avoids probate, provides privacy, and allows for more complex planning. Many people benefit from both.")
        ]
    )

    static let employmentLaw = PracticeArea(
        id: "employment-law",
        name: "Employment Law",
        shortDescription: "Wrongful termination, discrimination, wage theft—know your rights.",
        fullDescription: "California has strong employee protections. If you've experienced workplace discrimination, harassment, wrongful termination, or wage violations, we connect you with employment law specialists.",
        icon: "briefcase.fill",
        category: .referral,
        commonCauses: [
            "Wrongful termination",
            "Discrimination (age, race, gender, disability)",
            "Sexual harassment",
            "Wage and hour violations",
            "Unpaid overtime",
            "Meal and rest break violations",
            "Retaliation claims",
            "Whistleblower protection"
        ],
        whatWeDo: [
            "Connect with employment law specialists",
            "Referrals for both employee and employer matters",
            "Urgent referrals for termination situations"
        ],
        faq: [
            FAQ(question: "I was just fired. Do I have a case?",
                answer: "California is an 'at-will' employment state, but there are many exceptions. If you were fired for discriminatory reasons, retaliation, or in violation of public policy, you may have a claim."),
            FAQ(question: "What if my employer isn't paying me correctly?",
                answer: "California has strict wage and hour laws. Violations can result in significant penalties. Many employment attorneys take these cases on contingency.")
        ]
    )

    static let immigration = PracticeArea(
        id: "immigration",
        name: "Immigration Law",
        shortDescription: "Navigating the immigration system requires experienced guidance.",
        fullDescription: "Immigration law is complex and constantly changing. Whether you're seeking a visa, green card, citizenship, or facing removal proceedings, we connect you with knowledgeable immigration attorneys.",
        icon: "globe.americas.fill",
        category: .referral,
        commonCauses: [
            "Family-based immigration",
            "Employment visas",
            "Green card applications",
            "Naturalization/citizenship",
            "DACA renewals",
            "Asylum claims",
            "Deportation defense",
            "Visa extensions and changes"
        ],
        whatWeDo: [
            "Connect with immigration specialists",
            "Referrals for various visa types",
            "Urgent referrals for removal proceedings",
            "Spanish-speaking attorney options"
        ],
        faq: [
            FAQ(question: "How long does the immigration process take?",
                answer: "It varies widely depending on the visa category, your country of origin, and current backlogs. An immigration attorney can give you realistic timelines for your situation."),
            FAQ(question: "Can I work while my application is pending?",
                answer: "It depends on your current status and what you've applied for. Some categories allow work authorization while pending, others don't.")
        ]
    )

    static let bankruptcy = PracticeArea(
        id: "bankruptcy",
        name: "Bankruptcy",
        shortDescription: "Overwhelmed by debt? Understand your options for a fresh start.",
        fullDescription: "Bankruptcy can provide a fresh start when debt becomes unmanageable. We connect you with experienced bankruptcy attorneys who can explain your options and guide you through the process.",
        icon: "chart.line.downtrend.xyaxis",
        category: .referral,
        commonCauses: [
            "Overwhelming credit card debt",
            "Medical bills",
            "Foreclosure prevention",
            "Wage garnishment",
            "Lawsuit judgments",
            "Business debt",
            "Tax debt issues"
        ],
        whatWeDo: [
            "Connect with bankruptcy specialists",
            "Chapter 7 and Chapter 13 expertise",
            "Business bankruptcy referrals"
        ],
        faq: [
            FAQ(question: "Will bankruptcy ruin my credit forever?",
                answer: "No. While bankruptcy does impact credit, many people begin rebuilding immediately. Chapter 7 stays on your report for 10 years, Chapter 13 for 7 years, but the impact lessens over time."),
            FAQ(question: "Will I lose everything?",
                answer: "No. California has generous exemptions that protect most people's homes, cars, retirement accounts, and personal property. Many people keep everything they own.")
        ]
    )

    static let businessLaw = PracticeArea(
        id: "business-law",
        name: "Business Law",
        shortDescription: "Business disputes, contracts, formation—get proper legal guidance.",
        fullDescription: "From startup formation to complex business disputes, having the right business attorney matters. We connect you with attorneys who understand California business law.",
        icon: "building.fill",
        category: .referral,
        commonCauses: [
            "Business formation (LLC, Corp)",
            "Contract disputes",
            "Partnership disputes",
            "Business litigation",
            "Commercial lease issues",
            "Intellectual property",
            "Business purchases/sales",
            "Regulatory compliance"
        ],
        whatWeDo: [
            "Connect with business law specialists",
            "Match based on industry and issue",
            "Transactional and litigation referrals"
        ],
        faq: [
            FAQ(question: "Do I really need a lawyer to form my business?",
                answer: "While you can form an LLC or corporation yourself, an attorney ensures you choose the right structure, protect yourself from liability, and set up proper operating agreements."),
            FAQ(question: "Someone breached our contract. What now?",
                answer: "Document everything and contact an attorney before taking action. There may be notice requirements or dispute resolution procedures in your contract to follow first.")
        ]
    )

    static let realEstateLaw = PracticeArea(
        id: "real-estate-law",
        name: "Real Estate Law",
        shortDescription: "Property disputes, transactions, landlord-tenant issues.",
        fullDescription: "Real estate matters involve significant assets and complex laws. Whether you're dealing with a property dispute, transaction issue, or landlord-tenant matter, proper legal guidance is essential.",
        icon: "house.and.flag.fill",
        category: .referral,
        commonCauses: [
            "Property purchase/sale disputes",
            "Landlord-tenant disputes",
            "Evictions",
            "Title issues",
            "Boundary disputes",
            "HOA disputes",
            "Real estate fraud",
            "Construction defects"
        ],
        whatWeDo: [
            "Connect with real estate specialists",
            "Both residential and commercial expertise",
            "Landlord and tenant representation"
        ],
        faq: [
            FAQ(question: "My landlord won't return my security deposit. What can I do?",
                answer: "California has strict rules about security deposits. Landlords must return deposits within 21 days with an itemized statement. You may be entitled to the deposit plus penalties."),
            FAQ(question: "I'm facing eviction. What are my rights?",
                answer: "California has strong tenant protections. You have the right to proper notice, time to respond, and your day in court. Don't ignore eviction notices—seek legal help immediately.")
        ]
    )

    static let medicalMalpractice = PracticeArea(
        id: "medical-malpractice",
        name: "Medical Malpractice",
        shortDescription: "Harmed by medical negligence? These cases require specialized expertise.",
        fullDescription: "Medical malpractice cases are complex and require attorneys with specific expertise and resources to take on healthcare providers. We connect you with experienced medical malpractice attorneys.",
        icon: "cross.case.fill",
        category: .referral,
        commonCauses: [
            "Surgical errors",
            "Misdiagnosis or delayed diagnosis",
            "Medication errors",
            "Birth injuries",
            "Anesthesia errors",
            "Hospital negligence",
            "Emergency room errors",
            "Failure to treat"
        ],
        whatWeDo: [
            "Connect with medical malpractice specialists",
            "Attorneys with medical expert networks",
            "Firms with resources for complex cases"
        ],
        faq: [
            FAQ(question: "Why do medical malpractice cases need specialists?",
                answer: "These cases require expensive medical experts, deep knowledge of medical standards, and resources to take on hospitals and insurance companies. Not every attorney has these capabilities."),
            FAQ(question: "How long do I have to file a medical malpractice claim?",
                answer: "California's statute of limitations is generally 3 years from injury or 1 year from discovery, whichever comes first. However, there are exceptions. Consult an attorney promptly.")
        ]
    )

    static let workersComp = PracticeArea(
        id: "workers-comp",
        name: "Workers' Compensation",
        shortDescription: "Injured at work? Get the benefits and care you deserve.",
        fullDescription: "If you're injured on the job, you have rights under California's workers' compensation system. We connect you with attorneys who specialize in getting injured workers the benefits and treatment they deserve.",
        icon: "hammer.fill",
        category: .referral,
        commonCauses: [
            "Workplace accidents",
            "Repetitive stress injuries",
            "Occupational illness",
            "Back and spine injuries",
            "Denied claims",
            "Delayed treatment authorization",
            "Permanent disability",
            "Death benefits"
        ],
        whatWeDo: [
            "Connect with workers' comp specialists",
            "Attorneys experienced with your industry",
            "Help with denied claims"
        ],
        faq: [
            FAQ(question: "My employer says I can't get workers' comp. Is that true?",
                answer: "Almost all California employees are covered, regardless of immigration status, fault, or how the injury occurred. Your employer cannot legally prevent you from filing."),
            FAQ(question: "Will I get fired if I file a workers' comp claim?",
                answer: "It's illegal for employers to retaliate against employees for filing workers' comp claims. If they do, you may have additional legal claims against them.")
        ]
    )

    // MARK: - Collections
    static let inHouseAreas: [PracticeArea] = [
        .personalInjury,
        .premisesLiability,
        .propertyDamage,
        .insuranceBadFaith,
        .lemonLaw
    ]

    static let referralAreas: [PracticeArea] = [
        .familyLaw,
        .criminalDefense,
        .estatePlanning,
        .employmentLaw,
        .immigration,
        .bankruptcy,
        .businessLaw,
        .realEstateLaw,
        .medicalMalpractice,
        .workersComp
    ]

    static let allAreas: [PracticeArea] = inHouseAreas + referralAreas
}
