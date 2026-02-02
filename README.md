# Kitsinian Law Firm - Legal Triage & Referral App

iOS application for Kitsinian Law Firm, APC providing legal triage, practice area information, resources, and lead capture.

## Features

### Core Functionality
- **Legal Triage Quiz**: Interactive questionnaire to identify legal needs and route to appropriate practice area
- **Practice Areas**: Detailed information on handled areas (PI, premises liability, property damage, insurance bad faith, lemon law) and referral network
- **Resource Library**: Educational guides, checklists, and know-your-rights information
- **Lead Capture**: Contact forms with validation and backend submission
- **Onboarding**: First-run experience explaining app value

### Practice Areas Handled In-House
- Personal Injury
- Premises Liability
- Property Damage
- Insurance Bad Faith
- Lemon Law

### Referral Network
- Family Law
- Criminal Defense
- Estate Planning
- Employment Law
- Immigration
- Bankruptcy
- Business Law
- Real Estate Law
- Medical Malpractice
- Workers' Compensation

## Project Structure

```
kitsinian-legal-app/
├── iOS/
│   └── KitsinianLegal/
│       ├── KitsinianLegal.xcodeproj
│       └── KitsinianLegal/
│           ├── App/
│           ├── Models/
│           ├── Views/
│           ├── Services/
│           └── Assets.xcassets/
├── backend/
│   ├── src/
│   │   ├── routes/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── config/
│   │   └── utils/
│   ├── package.json
│   └── render.yaml
└── README.md
```

## iOS App

### Requirements
- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

### Setup
1. Open `iOS/KitsinianLegal/KitsinianLegal.xcodeproj` in Xcode
2. Update the API base URL in `Services/APIService.swift`
3. Add your Development Team in project settings
4. Build and run

### Key Files
| File | Description |
|------|-------------|
| `Models/PracticeArea.swift` | All practice area data and FAQs |
| `Models/Quiz.swift` | Quiz flow and question logic |
| `Models/Resource.swift` | Legal resources and guides |
| `Views/Quiz/` | Quiz flow UI |
| `Services/APIService.swift` | Backend API communication |

## Backend API

### Requirements
- Node.js 18+
- PostgreSQL

### Setup
```bash
cd backend
cp .env.example .env
# Edit .env with your configuration
npm install
npm run db:migrate
npm start
```

### API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/leads` | Submit new lead |
| GET | `/api/leads` | Get all leads (admin) |
| GET | `/api/leads/:id` | Get lead by ID (admin) |
| PUT | `/api/leads/:id` | Update lead (admin) |
| DELETE | `/api/leads/:id` | Delete lead (admin) |
| GET | `/api/health` | Health check |

### Deployment to Render

1. Create a new Web Service on Render
2. Connect this repository
3. Use the `render.yaml` blueprint OR manually configure:
   - Build Command: `npm install`
   - Start Command: `npm start`
   - Add PostgreSQL database
   - Configure environment variables

## Configuration

### iOS App
Update `Services/APIService.swift`:
```swift
private let baseURL = "https://your-api-url.onrender.com/api"
```

Update phone numbers in:
- `Views/HomeView.swift`
- `Views/Contact/ContactView.swift`
- `Views/Quiz/QuizResultView.swift`

### Backend
See `.env.example` for required environment variables.

## App Store Deployment

1. Create Apple Developer account ($99/year)
2. Generate App Icon (1024x1024)
3. Add to `Assets.xcassets/AppIcon.appiconset/`
4. Configure signing in Xcode
5. Archive and upload via Xcode

## License

Proprietary - Kitsinian Law Firm, APC
