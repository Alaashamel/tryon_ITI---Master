<div align="center">

<img src="./public/logo-dark.svg#gh-dark-mode-only" alt="ReDolapy" width="220"/>
<img src="./public/logo-light.svg#gh-light-mode-only" alt="ReDolapy" width="220"/>

<br/>

# ReDolapy

### AI-Powered Virtual Try-On & Fashion Intelligence Platform

<p><em>Upload. Analyze. Wear. Recycle.</em></p>

<br/>

[![React](https://img.shields.io/badge/React_19-20232A?style=flat-square&logo=react&logoColor=61DAFB)](https://react.dev)
[![Vite](https://img.shields.io/badge/Vite_8-646CFF?style=flat-square&logo=vite&logoColor=white)](https://vitejs.dev)
[![TailwindCSS](https://img.shields.io/badge/Tailwind_4-06B6D4?style=flat-square&logo=tailwindcss&logoColor=white)](https://tailwindcss.com)
[![MUI](https://img.shields.io/badge/MUI_9-007FFF?style=flat-square&logo=mui&logoColor=white)](https://mui.com)
[![PWA](https://img.shields.io/badge/PWA-Ready-5A0FC8?style=flat-square&logo=pwa&logoColor=white)](https://web.dev/progressive-web-apps)
[![i18n](https://img.shields.io/badge/i18n-EN%20%7C%20AR-8B5CF6?style=flat-square&logo=i18next&logoColor=white)](https://www.i18next.com)
[![Stripe](https://img.shields.io/badge/Stripe-Payments-635BFF?style=flat-square&logo=stripe&logoColor=white)](https://stripe.com)
[![License](https://img.shields.io/badge/License-Academic-gray?style=flat-square)](#license)

<br/>

[Features](#-features) · [Architecture](#-architecture) · [Tech Stack](#-tech-stack) · [Getting Started](#-getting-started) · [PWA](#-pwa) · [Roadmap](#-roadmap)

</div>

---

## What is ReDolapy?

ReDolapy is a full-stack **AI fashion intelligence platform** built as an installable Progressive Web App. It combines computer vision, generative AI, and real-time weather data to deliver a personalized fashion experience — from virtual try-on to sustainable upcycling — all in one offline-capable, bilingual (EN/AR) app.

> 🎓 Built for the **ITI Graduation Project** · React 19 · Offline-first · Role-based access · Stripe payments

---

## ✨ Features

| Feature | Description |
|---|---|
| 👗 **Virtual Try-On** | Try clothes on an AI avatar or personal photo. Single garment or full outfit (top + bottom). Powered by KIE API. |
| ♻️ **Recycle & Upcycle** | AI analyzes your garments, generates design ideas, and produces visual upcycling concepts via generative models. |
| 🧠 **AI Recommendations** | Daily outfit suggestions based on your wardrobe + live weather (temp, humidity, wind). Auto-translated to Arabic. |
| 🪞 **Digital Wardrobe** | Upload, categorize, edit, and manage all clothing. Paginated grid, health indicator, full offline access. |
| 🔍 **Smart Matching** | Select any wardrobe item → find visually similar products from connected stores → try them on instantly. |
| 🛍️ **Store Browsing** | Browse products with category, price, store, and color filters. One-click try-on from any product card. |
| 🧬 **Avatar Generation** | Customize skin tone, hair color, and gender. Avatar auto-loads in every try-on session. |
| 🔔 **Notifications** | Real-time notification center. Admin can broadcast, schedule, and automate notification rules. |
| 🔐 **Auth** | Email/password + Google OAuth. JWT with role-based guards (User / Premium / Admin). |
| 💳 **Subscriptions** | Essential (free) and Pro ($19.99/mo) tiers via Stripe Checkout with sync and cancellation. |
| 🌐 **Bilingual** | Full EN/AR UI (~800 keys each). Runtime translation for AI-generated content via MyMemory API. |

---

## 🏗 Architecture

The app is structured in **6 layers**, each with a clear responsibility:

```
┌─────────────────────────────────────────────────────────────────┐
│                    React App  (Vite + React Router 7)           │
│  ┌──────────────┐  ┌───────────────────┐  ┌──────────────────┐ │
│  │ Public routes│  │ Auth-guarded routes│  │ Admin-only routes │ │
│  └──────────────┘  └───────────────────┘  └──────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                               │
┌─────────────────────────────────────────────────────────────────┐
│              Context Providers  (global state)                  │
│  AuthContext · ThemeContext · WardrobeContext                   │
│  RecommendationContext · FavoritesContext                       │
└─────────────────────────────────────────────────────────────────┘
              │                               │
┌─────────────────────────┐   ┌───────────────────────────────┐
│      API Layer           │   │        Cache Layer             │
│  axiosInstance           │   │  cacheService (hash-based)    │
│  (JWT Bearer interceptor)│   │                               │
│                          │   │  ┌─────────────┐ ┌─────────┐ │
│  authApi · wardrobeApi   │   │  │  IndexedDB  │ │  local  │ │
│  tryOnApi · recycleApi   │   │  │  10 stores  │ │Storage  │ │
│  matchingApi · avatarApi │   │  │  wardrobe   │ │  auth   │ │
│  paymentApi · adminApi   │   │  │  products   │ │  theme  │ │
│  + 5 more modules        │   │  │  favorites  │ │  outfit │ │
│                          │   │  │  + 7 more   │ │  cache  │ │
└─────────────────────────┘   │  └─────────────┘ └─────────┘ │
                               └───────────────────────────────┘
                               │
┌─────────────────────────────────────────────────────────────────┐
│                 Service Worker  (Workbox)                        │
│                                                                  │
│  NetworkFirst        CacheFirst       StaleWhileRevalidate       │
│  API calls · 24h     Images · 30d     Scripts & Styles · 7d     │
│  + background sync   Fonts · 365d     Navigation → index.html   │
└─────────────────────────────────────────────────────────────────┘
                               │
┌─────────────────────────────────────────────────────────────────┐
│                    External Services                             │
│                                                                  │
│  REST API Backend    KIE API           Google OAuth    Stripe    │
│  (VITE_API_URL)      Virtual Try-On    Social login    Payments  │
│                                                                  │
│  MyMemory API        Workbox SW        Lottie Web                │
│  EN → AR runtime     Offline cache     Animations                │
└─────────────────────────────────────────────────────────────────┘
```

### Data flow

```
User action
  → React Component
    → Context Provider
      ├─ Cache hit  → IndexedDB → render immediately (cache-first)
      └─ Cache miss → API fetch → hash compare
                                    ├─ unchanged → skip re-render
                                    └─ changed   → update IDB → re-render

Offline:
  → IndexedDB fallback → render last cached data gracefully
```

### Cache invalidation

`cacheService.js` computes a hash of cached data before every network fetch. The UI only re-renders when hashes differ — minimizing unnecessary updates even when the app is actively syncing in the background.

### IndexedDB stores

| Store | Purpose |
|---|---|
| `wardrobe` | Clothing items (indexed by `userId`) |
| `products` | Store product catalog |
| `stores` | Connected store list |
| `recommendations` | Outfit recommendation history |
| `favorites` | Saved items across all categories |
| `user_profile` | Profile data |
| `subscription` | Plan status (5-min TTL) |
| `product_matches` | Visual match results |
| `cache_meta` | Timestamps and hashes per cache key |

### Service worker strategies

| Resource | Strategy | TTL |
|---|---|---|
| API calls (`/api/*`) | NetworkFirst + background sync queue | 24 h |
| Images | CacheFirst | 30 days |
| Fonts | CacheFirst | 365 days |
| Scripts & Styles | StaleWhileRevalidate | 7 days |

---

## 🗂 Project Structure

```
src/
├── api/              # Axios modules per domain
│   ├── axiosInstance.js       # JWT Bearer interceptor
│   ├── authApi.js             # /auth/*
│   ├── wardrobeApi.js         # /wardrobe/*
│   ├── tryOnApi.js            # /virtual-tryon/*
│   ├── recycleApi.js          # /recycle/*
│   ├── matchingApi.js         # /matches · /analyze
│   ├── avatarApi.js           # /avatars/*
│   ├── paymentApi.js          # /payments/*
│   ├── notificationApi.js     # /notifications/*
│   ├── adminApi.js            # admin CRUD
│   └── favorites_services/
│
├── context/          # Global state providers
│   ├── AuthContext.jsx
│   ├── ThemeContext.jsx
│   ├── WardrobeContext.jsx    # cache-first loading
│   ├── RecommendationContext.jsx
│   └── FavoritesContext.jsx   # optimistic updates
│
├── services/
│   ├── indexedDB.js           # IDB wrapper (10 object stores)
│   └── cacheService.js        # hash-based sync
│
├── hooks/
│   ├── useOnlineStatus.js
│   └── useCacheSync.js
│
├── utils/
│   ├── tokenUtils.js          # localStorage auth helpers
│   ├── translate.js           # MyMemory EN → AR
│   ├── toast.js               # SweetAlert2 config
│   └── dailyRecommendation.js
│
├── i18n/
│   ├── locales/en.json        # ~800 keys
│   ├── locales/ar.json        # ~800 keys
│   └── admin/                 # separate admin i18n instance
│
├── components/       # Shared UI components
│   ├── Navbar.jsx · Footer.jsx · Button.jsx
│   ├── wardrobe/ · store/ · tryOn/
│   └── PWAUpdatePrompt · PwaInstallButton · NotificationWindow
│
├── pages/            # Route-level components
│   ├── home/ · Auth/ · tryOn/ · wardrobe/
│   ├── recycle/ · matching/ · store/
│   ├── recommendations/ · avatar/ · profile/
│   ├── fav/ · pricing/ · admin/
│   └── OfflinePage/ · NotFound/
│
└── icons/            # 28 custom SVG icon components
```

---

## 🔐 Auth & Route Guards

```
Public          /  · /about · /about-tryon · /about-recycle · /contact-us
                /auth/callback  (Google OAuth redirect)

Auth-guarded    /tryOn · /wardrobe · /recycle · /matching
                /stores · /recommendations · /avatar
                /pricing · /editprofile · /favorites

Admin-only      /admin  (role === "admin" enforced by AdminGuard)
```

Three guard components enforce access: `AuthGuard`, `UserGuard` (redirects admins to `/admin`), and `AdminGuard`. Both `UserGuard` and `AdminGuard` watch for session expiry and navigate to `/login` automatically.

---

## 💻 Tech Stack

| Layer | Technology | Version |
|---|---|---|
| **UI Framework** | React | 19 |
| **Build Tool** | Vite | 8 |
| **Routing** | React Router | 7 |
| **Styling** | Tailwind CSS | 4 |
| **Component Library** | Material UI | 9 |
| **State Management** | React Context API | — |
| **HTTP Client** | Axios | 1.17 |
| **Offline Storage** | IndexedDB (10 stores) | — |
| **Service Worker** | Workbox via vite-plugin-pwa | — |
| **i18n** | i18next + react-i18next | 26 / 17 |
| **Payments** | Stripe Checkout | — |
| **Animations** | Lottie Web | 5.13 |
| **Notifications** | SweetAlert2 | 11 |
| **Auth** | JWT + Google OAuth | — |
| **AI: Try-On** | KIE API | — |
| **AI: Recycling** | qwen-image-2.0-pro | — |
| **Translation** | MyMemory API | — |
| **Fonts** | Roboto · Plus Jakarta Sans · Geist | — |

---

## 🚀 Getting Started

### Prerequisites

- **Node.js** ≥ 20
- **npm** ≥ 9

### Install

```bash
git clone https://github.com/your-org/redolapy.git
cd redolapy
npm install
```

### Environment variables

```bash
# .env
VITE_API_URL=http://localhost:5000/api
VITE_KIE_API_KEY=your_kie_api_key_here
```

### Run

```bash
npm run dev        # http://localhost:5173 with HMR
npm run build      # production build → dist/
npm run preview    # preview production build locally
npm run lint       # ESLint check
```

### Docker

```bash
docker build -t redolapy .
docker run -p 8080:8080 redolapy
```

Multi-stage build: `node:20-alpine` → `nginx:alpine`. Output on port 8080.

### Deploy to Vercel

```bash
npm run build
vercel --prod
```

The included `vercel.json` handles SPA routing. Deploy `dist/` to any static host (Vercel, Netlify, Cloudflare Pages, AWS S3).

---

## 📱 PWA

ReDolapy is fully installable as a standalone desktop or mobile app:

- **Install** — custom `PwaInstallButton` hooks into `beforeinstallprompt`
- **Update** — `PWAUpdatePrompt` notifies users when a new service worker is ready
- **Offline routes** — `/`, `/about`, `/about-tryon`, `/about-recycle`, `/contact-us` render from cache
- **Offline data** — Wardrobe, recommendations, favorites, products all served from IndexedDB
- **Manifest** — name "ReDolapy" · theme `#8B5CF6` · display `standalone` · portrait-primary · categories: fashion, lifestyle, shopping

---

## 🖥 Admin Dashboard

Full CRUD behind `AdminGuard` (`role === "admin"`):

- **Stores & Products** — create, edit, delete with bulk operations
- **Users** — manage roles (User / Premium / Admin), view stats
- **Notification Center** — broadcast to all, send to specific users, schedule, automate rules
- **Email Center** — view threads, reply, compose to users
- **API Keys** — view and manage service API keys
- **Contact Messages** — view and respond to contact form submissions

---

## 💳 Subscription Tiers

| | Essential | Pro |
|---|---|---|
| **Price** | Free | $19.99 / month |
| Wardrobe uploads | Limited | Unlimited |
| Try-on image quality | Standard | High-fidelity |
| Advanced AI features | — | ✓ |
| Priority processing | — | ✓ |

Powered by Stripe Checkout. Subscription status is cached in IndexedDB with a 5-minute TTL and synced on every session start.

---

## 🌐 Internationalization

- Full UI in **English** and **Arabic** — ~800 translation keys each
- Separate admin locale (~300 keys per language) — isolated i18next instance
- Browser language auto-detected via `i18next-browser-languagedetector`
- AI-generated content (outfit names, product descriptions) translated at runtime via **MyMemory API** with automatic English fallback

---

## 🔧 Troubleshooting

| Issue | Solution |
|---|---|
| CORS errors on API calls | Configure backend CORS to allow your frontend origin |
| Virtual try-on fails | Check `VITE_KIE_API_KEY` in `.env`; try a smaller image |
| Recommendations not appearing | Add wardrobe items first; wait 5 min (cooldown enforced server-side) |
| Offline page shows unexpectedly | Navigate to a cached route (`/`, `/about`) or wait for connection |
| PWA update not showing | Hard refresh (`Ctrl+Shift+R`) or clear site data |
| Translations broken | English fallback is automatic — check MyMemory API status |
| Missing IndexedDB data | Go online and refresh — cache re-syncs automatically |
| Docker build fails | Ensure you're using `node:20-alpine` as specified in the Dockerfile |

---

## 🗺 Roadmap

**Performance**
- [ ] Route-level code splitting via `React.lazy()` across all page components
- [ ] Virtual scrolling (`react-window`) for large wardrobe and product lists
- [ ] Server-side image resizing and WebP conversion pipeline
- [ ] Debounced search input in store browsing

**Developer Experience**
- [ ] TypeScript migration
- [ ] Vitest + React Testing Library unit tests
- [ ] Playwright E2E tests for critical flows (try-on, auth, checkout)
- [ ] GitHub Actions CI/CD pipeline
- [ ] Sentry error monitoring + Lighthouse performance budgets

**Features**
- [ ] Web Push API for real-time push notifications
- [ ] Outfit social sharing
- [ ] Barcode/QR scan to auto-import clothing into wardrobe
- [ ] Wardrobe analytics — cost-per-wear, usage frequency, sustainability score
- [ ] Multi-language expansion beyond EN/AR

---

## 📄 License

This project is an academic graduation project. All rights reserved.

---

<div align="center">

Built with ❤️ for the **ITI Graduation Project**

</div>
