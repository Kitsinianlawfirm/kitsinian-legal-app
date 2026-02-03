# ClaimIt Project Memory

## Branding
- **App Name:** ClaimIt (NOT "Kitsinian Law" - that's the parent firm)
- **Tagline:** "Your Claim. Our Fight."
- **Primary Color:** #0066FF (vibrant blue)
- **Accent Color:** #FF6B35 (orange for CTAs)
- **Success Color:** #00C48C (green)
- **Logo:** Shield with lightning bolt + "ClaimIt" text (gold "It")

## Design Preferences
- Owner prefers the **simple lightning bolt** icon style (not complex/detailed)
- Use **solid white cards** with subtle borders (no glassmorphism - improves readability)
- **Gradient backgrounds** on hero sections only
- All buttons need **44px minimum touch targets**
- Card border-radius should be **16px** (use `var(--radius-xl)`)

## Dual-Repo Workflow
- **Main repo:** `/Users/hkitsinian/kitsinian-legal-app` (source of truth)
- **GitHub Pages:** `/Users/hkitsinian/claimit-preview` (for live preview)
- **ALWAYS sync** `preview/index.html` to both repos after changes
- **ALWAYS push** to both repos when committing preview changes

## Legal Requirements
- All "success rate" claims need asterisk disclaimers (*Results vary)
- "No Fee Unless We Win" needs clarification asterisk
- Privacy Policy must include CCPA rights
- "Do Not Sell My Info" link required for California compliance
- Form submissions need Terms/Privacy disclaimer

## Practice Areas
- **In-House (5):** Personal Injury, Premises Liability, Property Damage, Insurance Bad Faith, Lemon Law
- **Referral Network (10):** Family Law, Criminal Defense, Estate Planning, Employment, Immigration, Bankruptcy, Business, Real Estate, Medical Malpractice, Workers' Comp

## Contact Placeholders (Need Replacing Before Launch)
- Phone: Replace all `+1YOURNUMBER` with real number
- Email: `privacy@claimit.com`, `legal@claimit.com` need real addresses
- Remove any `(213) 555-XXXX` placeholder numbers

## Technical Notes
- iOS minimum: 17.0
- Backend: Node.js/Express + PostgreSQL
- Preview: Single HTML file with inline CSS/JS
- Device frames: iPhone (375px) and iPad (820px) with toggle
- Modals use `position: absolute` to stay inside device frames

## Testing Checklist
- [ ] All tabs navigate correctly
- [ ] Quiz flow completes end-to-end
- [ ] Forms validate and submit
- [ ] Modals open/close properly
- [ ] Works in both iPhone and iPad views
- [ ] Keyboard navigation functional
