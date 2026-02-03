# ClaimIt - Legal Client Acquisition App

## Project Overview

**Client:** Kitsinian Law Firm, APC
**App Name:** ClaimIt
**Platform:** iOS (SwiftUI)
**Purpose:** Ethical client acquisition and referral network routing for legal services in California

### Business Model
- All leads route to Kitsinian Law Firm
- Firm decides which cases to handle in-house vs. refer out
- No specific attorney branding - app is consumer-facing and general
- Focus: Southern California, statewide California coverage

---

## Practice Areas

### In-House (Primary)
- Personal Injury
- Premises Liability
- Property Damage
- Insurance Bad Faith
- Lemon Law (secondary)

### Referral Network
- Family Law
- Criminal Defense
- Estate Planning
- Employment Law
- Immigration
- Bankruptcy
- Business Law
- Real Estate
- Medical Malpractice
- Workers' Compensation

---

## What's Been Built

### iOS App (`/iOS/KitsinianLegal/`)
Complete SwiftUI application with:

#### Architecture
- **Pattern:** MVVM
- **Min iOS:** 17.0
- **Language:** Swift

#### App Structure
```
KitsinianLegal/
├── App/
│   ├── KitsinianLegalApp.swift    # Entry point (ClaimItApp), AppState
│   ├── ContentView.swift           # Tab navigation
│   └── Theme.swift                 # Design system (colors, gradients, components)
├── Models/
│   ├── PracticeArea.swift          # 15 practice areas with FAQs
│   ├── Lead.swift                  # Lead data model
│   ├── Quiz.swift                  # Legal triage quiz logic
│   └── Resource.swift              # 7 legal resources/guides
├── Views/
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   ├── HomeView.swift
│   ├── Quiz/
│   │   ├── QuizStartView.swift
│   │   ├── QuizFlowView.swift      # ViewModel with branching logic
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

#### Features
- Legal triage quiz with smart branching
- Practice area browser with FAQs
- Resource library with legal guides
- Lead capture form
- Push notification ready

### Preview Features (HTML - `/preview/index.html`)
- **Sign-In/Account System**: User authentication with phone/email
- **My Cases Screen**: Track submitted claims with status badges
- **Case Status Flow**: Submitted → Under Review → Qualified → Matched → Retained
- **Attorney Assignment**: Shows assigned attorney info when case is retained
- **Adaptive Quiz**: Follow-up questions change based on case type selected
- **4 Tabs**: Home, Claim, Learn, Account (Contact tab removed)

### Backend (`/backend/`)
Node.js/Express API with PostgreSQL:

```
backend/
├── package.json
├── render.yaml                     # Render deployment config
└── src/
    ├── index.js                    # Express server
    ├── routes/
    │   ├── leads.js                # Lead CRUD endpoints
    │   └── health.js
    ├── controllers/
    │   └── leadController.js
    ├── config/
    │   └── database.js             # PostgreSQL pool
    ├── services/
    │   └── emailService.js         # Nodemailer notifications
    └── utils/
        ├── logger.js
        └── migrate.js              # DB schema
```

#### Endpoints
- `POST /api/leads` - Create new lead
- `GET /api/leads` - List leads (admin)
- `GET /api/leads/:id` - Get lead details
- `PATCH /api/leads/:id` - Update lead status
- `GET /health` - Health check

### HTML Previews (`/preview/`)
Browser-based design mockups for iteration:

| File | Description |
|------|-------------|
| `index.html` | **CURRENT** - Full interactive with sign-in, account, adaptive quiz |
| `claimit-full.html` | Previous version with full article content |
| `claimit-interactive.html` | Interactive tab navigation |
| `claimit.html` | ClaimIt rebrand, static tabs |
| `old-kitsinian-index.html` | Original Kitsinian Law branded (deprecated) |

**Live Preview:** https://kitsinianlawfirm.github.io/claimit-preview/

---

## Design System (ClaimIt)

### Brand Identity
- **Name:** ClaimIt
- **Tagline:** "Your Claim. Our Fight."
- **Tone:** Bold, action-oriented, empowering

### Color Palette
```css
--primary: #0066FF;        /* Vibrant blue */
--primary-light: #4D94FF;
--accent: #FF6B35;         /* Orange - CTAs */
--accent-light: #FF8F66;
--success: #00C48C;        /* Green - confirmations */
--bg-gradient-start: #0066FF;
--bg-gradient-end: #00D4FF;
```

### UI Features
- Solid white cards with subtle shadows (no glassmorphism - improves readability)
- Gradient backgrounds on hero sections
- Gradient icons (GradientIconView component)
- Accent-colored CTAs with shadows
- Card-based layouts with subtle borders
- Bottom tab navigation
- ClaimIt logo (shield with lightning bolt)

### iOS Theme System (Theme.swift)
- Color extensions: `.claimPrimary`, `.claimAccent`, `.claimSuccess`, etc.
- Gradient extensions: `.claimPrimaryGradient`, `.claimAccentGradient`, etc.
- Shadow modifiers: `.claimShadowSmall()`, `.claimShadowLarge()`
- Reusable components: `ClaimItLogo`, `GradientIconView`, `TrustBadge`

---

## Current Status

### Completed
- [x] Full iOS app architecture and code
- [x] Backend API with PostgreSQL
- [x] HTML preview system for design iteration
- [x] ClaimIt branding and design system
- [x] Interactive prototype with full article content
- [x] Legal triage quiz flow
- [x] 15 practice areas with content
- [x] 5 legal resource guides with full content
- [x] Lead capture form
- [x] **iOS Swift code updated to ClaimIt design** (Feb 2025)
  - Theme.swift: Complete design system with colors, gradients, shadows
  - All views updated to use `.claimPrimary`, `.claimAccent`, etc.
  - GradientIconView replacing raw SF Symbols
  - Solid white cards with borders (replaced glassmorphism)
  - 2-screen onboarding with incident type selection
  - Modern card-based UI throughout
- [x] **Sign-In & Account Feature** (Feb 2025)
  - Sign-in button in status bar
  - Sign-in modal with phone/email
  - Account tab replacing Contact tab
  - My Cases screen with status tracking
  - Auto-account creation on form submission
- [x] **Adaptive Quiz System** (Feb 2025)
  - Dynamic Step 2 questions based on case type
  - Car accident: role (driver, passenger, pedestrian, rideshare)
  - Injury: cause (work, medical, product, dog bite, assault)
  - Slip/fall: location (store, apartment, sidewalk, workplace)
  - Insurance: issue (denied, delayed, lowball, cancelled)
  - Lemon: problem (engine, electrical, safety, recurring)
  - Property: type (vehicle, fire, water, theft)
  - Streamlined to 4 questions + contact form

### Pending
- [ ] User to install Xcode for iOS development
- [ ] User to create Apple Developer account
- [ ] Deploy backend to Render
- [ ] Create app icon (1024x1024)
- [ ] Replace placeholder phone numbers with real ones
- [ ] App Store submission

---

## Design Iteration History

1. **v1 (old-kitsinian-index.html):** Kitsinian Law branded, conservative design
2. **v2 (claimit.html):** Rebranded to ClaimIt, vibrant colors, animations
3. **v3 (claimit-interactive.html):** Added tab interactivity
4. **v4 (claimit-full.html):** Full article content, interactive checklists
5. **v5 (iOS update):** Full iOS SwiftUI code updated to match ClaimIt design
6. **v6 (index.html):** Sign-in/account system, My Cases tracking
7. **v7 (index.html):** Adaptive quiz with case-type-specific questions

### User Feedback Applied
- Remove law firm branding → made general/consumer-facing
- "Looks boring" → vibrant blue/orange, gradient accents
- Emojis look amateur → custom gradient icons (GradientIconView)
- Text hard to read on transparent → solid white cards with borders
- Action-oriented name → "ClaimIt"
- Interactive tabs needed → JavaScript tab switching
- Show guide content → Full article detail views
- 2-screen onboarding with incident selection
- Remove direct contact options → users work through quiz flow
- Quiz too generic → adaptive questions based on case type
- Need case tracking → My Cases with status badges and attorney info

---

## Technical Notes

### iOS Requirements
- Xcode 15+ required
- iOS 17.0 minimum deployment target
- No external dependencies (pure SwiftUI)

### Backend Requirements
- Node.js 18+
- PostgreSQL 14+
- Environment variables needed:
  - `DATABASE_URL`
  - `EMAIL_HOST`, `EMAIL_PORT`, `EMAIL_USER`, `EMAIL_PASS`
  - `NOTIFICATION_EMAIL`

### Deployment
- Backend: Render (config in `render.yaml`)
- iOS: App Store (requires Apple Developer account)

---

## File Locations

| Asset | Path |
|-------|------|
| iOS App | `/iOS/KitsinianLegal/` |
| Backend | `/backend/` |
| Previews | `/preview/` |
| Current Preview | `/preview/index.html` |
| Live Preview | https://kitsinianlawfirm.github.io/claimit-preview/ |

---

## Next Steps (Recommended Order)

1. **Install Xcode** - Required for iOS development (download from Mac App Store)
2. **Test on Simulator** - Run app in Xcode iOS Simulator
3. **Replace phone numbers** - Update placeholder `+1YOURNUMBER` with real contact
4. **Create app icon** - 1024x1024 ClaimIt logo for App Store
5. **Deploy backend** - Push to Render
6. **Create developer account** - Apple Developer Program ($99/year)
7. **App Store submission** - TestFlight beta, then production

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

# Open iOS project (requires Xcode)
open /Users/hkitsinian/kitsinian-legal-app/iOS/KitsinianLegal/KitsinianLegal.xcodeproj
```

---

## Repositories

| Repo | URL |
|------|-----|
| Main App | https://github.com/Kitsinianlawfirm/kitsinian-legal-app |
| Preview (GitHub Pages) | https://github.com/Kitsinianlawfirm/claimit-preview |

---

*Last Updated: February 2, 2025*
