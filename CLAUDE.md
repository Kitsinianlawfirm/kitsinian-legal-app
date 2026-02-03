# ClaimIt - Legal Client Acquisition App

## Project Overview

**Client:** Kitsinian Law Firm, APC
**App Name:** ClaimIt
**Platform:** iOS (SwiftUI) + HTML Preview
**Purpose:** Ethical client acquisition and referral network routing for legal services in California

### Business Model
- All leads route to Kitsinian Law Firm
- Firm decides which cases to handle in-house vs. refer out
- No specific attorney branding - app is consumer-facing and general
- Focus: Southern California, statewide California coverage

---

## Project Structure

```
/kitsinian-legal-app/
├── CLAUDE.md                    # This knowledge base
├── README.md                    # Basic project readme
├── iOS/                         # iOS SwiftUI application
│   └── KitsinianLegal/
│       └── KitsinianLegal/
│           ├── App/             # App entry, theme, navigation
│           ├── Models/          # Data models
│           ├── Views/           # SwiftUI views
│           ├── Services/        # API communication
│           └── Assets.xcassets/ # Colors, icons, images
├── backend/                     # Node.js/Express API
│   ├── package.json
│   ├── render.yaml              # Render deployment config
│   └── src/
│       ├── index.js             # Express server entry
│       ├── routes/              # API routes
│       ├── controllers/         # Business logic
│       ├── services/            # Email, external services
│       ├── config/              # Database config
│       └── utils/               # Logger, migrations
└── preview/                     # HTML design mockups
    ├── index.html               # CURRENT - Full interactive preview
    ├── claimit-full.html        # Previous version with articles
    ├── claimit-interactive.html # Earlier interactive version
    ├── claimit.html             # ClaimIt rebrand, static
    ├── old-kitsinian-index.html # Original law firm branded
    └── accident-mode-concept.html # Future phase 2 concept
```

---

## Practice Areas

### In-House (Primary) - Handled Directly
| Practice Area | ID | Icon | Description |
|--------------|-----|------|-------------|
| Personal Injury | `personal-injury` | `bandage.fill` | Car accidents, dog bites, assault |
| Premises Liability | `premises-liability` | `building.2.fill` | Slip/fall, inadequate security |
| Property Damage | `property-damage` | `car.fill` | Vehicle damage, total loss claims |
| Insurance Bad Faith | `insurance-bad-faith` | `shield.slash.fill` | Denied claims, delays, lowballs |
| Lemon Law | `lemon-law` | `exclamationmark.triangle.fill` | Defective vehicle buybacks |

### Referral Network - Partner Attorneys
| Practice Area | ID | Icon |
|--------------|-----|------|
| Family Law | `family-law` | `figure.2.and.child.holdinghands` |
| Criminal Defense | `criminal-defense` | `building.columns.fill` |
| Estate Planning | `estate-planning` | `doc.text.fill` |
| Employment Law | `employment-law` | `briefcase.fill` |
| Immigration | `immigration` | `globe.americas.fill` |
| Bankruptcy | `bankruptcy` | `chart.line.downtrend.xyaxis` |
| Business Law | `business-law` | `building.fill` |
| Real Estate Law | `real-estate-law` | `house.and.flag.fill` |
| Medical Malpractice | `medical-malpractice` | `cross.case.fill` |
| Workers' Compensation | `workers-comp` | `hammer.fill` |

---

## HTML Preview (`/preview/index.html`)

### Overview
- ~7000+ lines comprehensive interactive prototype
- iPhone and iPad device frames
- Full responsive design system
- JavaScript-driven navigation and quiz flow

### Screens

| Screen | ID | Purpose |
|--------|-----|---------|
| Home | `screen-home` | Hero, quick actions, practice areas |
| Claim | `screen-claim` | Quiz flow for case evaluation |
| Learn | `screen-learn` | Resource library and articles |
| Account | `screen-account` | User profile, case tracking |
| Onboarding | `onboarding` | 2-screen welcome flow |

### Navigation Flow

```
App Launch
    └── Onboarding (if first time)
        ├── Screen 1: Welcome, trust badges, value props
        └── Screen 2: Incident type selection → Claim tab
    └── Tab Navigation (4 tabs)
        ├── Home → Practice area detail screens
        ├── Claim → Quiz flow (5 steps)
        ├── Learn → Article detail screens
        └── Account → My Cases, sign in/out

Detail Screens (slide from right):
├── article-car-accident
├── article-checklist
├── article-lemon-law
├── article-slip-fall
├── article-insurance
├── article-deadlines
├── article-pa-personal-injury
├── article-pa-premises-liability
├── article-pa-property-damage
├── article-pa-insurance-bad-faith
└── article-pa-lemon-law
```

### Quiz Flow Logic

**5-Step Adaptive Quiz:**

```
Step 1: Case Type Selection
├── car-accident → Step 2: Role (driver, passenger, pedestrian, rideshare, parked)
├── injury → Step 2: Cause (work, medical, product, dog bite, assault)
├── slip-fall → Step 2: Location (store, apartment, sidewalk, workplace)
├── insurance → Step 2: Issue (denied, delayed, lowball, cancelled)
├── lemon → Step 2: Problem (engine, electrical, safety, recurring)
├── property → Step 2: Type (vehicle, fire, water, theft)
└── other → Step 2: Legal help type

Step 2: Dynamic follow-up based on Step 1 selection
Step 3: Injury timeline (when did it happen)
Step 4: Contact form (name, phone, email, description)
Step 5: Success confirmation
```

**Branching Configuration (`step2Questions` object):**
- Each case type has custom questions and icons
- Options map to specific practice areas
- Referral areas also have custom Step 2 questions

### Form Validation Rules

```javascript
// Name: minimum 2 characters
validateInput(input, 'name'): value.length >= 2

// Phone: exactly 10 digits, auto-formats to (xxx) xxx-xxxx
validateInput(input, 'phone'): phoneDigits.length === 10

// Email: standard email regex
validateInput(input, 'email'): /^[^\s@]+@[^\s@]+\.[^\s@]+$/
```

### Case Status Flow

```
Submitted → Under Review → Qualified → Matched → Retained
    │            │             │           │          │
    └── 1 step ──┴── 2 steps ──┴── 3 steps ┴ 4 steps ─┴── 5 steps (complete)
```

Status badges: `.submitted`, `.under-review`, `.qualified`, `.matched`, `.retained`

### Legal Resources/Articles

| Article | ID | Category | Read Time |
|---------|-----|----------|-----------|
| After a Car Accident | `car-accident` | Guide | 10 min |
| Personal Injury Checklist | `checklist` | Checklist | 5 min |
| California Lemon Law | `lemon-law` | Guide | 12 min |
| Slip and Fall Guide | `slip-fall` | Guide | 10 min |
| Fight Insurance Bad Faith | `insurance` | Know Your Rights | 8 min |
| California Legal Deadlines | `deadlines` | Timeline | 6 min |
| Diminished Value Claims | `diminished-value` | Guide | 8 min |

### JavaScript Functions Reference

**Navigation:**
- `switchTab(tabName)` - Switch between main tabs
- `showArticle(articleId)` - Open detail/article screen
- `hideArticle()` - Close detail screen and return

**Quiz:**
- `goToStep(stepNum)` - Navigate to quiz step
- `selectCaseType(element, caseType)` - Handle Step 1 selection
- `selectAndAdvance(element, value, nextStep)` - Handle Step 2+ selections
- `submitLead()` - Submit contact form
- `resetQuiz()` - Clear quiz and restart
- `startQuizWithTopic(topic)` - Start quiz from article CTA

**Onboarding:**
- `nextOnboarding()` - Go from screen 1 to screen 2
- `selectOnboardingOption(element, value)` - Select incident type
- `startQuizFromOnboarding()` - Complete onboarding and start quiz
- `skipOnboarding()` - Skip directly to home

**Authentication:**
- `toggleSignIn()` - Show account or sign-in modal
- `showSignInModal()` / `hideSignInModal()` - Sign-in modal
- `signIn()` / `signOut()` - Auth actions
- `updateSignInButton()` - Update status bar button state
- `updateAccountUI()` - Refresh account screen
- `renderCases(container)` - Render user's case cards

**Modals:**
- `showPrivacyModal()` / `hidePrivacyModal()`
- `showTermsModal()` / `hideTermsModal()`
- `showLegalDisclaimer()` / `hideDisclaimerModal()`
- `showReferralInfo(areaName)` / `hideReferralModal()`
- `startReferralQuiz()` - Begin quiz for referral area

**UI Helpers:**
- `toggleFaq(element)` - Accordion for FAQ items
- `formatPhoneNumber(input)` - Auto-format phone
- `validateInput(input, type)` - Form validation
- `handleFileUpload(input)` / `removeFile(index, event)` - Doc uploads
- `showToast(message, type)` - In-app notifications
- `escapeHtml(text)` - XSS prevention

**Device Toggle:**
- `toggleDevice(device)` - Switch iPhone/iPad preview

---

## Design System

### Color Palette

```css
/* Primary Colors */
--primary: #0066FF;        /* Vibrant blue - main brand */
--primary-light: #4D94FF;  /* Lighter blue */
--primary-dark: #0047B3;   /* Darker blue for gradients */

/* Accent Colors */
--accent: #FF6B35;         /* Orange - CTAs, urgency */
--accent-light: #FF8F66;   /* Lighter orange */

/* Semantic Colors */
--success: #00C48C;        /* Green - confirmations, positive */
--success-light: #00E6A0;
--warning: #F59E0B;        /* Amber - caution */
--error: #EF4444;          /* Red - errors */
--gold: #F59E0B;           /* Gold - "It" in ClaimIt */
--brand-gold: #FFD700;     /* Bright gold for logo */
--purple: #8B5CF6;         /* Purple - Know Your Rights */
--purple-light: #A78BFA;

/* Background Colors */
--page-bg: #F8FAFC;        /* Light gray page background */
--card-bg: #FFFFFF;        /* White cards */
--bg-secondary: #F1F5F9;   /* Secondary background */
--bg-gradient-start: #0066FF;
--bg-gradient-end: #00D4FF;

/* Text Colors */
--text-primary: #111827;   /* Near black - headings */
--text-secondary: #4B5563; /* Dark gray - body text */
--text-muted: #9CA3AF;     /* Light gray - captions */

/* Border Colors */
--border-color: #E5E7EB;   /* Standard borders */
--border-light: #F3F4F6;   /* Subtle borders */

/* Status Badge Colors */
--status-submitted-bg: #E5E7EB;
--status-submitted-text: #4B5563;
--status-review-bg: #DBEAFE;
--status-review-text: #1D4ED8;
--status-qualified-bg: #D1FAE5;
--status-qualified-text: #059669;
--status-matched-bg: #FEF3C7;
--status-matched-text: #D97706;
--status-retained-bg: #D1FAE5;
--status-retained-text: #059669;
```

### Typography Scale

```css
--font-size-xs: 10px;    /* Disclaimers, badges */
--font-size-sm: 12px;    /* Labels, meta */
--font-size-base: 14px;  /* Body text */
--font-size-md: 16px;    /* Buttons, inputs */
--font-size-lg: 18px;    /* Section headers */
--font-size-xl: 20px;    /* Card titles */
--font-size-2xl: 24px;   /* Page titles */
--font-size-3xl: 28px;   /* Hero subtitles */
--font-size-4xl: 34px;   /* Hero titles */
--font-size-5xl: 42px;   /* Large hero (iPad) */

/* Font weights: 400 (regular), 500 (medium), 600 (semibold), 700 (bold), 800 (extrabold), 900 (black) */
```

### Spacing Scale

```css
--space-1: 4px;
--space-1-5: 6px;
--space-2: 8px;
--space-2-5: 10px;
--space-3: 12px;
--space-3-5: 14px;
--space-4: 16px;
--space-5: 20px;
--space-6: 24px;
--space-7: 32px;
--space-8: 40px;
--space-10: 48px;
--space-12: 56px;
--space-16: 80px;
```

### Border Radius Scale

```css
--radius-sm: 4px;      /* Small elements */
--radius-md: 8px;      /* Inputs, small cards */
--radius-lg: 12px;     /* Buttons, icons */
--radius-xl: 16px;     /* Cards, quiz options */
--radius-2xl: 20px;    /* Large cards */
--radius-3xl: 24px;    /* Hero cards */
--radius-full: 9999px; /* Pills, circles */
```

### Shadows

```css
--shadow-sm: 0 1px 3px rgba(0,0,0,0.08);    /* Cards, inputs */
--shadow-md: 0 4px 12px rgba(0,0,0,0.08);   /* Elevated cards */
--shadow-lg: 0 8px 24px rgba(0,0,0,0.12);   /* Modals, hero */
```

### Animation Timing

```css
--ease-out: cubic-bezier(0.16, 1, 0.3, 1);      /* Quick deceleration */
--ease-smooth: cubic-bezier(0.4, 0, 0.2, 1);    /* Standard easing */
--duration-fast: 200ms;    /* Hover states */
--duration-normal: 300ms;  /* Most transitions */
--duration-slow: 400ms;    /* Screen transitions */
```

### Component Patterns

**Cards:**
```css
.card {
    background: white;
    border-radius: 16px;
    box-shadow: var(--shadow-sm);
    border: 1px solid var(--border-color);
}
```

**Primary Button (Orange CTA):**
```css
.btn-primary {
    background: linear-gradient(145deg, #FF7B45 0%, var(--accent) 30%, #E85A25 70%, #FF6B35 100%);
    color: white;
    border-radius: 16px;
    box-shadow: 0 8px 24px rgba(255, 107, 53, 0.4);
    /* Includes shimmer animation and hover lift */
}
```

**Gradient Icons:**
```css
.icon-container {
    background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%);
    border-radius: 12px;
}
/* Accent variant uses --accent to --accent-light */
/* Success variant uses --success to #00D9A0 */
```

### iPhone vs iPad Differences

**iPhone (Default):**
- Bottom tab bar navigation
- Single column layouts
- Horizontal scroll for quick actions
- Device frame: 390x844px, 55px radius

**iPad (`.tablet` class):**
- Left sidebar navigation (80px wide)
- 2-3 column grid layouts
- Larger typography (hero h1: 42px vs 30px)
- Larger spacing and padding
- Device frame: 820x1180px, 40px radius
- Screen container offset by sidebar width

---

## iOS App (`/iOS/KitsinianLegal/`)

### Architecture

- **Pattern:** MVVM (Model-View-ViewModel)
- **Language:** Swift
- **Framework:** SwiftUI
- **Min iOS:** 17.0
- **No external dependencies** (pure SwiftUI)

### File Structure

```
KitsinianLegal/
├── App/
│   ├── KitsinianLegalApp.swift    # Entry point, AppState
│   ├── ContentView.swift           # Tab/sidebar navigation
│   └── Theme.swift                 # Design system
├── Models/
│   ├── PracticeArea.swift          # 15 practice areas with FAQs
│   ├── Lead.swift                  # Lead submission model
│   ├── Quiz.swift                  # Quiz questions & branching
│   └── Resource.swift              # 7 legal resource guides
├── Views/
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   ├── HomeView.swift
│   ├── Quiz/
│   │   ├── QuizStartView.swift
│   │   ├── QuizFlowView.swift      # QuizViewModel
│   │   └── QuizResultView.swift
│   ├── PracticeAreas/
│   │   ├── PracticeAreasListView.swift
│   │   └── PracticeAreaDetailView.swift
│   ├── Resources/
│   │   ├── ResourceLibraryView.swift
│   │   └── ResourceDetailView.swift
│   └── Contact/
│       ├── ContactView.swift
│       └── LeadFormView.swift
└── Services/
    └── APIService.swift            # Backend communication
```

### Key Models

**PracticeArea:**
```swift
struct PracticeArea: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let shortDescription: String
    let fullDescription: String
    let icon: String              // SF Symbol name
    let category: Category        // .inHouse or .referral
    let commonCauses: [String]
    let whatWeDo: [String]
    let faq: [FAQ]
}
```

**Lead:**
```swift
struct Lead: Identifiable, Codable {
    var id: UUID
    var firstName, lastName, email, phone: String
    var preferredContact: ContactMethod  // .phone, .email, .text
    var practiceArea: String
    var practiceAreaCategory: String
    var incidentDate: Date?
    var description: String
    var quizAnswers: [String: String]
    var urgency: Urgency  // .urgent, .normal, .informational
    var createdAt: Date
    var source: String = "ios_app"
}
```

**QuizQuestion/QuizOption:**
```swift
struct QuizQuestion: Identifiable {
    let id: String
    let text: String
    let subtext: String?
    let options: [QuizOption]
    let allowsMultiple: Bool
    let nextQuestionLogic: ((Set<String>) -> String?)?
}

struct QuizOption: Identifiable {
    let id: String
    let text: String
    let icon: String?
    let leadsTo: String?      // Next question ID
    let resultArea: String?   // Practice area ID for result
}
```

### Theme System (Theme.swift)

**Color Extensions:**
```swift
Color.claimPrimary      // #0066FF
Color.claimPrimaryLight // #4D94FF
Color.claimPrimaryDark  // #0047B3
Color.claimAccent       // #FF6B35
Color.claimAccentLight  // #FF8855
Color.claimSuccess      // #00C48C
Color.claimWarning      // #F59E0B
Color.claimGold         // #F59E0B
Color.claimBackground   // #F8FAFC
Color.claimCardBackground // white
Color.claimBorder       // #E5E7EB
Color.claimTextPrimary  // #111827
Color.claimTextSecondary // #4B5563
Color.claimTextMuted    // #9CA3AF
```

**Gradient Extensions:**
```swift
LinearGradient.claimPrimaryGradient  // Primary blue gradient
LinearGradient.claimAccentGradient   // Orange accent gradient
LinearGradient.claimSuccessGradient  // Green success gradient
LinearGradient.claimHeroGradient     // Vertical hero gradient
```

**View Modifiers:**
```swift
.claimShadowSmall()   // Subtle card shadow
.claimShadowMedium()  // Standard elevation
.claimShadowLarge()   // Modal/hero shadow
.claimCard()          // White card with border and shadow
```

**Reusable Components:**
```swift
ClaimItLogo(size: CGFloat, showText: Bool, textColor: Color)
GradientIconView(systemName: String, size: CGFloat, iconSize: CGFloat, gradient: LinearGradient)
TrustBadge(value: String, label: String, compact: Bool)
ClaimPrimaryButtonStyle(isAccent: Bool)
ClaimSecondaryButtonStyle()
```

### iPad Adaptations

`ContentView.swift` detects `horizontalSizeClass`:
- `.regular` (iPad): Uses `NavigationSplitView` with sidebar
- `.compact` (iPhone): Uses `TabView` with bottom tabs

Views check `isIPad` for:
- Grid vs list layouts
- Larger font sizes
- Wider max content width (650px)
- Additional padding

---

## Backend (`/backend/`)

### Technology Stack
- **Runtime:** Node.js 18+
- **Framework:** Express.js
- **Database:** PostgreSQL 14+
- **Security:** Helmet, express-rate-limit
- **Validation:** express-validator
- **Email:** Nodemailer

### API Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| `GET` | `/` | API info | No |
| `GET` | `/api/health` | Health check | No |
| `POST` | `/api/leads` | Submit new lead | No |
| `GET` | `/api/leads` | List all leads | Yes (admin) |
| `GET` | `/api/leads/:id` | Get lead by ID | Yes (admin) |
| `PUT` | `/api/leads/:id` | Update lead | Yes (admin) |
| `DELETE` | `/api/leads/:id` | Delete lead | Yes (admin) |

### Lead Validation Rules

```javascript
body('firstName').trim().notEmpty().isLength({ max: 100 })
body('lastName').trim().notEmpty().isLength({ max: 100 })
body('email').trim().isEmail().normalizeEmail()
body('phone').trim().notEmpty().isLength({ min: 10, max: 20 })
body('preferredContact').optional().isIn(['phone', 'email', 'text'])
body('practiceArea').optional().trim().isLength({ max: 100 })
body('urgency').optional().isIn(['urgent', 'normal', 'informational'])
body('description').optional().trim().isLength({ max: 5000 })
```

### Database Schema

```sql
CREATE TABLE leads (
    id UUID PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    preferred_contact VARCHAR(20) DEFAULT 'phone',
    practice_area VARCHAR(100),
    practice_area_category VARCHAR(50),
    urgency VARCHAR(20) DEFAULT 'normal',
    description TEXT,
    quiz_answers JSONB DEFAULT '{}',
    source VARCHAR(50) DEFAULT 'ios_app',
    status VARCHAR(50) DEFAULT 'new',
    notes TEXT,
    assigned_to VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_leads_status ON leads(status);
CREATE INDEX idx_leads_practice_area ON leads(practice_area);
CREATE INDEX idx_leads_created_at ON leads(created_at DESC);
CREATE INDEX idx_leads_urgency ON leads(urgency);
```

### Environment Variables

```bash
DATABASE_URL=postgresql://...
EMAIL_HOST=smtp.example.com
EMAIL_PORT=587
EMAIL_USER=notifications@example.com
EMAIL_PASS=secret
NOTIFICATION_EMAIL=intake@kitsinianlawfirm.com
ALLOWED_ORIGINS=https://app.claimit.com
PORT=3000
NODE_ENV=production
ENCRYPTION_KEY=<64-char-hex-key>
LEAD_DOCKET_ENDPOINT_URL=https://[YOURFIRM].leaddocket.com/Opportunities/Form/[ID]
```

### Lead Docket Integration

ClaimIt automatically syncs leads to Lead Docket (Filevine) CRM when configured.

**Setup:**
1. In Lead Docket: Settings → Integrations → Create Integration
2. Copy the endpoint URL (format: `https://[FIRM].leaddocket.com/Opportunities/Form/[ID]`)
3. Add to Render environment variables: `LEAD_DOCKET_ENDPOINT_URL`
4. First test submission: Check Lead Docket "Notes" to verify field mapping

**Field Mapping (ClaimIt → Lead Docket):**
| ClaimIt Field | Lead Docket Field |
|---------------|-------------------|
| firstName | FirstName |
| lastName | LastName |
| email | Email |
| phone | PrimaryPhoneNum |
| practiceArea | Case_Type |
| description | Description |
| urgency | Urgency |
| source | Source_Detail |
| quizAnswers | Quiz_Answers (JSON) |

**Files:**
- `backend/src/services/leadDocketService.js` - Integration service
- `backend/src/controllers/leadController.js` - Calls Lead Docket on lead creation

### Deployment (Render)

```yaml
# render.yaml
services:
  - type: web
    name: kitsinian-legal-api
    env: node
    plan: starter
    buildCommand: npm install
    startCommand: npm start
    healthCheckPath: /api/health
```

---

## Business Logic

### Lead Capture Flow

```
1. User encounters CTA (home hero, article, practice area)
2. Enters quiz flow (adaptive branching based on case type)
3. Answers 3-4 screening questions
4. Provides contact information
5. Lead submitted to backend
6. Email notification sent to firm
7. User account auto-created
8. Case appears in "My Cases" with status tracking
```

### Quiz Branching Logic

**Entry Points:**
- Home screen "Start My Free Claim Review" button
- Onboarding screen 2 (incident type selection)
- Article CTAs via `startQuizWithTopic(topic)`
- Practice area detail CTAs
- Referral modal via `startReferralQuiz()`

**Routing Logic (iOS Quiz.swift):**
```swift
// Each option either:
// 1. leadsTo: String → next question ID
// 2. resultArea: String → end quiz with practice area result
```

### Practice Area Categorization

**In-House Handling Criteria:**
- Personal injury cases with clear liability
- Premises liability with identifiable property owner
- Insurance disputes (first-party or third-party)
- Lemon law qualifying vehicles
- Property damage claims

**Referral Routing:**
- Family law → Family law specialists
- Criminal defense → Criminal defense attorneys
- Employment → Employment law firms
- Immigration → Immigration attorneys
- Business/Real Estate → Transactional attorneys
- Medical Malpractice → Med-mal specialists (requires experts)
- Workers' Comp → Workers' comp specialists

---

## Compliance & Legal Features

### Disclaimers

- **Success Rate:** "Results vary by case" asterisk
- **No Fee Unless We Win:** Clarifies attorney fees vs. case costs
- **Attorney Advertising:** State bar compliant notice
- **No Attorney-Client Relationship:** Using app ≠ representation

### CCPA Compliance

- Privacy Policy modal with CCPA rights
- "Do Not Sell My Info" link in footer
- Data access/deletion request info

### Accessibility (WCAG 2.1)

- Semantic HTML (`<nav>`, `<main>`, ARIA roles)
- ARIA labels on all interactive elements
- `aria-selected` on tab navigation
- `visually-hidden` class for screen reader text
- `prefers-reduced-motion` CSS support
- Minimum 44px touch targets
- Focus-visible outlines
- High contrast mode support

---

## Current Status

### Completed
- [x] Full iOS app architecture and code
- [x] Backend API with PostgreSQL
- [x] HTML preview system with iPhone/iPad toggle
- [x] ClaimIt branding and design system
- [x] Legal triage quiz with adaptive branching
- [x] 15 practice areas with FAQs
- [x] 7 legal resource guides with full content
- [x] Lead capture form with validation
- [x] Sign-in/account system (preview)
- [x] My Cases tracking with status badges
- [x] Compliance features (Privacy, Terms, Disclaimers)
- [x] Accessibility improvements

### Pending
- [ ] Install Xcode for iOS development
- [ ] Create Apple Developer account
- [x] Deploy backend to Render (Live: https://kitsinian-legal-api.onrender.com)
- [x] Lead Docket integration (auto-syncs leads to CRM)
- [x] AES-256-GCM encryption for PII data
- [x] Configure Lead Docket endpoint URL in Render
- [ ] Configure SMTP email settings in Render
- [ ] Create app icon (1024x1024)
- [ ] Replace placeholder phone/email
- [ ] Update Privacy Policy email
- [ ] App Store submission
- [ ] Port compliance features to iOS Swift code

### In Progress (February 2026)
- [x] **Accident Mode Phase 1** - HTML Prototype ✅ COMPLETE
  - [x] Accident Mode Entry Banner (Home screen)
  - [x] Safety Check screen
  - [x] Photo Checklist screen (8 types)
  - [x] Voice Recording screen
  - [x] Witness Info form
  - [x] Critical Reminders screen
  - [x] Evidence Review screen
  - [x] Submission Success screen
  - [x] JavaScript functions for full flow

### Future Improvements (from Feb 2025 Audit)
- [ ] Move CTA above fold on smaller screens (may improve conversion)
- [ ] Add loading/disabled state to form submit button
- [ ] Reduce 52 `!important` declarations in CSS (code quality)
- [ ] Replace 190 inline onclick handlers with event delegation (code quality)
- [ ] Split monolithic 332KB index.html into separate CSS/JS/HTML for production

---

## Accident Mode (NOW IN DEVELOPMENT)

**Status:** Phase 1 - HTML Prototype (Active)
**Start Date:** February 3, 2026
**Goal:** Post-crash evidence collection that connects directly to attorney

### Why This Feature Matters

No app currently combines: Crash Detection + Evidence Collection + Attorney Connection
- Morgan & Morgan: Case management only, NO accident mode
- Progressive/State Farm: Crash detection, NO evidence collection
- AxiKit: Evidence forms, NO attorney connection
- **ClaimIt: ALL THREE** ← Competitive moat

### Implementation Phases

#### Phase 1: HTML Prototype ✅ COMPLETE (February 3, 2026)
Interactive mockup in `preview/index.html` - fully functional prototype

**8 Screens Built:**
1. ✅ **Accident Mode Entry** - Red emergency banner on Home tab
2. ✅ **Safety Check** - "Are you safe?" + 911 button
3. ✅ **Photo Checklist** - 8 required photos with capture state
4. ✅ **Voice Recording** - Record button with timer + tips
5. ✅ **Witness Info** - Add/remove witnesses form
6. ✅ **Critical Reminders** - DO's and DON'Ts checklists
7. ✅ **Evidence Review** - Summary with timestamps
8. ✅ **Submission Success** - Confirmation + next steps

**JavaScript Functions Implemented:**
- `enterAccidentMode()` / `exitAccidentMode()`
- `accidentGoToStep(step)` - Navigation with progress
- `capturePhoto(index, type)` - Photo capture simulation
- `toggleRecording()` - Voice recording with timer
- `addWitness()` / `removeWitness()` - Witness management
- `submitEvidence()` - Submission with loading state

#### Phase 2: iOS Native (4-6 weeks)
New Swift files for camera, microphone, GPS integration

```
iOS/KitsinianLegal/Views/AccidentMode/
├── AccidentModeEntryView.swift
├── SafetyCheckView.swift
├── PhotoCaptureView.swift        # AVFoundation camera
├── VoiceRecordingView.swift      # Speech framework
├── WitnessFormView.swift
├── RemindersView.swift
├── EvidenceReviewView.swift
└── SubmissionSuccessView.swift

iOS/KitsinianLegal/Services/
├── CrashDetectionService.swift   # CoreMotion @ 100Hz
├── PhotoCaptureService.swift
├── AudioRecordingService.swift
├── LocationService.swift
└── EvidenceUploadService.swift
```

#### Phase 3: Backend Enhancements (1-2 weeks)
New API endpoints and database tables

```sql
-- New tables for accident evidence
CREATE TABLE accident_reports (
    id UUID PRIMARY KEY,
    lead_id UUID REFERENCES leads(id),
    gps_latitude DECIMAL(10, 8),
    gps_longitude DECIMAL(11, 8),
    weather_conditions TEXT,
    timestamp TIMESTAMP WITH TIME ZONE,
    safety_checklist JSONB,
    status VARCHAR(50) DEFAULT 'collecting',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE accident_photos (
    id UUID PRIMARY KEY,
    accident_id UUID REFERENCES accident_reports(id),
    photo_type VARCHAR(50),  -- 'scene', 'damage-front', etc.
    storage_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE accident_witnesses (
    id UUID PRIMARY KEY,
    accident_id UUID REFERENCES accident_reports(id),
    name VARCHAR(200),
    phone VARCHAR(20),
    email VARCHAR(255)
);
```

#### Phase 4: Advanced Features (Future)
- Crash Detection API (CoreMotion or SafetyKit)
- AI damage assessment from photos
- Voice activation ("Hey ClaimIt")
- Auto-notify emergency contacts
- Pain diary integration

### Photo Checklist (8 Required Types)

| # | Type | Purpose |
|---|------|---------|
| 1 | Scene Overview | Wide shot showing full accident scene |
| 2 | Your Vehicle - Front | Document all front damage |
| 3 | Your Vehicle - Side | Document side damage |
| 4 | Your Vehicle - Rear | Document rear damage |
| 5 | Other Vehicle Damage | Their vehicle's condition |
| 6 | License Plates | Both vehicles |
| 7 | Insurance Cards | Both drivers |
| 8 | Road Conditions | Signs, weather, hazards |

### Critical Reminders (Legal Protection)

**DO:**
- ✅ Check for injuries first
- ✅ Call 911 if anyone is hurt
- ✅ Take photos of EVERYTHING
- ✅ Get witness contact info
- ✅ Get police report number
- ✅ Seek medical attention within 24 hours

**DON'T:**
- ❌ Admit fault or apologize
- ❌ Sign anything at the scene
- ❌ Give recorded statement to insurance
- ❌ Accept first settlement offer
- ❌ Post about accident on social media

### Technical Notes

**Crash Detection Strategy:**
- Primary: CoreMotion at 100Hz (works on ALL iPhones)
- Enhanced: SafetyKit entitlement (iPhone 14+ only)
- Algorithm: >4G acceleration + sudden GPS speed change

**Evidence Storage:**
- Photos: Cloudinary or AWS S3 (encrypted at rest)
- Audio: Same + AWS Transcribe for transcription
- Local: AES-256 encrypted before upload

**UX Principles for Emergency:**
- Large touch targets (60px+ buttons)
- High contrast colors (red/white/green)
- Minimal text, maximum icons
- Offline-capable (queue uploads)
- Voice activation option

---

## Vision Board: Innovative Features (Feb 2025)

Strategic feature ideas to differentiate ClaimIt from competitors. Organized by feasibility.

### 🏆 Game-Changing Features (Requires iOS Developer)

| Feature | Description | Why It's Unique |
|---------|-------------|-----------------|
| **Crash Detection Auto-Launch** | Use Apple's crash detection API (iOS 16+) to auto-launch Emergency Mode | No legal app uses this API - first mover advantage |
| **AI Case Value Estimator** | Analyze injury type, location, insurance company to show realistic settlement range | Lawyers keep this vague - transparency builds trust |
| **Live Case Tracker** | Domino's Pizza Tracker for lawsuits - real-time status updates | Every law firm is a black box - radical transparency |
| **AI Insurance Tactics Decoder** | Upload insurance letters, AI identifies manipulation tactics and lowball offers | Levels playing field against billion-dollar insurers |
| **Dashcam Integration** | Connect to Garmin, Nextbase, Tesla - auto-upload footage when accident detected | Evidence preserved with attorney-client privilege |

### ⚠️ Moderate Complexity (Possible with Help)

| Feature | Description | What's Needed |
|---------|-------------|---------------|
| **Injury Progression Tracker** | Daily check-ins: pain level, photos, symptoms - builds medical timeline | Database, photo storage, notifications |
| **Guardian Angel Mode** | Emergency contacts notified on crash, can track case progress | Twilio SMS API, backend |
| **Settlement Comparison Tool** | "Your offer: $15K / Similar cases: $45-80K / Verdict: REJECT" | Data tables (can be static initially) |
| **AI Letter Analyzer** | Upload insurance letter, get plain-English explanation + recommended response | OpenAI API integration |
| **Referral System** | Unique codes, track referrals, reward successful referrals | Backend + tracking logic |

### ✅ Achievable Now (With Claude's Help)

| Feature | Description | Effort |
|---------|-------------|--------|
| **Static Settlement Estimator** | Hardcoded data ranges by injury type and location | 1 day |
| **Insurance Tactics Guide** | Educational content on common tactics (not AI, just informative) | 1 day |
| **Simple Injury Journal** | localStorage-based daily logging, export to PDF | 1-2 days |
| **Claim Stories Feed** | User-submitted success stories (simple form + display) | 2 days |
| **Case Status Page** | Manual status updates (not real-time, but functional) | 1 day |

### 💡 Advanced/Future Ideas

- **AI Negotiation Coach** - Real-time suggestions when insurance calls
- **Blockchain Evidence** - Tamper-proof photo verification with timestamps
- **Rideshare Driver Mode** - Special features for Uber/Lyft drivers (high accident risk)
- **Witness Network** - "Were you near [location] at [time]? Be a witness"
- **Insurance Company Ratings** - Crowdsourced data on claim denial rates, settlement times
- **Attorney Transparency Score** - Real metrics: cases won, avg settlement, time to resolution

### 🎯 Strategic Recommendations

**The Core Insight:** ClaimIt shouldn't be a lead gen form. It should be an **accident companion**:
- **BEFORE** accident → Installed as "insurance" against the unknown
- **DURING** accident → Crash detect, evidence capture, emergency mode
- **AFTER** accident → Injury tracking, case management, AI guidance
- **RESOLUTION** → Settlement comparison, community celebration

**Recommended Build Order:**
1. Deploy web app live (validate demand first)
2. Add Injury Progression Tracker (daily engagement)
3. Add Settlement Estimator (transparency differentiator)
4. Build Accident Mode (true technical moat)
5. Consider iOS native app only after web validation

**Cost Estimates:**
- Web app with simple features: $0-50/month (doable with Claude)
- Basic iOS app (Upwork/Fiverr): $5,000-20,000
- Advanced iOS app with AI features: $30,000-100,000+
- No-code app builders (FlutterFlow, Adalo): $50-200/month

---

## Commands Reference

```bash
# Open current preview (local)
open /Users/hkitsinian/kitsinian-legal-app/preview/index.html

# View live preview
open https://kitsinianlawfirm.github.io/claimit-preview/

# Start backend (local)
cd /Users/hkitsinian/kitsinian-legal-app/backend
npm install
npm run dev

# Run database migrations
cd /Users/hkitsinian/kitsinian-legal-app/backend
node src/utils/migrate.js

# Open iOS project (requires Xcode)
open /Users/hkitsinian/kitsinian-legal-app/iOS/KitsinianLegal/KitsinianLegal.xcodeproj
```

---

## Repositories

| Repo | URL |
|------|-----|
| Main App | https://github.com/Kitsinianlawfirm/kitsinian-legal-app |
| Preview (GitHub Pages) | https://github.com/Kitsinianlawfirm/claimit-preview |
| Live Preview | https://kitsinianlawfirm.github.io/claimit-preview/ |

---

*Last Updated: February 3, 2026*
