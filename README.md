<div align="center">

<img src="./public/logo-dark.svg#gh-dark-mode-only" alt="ReDolapy" width="200"/>
<img src="./public/logo-light.svg#gh-light-mode-only" alt="ReDolapy" width="200"/>

# ReDolapy

**Virtual Try-On & AI Fashion Intelligence Platform**

*Upload. Analyze. Wear. Recycle.*

[![React](https://img.shields.io/badge/React_19-20232A?style=flat-square&logo=react&logoColor=61DAFB)](https://react.dev)
[![Vite](https://img.shields.io/badge/Vite_8-646CFF?style=flat-square&logo=vite&logoColor=white)](https://vitejs.dev)
[![TailwindCSS](https://img.shields.io/badge/Tailwind_4-06B6D4?style=flat-square&logo=tailwindcss&logoColor=white)](https://tailwindcss.com)
[![PWA](https://img.shields.io/badge/PWA-Ready-5A0FC8?style=flat-square&logo=pwa&logoColor=white)](https://web.dev/progressive-web-apps)
[![i18n](https://img.shields.io/badge/i18n-EN%20%7C%20AR-8B5CF6?style=flat-square)](https://www.i18next.com)
[![License](https://img.shields.io/badge/License-Academic-gray?style=flat-square)](#license)

</div>

---

## What is ReDolapy?

ReDolapy is an AI-powered fashion platform built as a Progressive Web App. It lets users virtually try on clothes, get daily outfit recommendations based on real weather, recycle and upcycle old garments using generative AI, and match wardrobe items to real store products — all from a single installable web app.

> Built for the ITI Graduation Project. Full-stack, offline-capable, bilingual (EN/AR).

---

## Core Workflows

```
Upload wardrobe  →  AI analysis  →  Virtual try-on  →  Save favorites
Browse stores    →  View product →  Try-on preview  →  Purchase
Select clothing  →  AI recycling ideas  →  Generate upcycled design
Choose item      →  Find matching store products  →  Try matched outfit
```

---

## Feature Highlights

### 👗 Virtual Try-On
Choose your model (AI avatar or personal photo), pick up to 2 wardrobe items or upload directly, and generate a photorealistic try-on — powered by the KIE API.

### 🔁 Recycle & Upcycle
Select items from your wardrobe, let AI analyze material and condition, pick a design idea, and generate a new visual concept using models like `qwen-image-2.0-pro`.

### 🧠 AI Recommendations
Daily outfit suggestions tailored to your wardrobe, local weather (temperature, humidity, wind), and time of day — with automatic Arabic translation via the MyMemory API.

### 🪞 Digital Wardrobe
Upload, categorize, edit, and manage all your clothing. Paginated grid, offline access, and a wardrobe health indicator.

### 🔍 Smart Matching
Pick any wardrobe item → find visually similar products from connected stores → try them on instantly.

### 🛍️ Store Browsing
Browse products with filtering by category, price, store, and color. One-click to try-on from any product card.

### 🧬 Avatar Generation
Customize an AI avatar (skin tone, hair color, gender) and use it across all try-on sessions.

---

## Tech Stack

| Layer | Technology |
|---|---|
| **UI Framework** | React 19, React Router 7 |
| **Build Tool** | Vite 8 |
| **Styling** | Tailwind CSS 4, Material UI 9, CSS Modules |
| **State** | React Context API (Auth, Theme, Wardrobe, Recommendations, Favorites) |
| **HTTP** | Axios with JWT Bearer interceptor |
| **Offline / Cache** | IndexedDB (10 stores), localStorage, Workbox Service Worker |
| **PWA** | vite-plugin-pwa, Web App Manifest, install + update prompts |
| **i18n** | i18next, react-i18next, MyMemory API (EN → AR runtime translation) |
| **Payments** | Stripe Checkout |
| **Animations** | Lottie Web |
| **Notifications** | SweetAlert2 toasts + real-time notification center |
| **Auth** | JWT + Google OAuth |

---

## Architecture

```
src/
├── api/              # Axios modules per domain (auth, wardrobe, tryOn, recycle…)
├── context/          # ThemeContext · AuthContext · WardrobeContext · RecommendationContext · FavoritesContext
├── services/         # IndexedDB wrapper · hash-based cache sync
├── hooks/            # useOnlineStatus · useCacheSync
├── utils/            # tokenUtils · translate · toast · dailyRecommendation
├── i18n/             # en.json · ar.json (~800 keys each) + admin locale
├── components/       # Navbar · Wardrobe · Store · TryOn sub-components
├── pages/            # Home · Auth · TryOn · Wardrobe · Recycle · Matching · Store…
└── icons/            # 28 custom SVG icon components
```

### Caching — two-tier strategy

**IndexedDB** stores wardrobe items, products, stores, recommendations, favorites, user profile, subscription status, and product matches — with hash-based invalidation so the UI only re-renders when data actually changes.

**localStorage** stores the JWT token, theme preference, and daily outfit cache per user.

The service worker (Workbox) uses:

| Resource | Strategy | TTL |
|---|---|---|
| API calls | NetworkFirst + background sync | 24 h |
| Images | CacheFirst | 30 days |
| Fonts | CacheFirst | 365 days |
| Scripts & Styles | StaleWhileRevalidate | 7 days |

---

## Data Flow

```
User action
  → React Component
    → Context Provider (cache-first check)
      ├─ [hit]  → IndexedDB → render immediately
      └─ [miss] → API fetch → hash compare → update IDB → re-render

Offline:
  → IndexedDB fallback → render cached data
```

---

## Route Structure

| Route | Access | Purpose |
|---|---|---|
| `/` | Public | Landing page |
| `/about`, `/contact-us` | Public | Info pages (offline-cached) |
| `/tryOn` | Auth required | Virtual try-on |
| `/wardrobe` | Auth required | Digital wardrobe |
| `/recycle` | Auth required | AI recycling |
| `/matching` | Auth required | Product matching |
| `/stores` | Auth required | Store browsing |
| `/recommendations` | Auth required | Daily outfit AI |
| `/avatar` | Auth required | Avatar generation |
| `/pricing` | Auth required | Subscription plans |
| `/admin` | Admin only | Full admin dashboard |

---

## Getting Started

### Prerequisites

- Node.js ≥ 20
- npm ≥ 9

### Install & Run

```bash
git clone https://github.com/your-org/redolapy.git
cd redolapy
npm install
npm run dev
```

App runs at `http://localhost:5173`

### Environment Variables

```bash
# .env
VITE_API_URL=http://localhost:5000/api
VITE_KIE_API_KEY=your_kie_api_key_here
```

### Build & Deploy

```bash
npm run build        # output → dist/
npm run preview      # preview production build locally
```

Deploy `dist/` to any static host. The included `vercel.json` handles SPA routing automatically.

### Docker

```bash
docker build -t redolapy .
docker run -p 8080:8080 redolapy
```

Multi-stage build: Node 20 Alpine → Nginx Alpine.

---

## PWA

ReDolapy is fully installable as a standalone app on desktop and mobile:

- **Install prompt** — custom `PwaInstallButton` using `beforeinstallprompt`
- **Update prompt** — notifies users when a new version is available
- **Offline pages** — Home, About, and info routes work without a connection
- **Offline data** — Wardrobe, recommendations, favorites, and products served from IndexedDB when offline
- **App manifest** — name "ReDolapy", theme `#8B5CF6`, display `standalone`, categories: fashion / lifestyle / shopping

---

## Admin Dashboard

Full CRUD for stores, products, and users. Includes a notification center (broadcast + scheduled + automated rules), an email center for user threads, API key management, and contact form handling — all behind role-based route guards.

---

## Subscription Tiers

| | Essential | Pro |
|---|---|---|
| Price | Free | $19.99 / month |
| Uploads | Limited | Unlimited |
| Image quality | Standard | High-fidelity |
| Advanced features | — | ✓ |

Powered by Stripe Checkout with subscription sync and cancellation support.

---

## Internationalization

- Full UI in **English** and **Arabic** (~800 translation keys each)
- Separate admin locale (~300 keys per language)
- Auto-detects browser language via `i18next-browser-languagedetector`
- Runtime English → Arabic translation for AI-generated content (outfit names, product descriptions) via MyMemory API

---

## Troubleshooting

| Issue | Fix |
|---|---|
| Virtual try-on fails | Check `VITE_KIE_API_KEY` in `.env`; try a smaller image |
| Recommendations missing | Add wardrobe items first; wait 5 min (cooldown) |
| Offline page shows unexpectedly | Navigate to a cached route (Home, About) or wait for connection |
| Translations not working | English fallback is automatic when MyMemory API is unavailable |
| Missing IndexedDB data | Go online and refresh to re-sync |

---

## Roadmap

- [ ] Full route-level code splitting with `React.lazy()`
- [ ] TypeScript migration
- [ ] Vitest + React Testing Library unit tests
- [ ] Playwright E2E for critical flows
- [ ] Web Push API for real-time notifications
- [ ] Virtual scrolling for large wardrobe/product lists
- [ ] Outfit social sharing
- [ ] Wardrobe analytics (cost-per-wear, usage patterns)
- [ ] CI/CD pipeline (GitHub Actions)
- [ ] Sentry error monitoring

---

<div align="center">

Built with ❤️ — ITI Graduation Project

</div>
