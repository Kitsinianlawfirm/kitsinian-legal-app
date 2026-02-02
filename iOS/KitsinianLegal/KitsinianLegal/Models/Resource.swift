//
//  Resource.swift
//  KitsinianLegal
//

import Foundation

// MARK: - Resource Model
struct LegalResource: Identifiable, Codable {
    let id: String
    let title: String
    let summary: String
    let content: String
    let category: Category
    let practiceAreas: [String]
    let icon: String
    let readTime: Int  // minutes
    let isFeatured: Bool

    enum Category: String, Codable, CaseIterable {
        case guide = "guide"
        case checklist = "checklist"
        case faq = "faq"
        case rights = "rights"
        case timeline = "timeline"

        var displayName: String {
            switch self {
            case .guide: return "Guides"
            case .checklist: return "Checklists"
            case .faq: return "FAQs"
            case .rights: return "Know Your Rights"
            case .timeline: return "Timelines"
            }
        }

        var icon: String {
            switch self {
            case .guide: return "book.fill"
            case .checklist: return "checklist"
            case .faq: return "questionmark.circle.fill"
            case .rights: return "hand.raised.fill"
            case .timeline: return "clock.fill"
            }
        }
    }
}

// MARK: - Resource Library
extension LegalResource {

    // MARK: - Personal Injury Resources
    static let afterCarAccident = LegalResource(
        id: "after-car-accident",
        title: "What to Do After a Car Accident in California",
        summary: "Step-by-step guide for protecting your rights after a car accident",
        content: """
        # What to Do After a Car Accident in California

        Being in a car accident is stressful and overwhelming. Knowing what to do can protect your health, your rights, and your potential claim.

        ## At the Scene

        ### 1. Check for Injuries
        - Check yourself and passengers for injuries
        - Call 911 if anyone is hurt
        - Don't move seriously injured people unless there's immediate danger

        ### 2. Move to Safety
        - If possible, move vehicles out of traffic
        - Turn on hazard lights
        - Set up flares or triangles if you have them

        ### 3. Call the Police
        - Always get a police report, even for minor accidents
        - The report documents the scene and may assign fault
        - Get the report number before officers leave

        ### 4. Exchange Information
        Collect from all drivers:
        - Name, address, phone number
        - Driver's license number
        - Insurance company and policy number
        - License plate number
        - Vehicle make, model, color

        ### 5. Document Everything
        - Take photos of all vehicles, damage, and the scene
        - Photograph skid marks, traffic signs, road conditions
        - Get contact info for witnesses
        - Note the time, date, weather, and lighting

        ### 6. Don't Admit Fault
        - Be polite but don't say "I'm sorry" or "It was my fault"
        - Stick to facts when talking to police
        - Let investigators determine fault

        ## After Leaving the Scene

        ### 7. Seek Medical Attention
        - See a doctor within 24-48 hours, even if you feel fine
        - Some injuries don't show symptoms immediately
        - Medical records link your injuries to the accident

        ### 8. Notify Your Insurance
        - Report the accident promptly
        - Stick to facts; don't speculate about fault
        - Don't give recorded statements without legal advice

        ### 9. Keep Records
        - Save all medical bills and records
        - Document lost work time
        - Keep a journal of pain levels and limitations
        - Save receipts for all accident-related expenses

        ### 10. Consult an Attorney
        - Before accepting any settlement offer
        - If injuries are significant
        - If fault is disputed
        - If the other driver was uninsured

        ## Important Deadlines

        - **Police Report**: Get a copy within a few weeks
        - **Insurance Claim**: File promptly per your policy
        - **Lawsuit Deadline**: 2 years from accident date in California

        ## Common Mistakes to Avoid

        ❌ Posting about the accident on social media
        ❌ Accepting the first settlement offer
        ❌ Not getting medical treatment
        ❌ Giving recorded statements without an attorney
        ❌ Waiting too long to take action
        """,
        category: .guide,
        practiceAreas: ["personal-injury"],
        icon: "car.fill",
        readTime: 8,
        isFeatured: true
    )

    static let personalInjuryChecklist = LegalResource(
        id: "pi-checklist",
        title: "Personal Injury Claim Checklist",
        summary: "Everything you need to document for your personal injury case",
        content: """
        # Personal Injury Claim Checklist

        Use this checklist to gather everything you need for your claim.

        ## Immediate Documentation

        - [ ] Photos of your injuries (take new ones as they heal/worsen)
        - [ ] Photos of the accident scene
        - [ ] Photos of property damage
        - [ ] Witness names and contact information
        - [ ] Police report number
        - [ ] Other party's insurance information

        ## Medical Records

        - [ ] Emergency room records
        - [ ] Doctor visit notes
        - [ ] Hospital admission records
        - [ ] Physical therapy records
        - [ ] Prescription records
        - [ ] Medical imaging (X-rays, MRIs, CT scans)
        - [ ] Doctor's notes on restrictions
        - [ ] Future treatment recommendations

        ## Financial Documentation

        - [ ] All medical bills
        - [ ] Pharmacy receipts
        - [ ] Medical equipment costs
        - [ ] Transportation to medical appointments
        - [ ] Pay stubs (before and after accident)
        - [ ] Employer letter confirming missed work
        - [ ] Lost income calculations
        - [ ] Receipts for any out-of-pocket expenses

        ## Insurance Information

        - [ ] Your auto insurance policy
        - [ ] Your health insurance policy
        - [ ] Other party's insurance information
        - [ ] All correspondence with insurance companies
        - [ ] Claim numbers

        ## Personal Journal

        Keep a daily journal documenting:
        - [ ] Pain levels (1-10 scale)
        - [ ] Activities you can't do
        - [ ] Sleep disturbances
        - [ ] Emotional impacts
        - [ ] Medications taken
        - [ ] Doctor appointments

        ## Legal Deadlines

        - [ ] Statute of limitations (2 years for most CA injuries)
        - [ ] Insurance policy deadlines
        - [ ] Government claim deadlines (6 months if government entity involved)
        """,
        category: .checklist,
        practiceAreas: ["personal-injury", "premises-liability"],
        icon: "checklist",
        readTime: 5,
        isFeatured: true
    )

    static let slipFallGuide = LegalResource(
        id: "slip-fall-guide",
        title: "Slip and Fall Accidents: Proving Your Case",
        summary: "What you need to know about premises liability claims in California",
        content: """
        # Slip and Fall Accidents: Proving Your Case

        Slip and fall cases can be challenging but are often valid claims when property owners fail to maintain safe conditions.

        ## What is Premises Liability?

        Property owners have a legal duty to maintain reasonably safe conditions. When they fail and you're injured, they can be held responsible.

        ## What You Must Prove

        ### 1. Dangerous Condition Existed
        - Wet or slippery floor
        - Torn carpet or uneven flooring
        - Poor lighting
        - Broken stairs or handrails
        - Ice or snow accumulation
        - Spilled liquids or debris

        ### 2. Owner Knew or Should Have Known
        The property owner must have:
        - Created the dangerous condition, OR
        - Known about it and failed to fix it, OR
        - Should have discovered it through reasonable inspection

        ### 3. Owner Failed to Take Reasonable Action
        - Failed to repair the hazard
        - Failed to warn visitors
        - Failed to block off dangerous areas

        ### 4. You Were Injured as a Result
        - Medical records showing injuries
        - Connection between fall and injuries

        ## Key Evidence to Preserve

        ### Immediately After the Fall
        - Report the incident to management
        - Ask for a copy of the incident report
        - Take photos of:
          - What caused you to fall
          - Your injuries
          - Your shoes (to show they were appropriate)
          - The surrounding area
        - Get witness names and contact info

        ### Building Your Case
        - Keep the shoes and clothing you were wearing
        - Note the date, time, and conditions
        - Request surveillance footage (in writing, ASAP)
        - Document all medical treatment

        ## Common Defense Arguments

        **"You weren't paying attention"**
        Response: Property owners can't expect visitors to constantly look at the floor

        **"Your shoes caused the fall"**
        Response: Document that you were wearing reasonable footwear

        **"The hazard was obvious"**
        Response: Obvious hazards must still be addressed or warned about

        ## California's Comparative Negligence

        Even if you share some fault, you can still recover. Your recovery is reduced by your percentage of fault.

        Example: If you're 20% at fault and damages are $100,000, you can still recover $80,000.

        ## Time Limits

        - **Private property**: 2 years from date of injury
        - **Government property**: File a claim within 6 months

        ## When to Get Legal Help

        - Injuries require medical treatment
        - You missed work
        - The property owner denies responsibility
        - Insurance offers a low settlement
        - You're unsure if you have a case
        """,
        category: .guide,
        practiceAreas: ["premises-liability"],
        icon: "figure.fall",
        readTime: 10,
        isFeatured: false
    )

    static let californiaLemonLaw = LegalResource(
        id: "california-lemon-law",
        title: "California Lemon Law: Complete Guide",
        summary: "Everything you need to know about California's Lemon Law protections",
        content: """
        # California Lemon Law: Complete Guide

        California has some of the strongest lemon laws in the country. If you're stuck with a defective vehicle, you have rights.

        ## What Qualifies as a "Lemon"?

        Your vehicle may qualify if:

        ### Repair Attempts
        - **2 or more attempts** to fix a safety defect, OR
        - **4 or more attempts** to fix any substantial defect, OR
        - Vehicle has been **in the shop 30+ days** total

        ### Defect Requirements
        The defect must:
        - Substantially impair the vehicle's use, value, or safety
        - Be covered by the manufacturer's warranty
        - Have first occurred during the warranty period

        ## What Vehicles Are Covered?

        ✅ New cars, trucks, and SUVs
        ✅ Used vehicles still under manufacturer's warranty
        ✅ Leased vehicles
        ✅ Demonstrator vehicles
        ✅ Some motorcycles and RVs

        ## What Can You Get?

        ### Refund ("Buyback")
        - Full purchase price (minus mileage offset)
        - Down payment
        - Monthly payments made
        - Registration and taxes
        - Incidental costs (towing, rentals)

        ### Replacement
        - A new vehicle of the same make and model
        - Must be acceptable to you

        ### Cash Settlement
        - Negotiated amount to keep your vehicle
        - Common when the issue is minor

        ## The Process

        ### Step 1: Document Everything
        - Keep all repair orders
        - Note dates and mileage at each repair
        - Document ongoing problems between repairs

        ### Step 2: Give Manufacturer a Final Chance
        - Request repair through manufacturer (not just dealer)
        - Keep proof of this request

        ### Step 3: File Your Claim
        - You can handle this yourself OR
        - Hire an attorney (manufacturer pays legal fees if you win)

        ## Important Points

        ### Manufacturer Pays Your Attorney
        Under California law, if you win, the manufacturer pays your attorney fees. This means:
        - No out-of-pocket cost to you
        - Attorneys are incentivized to take your case
        - No risk in pursuing your claim

        ### The "Mileage Offset"
        For buybacks, manufacturers can deduct for miles driven before the first repair attempt. The formula:

        (Purchase Price × Miles Driven) ÷ 120,000 = Mileage Offset

        ### Time Limits
        - Generally **4 years** from when you first noticed the defect
        - Don't wait—pursue claims while vehicle is still under warranty

        ## Common Questions

        **Q: What if the dealer says the problem is "normal"?**
        A: Get a second opinion. If multiple vehicles have the same issue, there may still be a design defect claim.

        **Q: Can I still pursue a claim if I didn't go to the dealership every time?**
        A: Gaps in repair history can weaken your case, but you may still have options.

        **Q: What if the car was used when I bought it?**
        A: If it still had manufacturer's warranty, the Lemon Law applies.

        ## Document Checklist

        - [ ] Purchase contract
        - [ ] All repair orders and invoices
        - [ ] Warranty documentation
        - [ ] Written complaints to dealer/manufacturer
        - [ ] Records of days without the vehicle
        - [ ] Rental car receipts
        - [ ] Towing receipts
        """,
        category: .guide,
        practiceAreas: ["lemon-law"],
        icon: "car.fill",
        readTime: 12,
        isFeatured: true
    )

    static let insuranceClaimRights = LegalResource(
        id: "insurance-claim-rights",
        title: "Your Rights When Dealing with Insurance Companies",
        summary: "Know what insurers must do—and what they can't get away with",
        content: """
        # Your Rights When Dealing with Insurance Companies

        Insurance companies are businesses focused on profits. Know your rights to level the playing field.

        ## California Insurance Deadlines

        Insurers MUST follow these timelines:

        | Action | Deadline |
        |--------|----------|
        | Acknowledge your claim | 15 days |
        | Begin investigation | Immediately |
        | Accept or deny claim | 40 days after proof submitted |
        | Pay undisputed amounts | 30 days after settlement |

        ## Your Rights

        ### Right to Fair Investigation
        - Insurers must thoroughly investigate claims
        - Can't deny based on speculation
        - Must consider all evidence you provide

        ### Right to Clear Communication
        - Must explain coverage decisions in writing
        - Must identify specific policy provisions
        - Must respond to your communications promptly

        ### Right to Fair Evaluation
        - Must offer fair value, not lowball amounts
        - Can't require unreasonable documentation
        - Must consider comparable values for property

        ### Right to Appeal
        - Can dispute denials or low offers
        - Can request supervisor review
        - Can file complaint with Department of Insurance

        ## Signs of Bad Faith

        Your insurer may be acting in bad faith if they:

        🚩 Deny claim without explanation
        🚩 Unreasonably delay processing
        🚩 Offer far less than claim is worth
        🚩 Misrepresent policy terms
        🚩 Fail to conduct proper investigation
        🚩 Refuse to communicate
        🚩 Demand excessive documentation
        🚩 Use threatening or intimidating tactics

        ## What to Do If Mistreated

        ### 1. Document Everything
        - Save all written communications
        - Note dates and times of calls
        - Keep a log of what was said

        ### 2. Communicate in Writing
        - Follow up phone calls with written confirmation
        - Send important requests by certified mail
        - Create a paper trail

        ### 3. Know Your Policy
        - Review coverage limits
        - Understand exclusions
        - Note deadlines for filing

        ### 4. File a Complaint
        - California Department of Insurance
        - www.insurance.ca.gov
        - 1-800-927-4357

        ### 5. Consider Legal Action
        Bad faith claims can recover:
        - Original claim amount
        - Consequential damages
        - Emotional distress
        - Attorney fees
        - Punitive damages (in egregious cases)

        ## Tips for Dealing with Adjusters

        ✅ Be polite but firm
        ✅ Don't accept first offers automatically
        ✅ Get everything in writing
        ✅ Don't sign anything without reading carefully
        ✅ Don't give recorded statements without advice
        ✅ Don't feel pressured to settle quickly

        ## The Recorded Statement Trap

        Insurers often want recorded statements. Be careful:
        - You're not always required to give one
        - Anything you say can be used against you
        - Consider having an attorney present
        - If you do give one, prepare carefully
        """,
        category: .rights,
        practiceAreas: ["insurance-bad-faith", "personal-injury", "property-damage"],
        icon: "shield.fill",
        readTime: 8,
        isFeatured: true
    )

    static let statuteOfLimitations = LegalResource(
        id: "statute-of-limitations",
        title: "California Legal Deadlines: Don't Miss Your Window",
        summary: "Critical time limits for filing legal claims in California",
        content: """
        # California Legal Deadlines

        Missing a deadline can mean losing your right to legal action. Know these critical timeframes.

        ## Personal Injury Claims

        | Claim Type | Deadline |
        |------------|----------|
        | Personal injury (general) | **2 years** from injury |
        | Medical malpractice | **3 years** from injury OR **1 year** from discovery |
        | Against government entity | **6 months** to file claim |
        | Minors | Until **2 years** after turning 18 |

        ## Property Damage

        | Claim Type | Deadline |
        |------------|----------|
        | Property damage from accident | **3 years** |
        | Property damage from government | **6 months** claim + 2 years lawsuit |

        ## Contract and Business

        | Claim Type | Deadline |
        |------------|----------|
        | Written contracts | **4 years** |
        | Oral contracts | **2 years** |
        | Fraud | **3 years** from discovery |

        ## Employment

        | Claim Type | Deadline |
        |------------|----------|
        | Discrimination (DFEH) | **3 years** to file complaint |
        | Wage claims | **3-4 years** depending on type |
        | Wrongful termination | **2-3 years** depending on basis |

        ## Important Exceptions

        ### Discovery Rule
        For some claims, the clock starts when you discover (or should have discovered) the harm—not when it occurred.

        ### Tolling
        The deadline may be "paused" if:
        - You were a minor
        - You were mentally incapacitated
        - The defendant was out of state
        - The defendant concealed wrongdoing

        ### Government Claims
        Claims against government entities (cities, counties, state) require:
        1. Filing administrative claim within **6 months**
        2. Waiting for response (45 days)
        3. Then filing lawsuit

        ## Don't Wait

        Even if you think you have time:
        - Evidence disappears
        - Witnesses forget
        - Records get lost
        - Cases are stronger when fresh

        **When in doubt, consult an attorney immediately.**
        """,
        category: .timeline,
        practiceAreas: ["personal-injury", "premises-liability", "property-damage", "insurance-bad-faith"],
        icon: "clock.fill",
        readTime: 6,
        isFeatured: false
    )

    static let diminishedValue = LegalResource(
        id: "diminished-value",
        title: "Diminished Value Claims in California",
        summary: "Your car is worth less after an accident—here's how to recover that loss",
        content: """
        # Diminished Value Claims in California

        Even after perfect repairs, an accident history reduces your vehicle's value. You may be entitled to compensation.

        ## What is Diminished Value?

        When a car is in an accident, its market value drops—even after repairs. This is because:
        - Buyers are wary of accident history
        - CarFax and similar reports show the accident
        - Structural integrity may be questioned
        - Resale value is reduced

        ## Types of Diminished Value

        ### Inherent Diminished Value
        The automatic loss in value because the car was in an accident, regardless of repair quality. This is the most common claim.

        ### Repair-Related Diminished Value
        Additional loss due to repairs that don't fully restore the vehicle.

        ### Immediate Diminished Value
        The difference between pre-accident value and post-accident value before repairs.

        ## Can You Claim Diminished Value in California?

        Yes, but with important distinctions:

        ✅ **Third-party claims**: You can claim against the at-fault driver's insurance

        ⚠️ **First-party claims**: California law doesn't require your own insurance to pay diminished value (though some policies may)

        ## How to Calculate Diminished Value

        ### Method 1: Comparable Sales
        - Find similar vehicles with and without accident history
        - Compare selling prices
        - The difference is your diminished value

        ### Method 2: Percentage of Repair Cost
        - Typically 10-25% of repair costs
        - Higher for newer/luxury vehicles
        - Lower for older/high-mileage vehicles

        ### Method 3: Professional Appraisal
        - Hire a certified auto appraiser
        - Get a written report
        - Most reliable for substantial claims

        ## Factors Affecting Diminished Value

        **Increases value of claim:**
        - Newer vehicle
        - Lower mileage
        - Luxury or collectible vehicle
        - Structural damage
        - Multiple repair attempts

        **Decreases value of claim:**
        - Older vehicle
        - High mileage
        - Prior accidents
        - Minor damage

        ## How to Pursue Your Claim

        ### Step 1: Wait for Repairs
        - Get vehicle fully repaired
        - Keep all repair documentation
        - Request detailed repair invoices

        ### Step 2: Get an Appraisal
        - Hire a diminished value appraiser
        - Cost typically $75-300
        - Get a written report

        ### Step 3: Submit Your Claim
        - Send demand to at-fault driver's insurance
        - Include appraisal report
        - Include repair documentation
        - Include photos

        ### Step 4: Negotiate
        - Insurance will likely counter low
        - Be prepared to justify your numbers
        - Consider small claims court for disputes

        ## Sample Demand Letter Points

        Your demand should include:
        - Description of accident
        - Repairs performed
        - Pre-accident value of vehicle
        - Diminished value calculation
        - Supporting documentation
        - Settlement demand
        """,
        category: .guide,
        practiceAreas: ["property-damage"],
        icon: "chart.line.downtrend.xyaxis",
        readTime: 8,
        isFeatured: false
    )

    // MARK: - Collections
    static let allResources: [LegalResource] = [
        afterCarAccident,
        personalInjuryChecklist,
        slipFallGuide,
        californiaLemonLaw,
        insuranceClaimRights,
        statuteOfLimitations,
        diminishedValue
    ]

    static var featuredResources: [LegalResource] {
        allResources.filter { $0.isFeatured }
    }

    static func resources(for practiceAreaId: String) -> [LegalResource] {
        allResources.filter { $0.practiceAreas.contains(practiceAreaId) }
    }

    static func resources(in category: Category) -> [LegalResource] {
        allResources.filter { $0.category == category }
    }
}
