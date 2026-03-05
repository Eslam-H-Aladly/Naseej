# Dar Alabaya – Backend Prompt (A-to-Production)

**Document Purpose:** This file is a single, comprehensive prompt for a Senior Node.js Backend Developer (using Cursor with Opus 4.6) to build the entire backend application from scratch to production in one go. The developer will work live on a Hostinger VPS (KVM 4) with full access until the app is finished and tested. Structure must be clean (e.g. MVC), not overcomplicated, so a human developer can maintain and extend it later. Use strong, well-known tools; research and reference official docs where needed.

**Scope:** Backend only (REST API). This API **serves three clients**: (1) **Customer mobile app**, (2) **Vendor mobile app**, (3) **Super Admin dashboard** (web). No frontend or mobile app code in this prompt; implement the API so all three clients can consume it with clear role-based access and scenarios (see Section 2.1 and 2.2).

---

## Table of Contents

1. [Role & Context](#1-role--context)
2. [Project Summary from BRD](#2-project-summary-from-brd)
   - [2.1 API Consumers: Three Clients](#21-api-consumers-three-clients-mandatory)
   - [2.2 Logical Cases and Scenarios per Client](#22-logical-cases-and-scenarios-per-client)
3. [Tech Stack (Mandatory)](#3-tech-stack-mandatory)
4. [Architecture & Folder Structure](#4-architecture--folder-structure)
5. [Environment & Configuration](#5-environment--configuration)
6. [Database Schema (PostgreSQL + Prisma)](#6-database-schema-postgresql--prisma)
7. [Authentication & Authorization](#7-authentication--authorization)
8. [API Modules & Endpoints](#8-api-modules--endpoints)
9. [Business Rules (Implementation Notes)](#9-business-rules-implementation-notes)
10. [Manual Shipping Flow (No External API)](#10-manual-shipping-flow-no-external-api)
   - [10.5 Mega Technology Shipping API Integration](#105-mega-technology-shipping-api-integration)
11. [Security (Server & Application)](#11-security-server--application)
12. [File Upload (Vendor Documents & Product Images)](#12-file-upload-vendor-documents--product-images)
13. [Payments (Visa Placeholder & COD)](#13-payments-visa-placeholder--cod)
14. [Loyalty & Points](#14-loyalty--points)
15. [Reports (Dashboard & Excel)](#15-reports-dashboard--excel)
16. [Coupons](#16-coupons)
17. [Testing & Quality](#17-testing--quality)
18. [Deployment (Hostinger VPS)](#18-deployment-hostinger-vps)
19. [Pre-Launch Checklist](#19-pre-launch-checklist)
20. [References & Research](#20-references--research)

---

## 1. Role & Context

You are a **Senior Backend Developer** specializing in **Node.js**, using **Cursor** with **Opus 4.6**. Your task is to implement the full backend for **Dar Alabaya** (multi-vendor Abaya marketplace) in one continuous effort until it is production-ready and tested.

- **Output:** A single Node.js backend (REST API) that can run on a Hostinger VPS, with clear MVC-style structure, full BRD coverage, and no unnecessary complexity.
- **Tools:** Use official docs and web search when needed for libraries, security, and deployment. Prefer battle-tested packages (Express, Prisma, Zod, etc.).
- **Database:** PostgreSQL only. Use Prisma for schema, migrations, and queries.
- **Language:** TypeScript for the entire backend.
- **Deployment target:** Hostinger VPS (KVM 4), Ubuntu (or similar Linux). You will configure Node, PM2, Nginx, and basic server hardening.

---

## 2. Project Summary from BRD

- **Product:** Multi-vendor marketplace for selling **Abayas** (عبايات). Supports **retail** and **wholesale** (MOQ-based).
- **Actors:** Customers, Vendors (sellers), Platform Admin, Shipping companies (no API – manual handover and delivery).
- **Revenue:** Platform commission (default 5%, configurable by admin).
- **Payment methods:** Visa/online payment, Cash on Delivery (COD).
- **Shipping:** Manual. Vendor gives order to shipping company; shipping company delivers and collects COD if applicable. No integration with shipping API.
- **Returns:** Within 48 hours of receiving the order, under conditions (no defect; product in original state with labels; customer may pay return shipping).
- **Loyalty:** Points earned after delivery and after return window (e.g. 48h) expires. Points usable as discount (cap set by admin, e.g. max 25% of product price). Points cancelled on return.
- **Settlement:** COD collected by shipping company; settlement cycle (daily/weekly/custom) with platform. Vendor balance and payout requests; one payout day per week (configurable).
- **Reports:** Dashboard metrics + Excel exports (Orders, Payments, COD Collection, Vendor Earnings, Refunds, Wholesale separate).

### 2.1 API Consumers: Three Clients (Mandatory)

The backend **serves exactly three clients**. Every endpoint, auth rule, and scenario must account for which client is calling. Implement and test with these three in mind.

| Client | Description | Auth | Primary use |
|--------|-------------|------|-------------|
| **Customer Mobile App** | End-users (buyers) browsing and ordering Abayas. | JWT with role `CUSTOMER`. Register with phone + email + OTP. | Browse products, cart, place order, track order, returns, loyalty points. |
| **Vendor Mobile App** | Sellers (shop owners) managing products and orders. | JWT with role `VENDOR`. Register with docs; access only after admin approval (`APPROVED`). | Products CRUD, orders (accept/reject/status), balance, payout requests. |
| **Super Admin Dashboard** | Platform owner (web dashboard). | JWT with role `ADMIN`. No public registration; first admin via seed. | Vendor approval, commission, orders/returns/payouts oversight, coupons, settings, all reports (Dashboard + Excel). |

- **Single API base:** One REST API base URL; all three clients call the same host. Use **role-based access** (middleware) so each client can only call its allowed routes.
- **CORS:** Allow origins for (1) customer app origin, (2) vendor app origin, (3) admin dashboard origin (e.g. `https://admin.daralabaya.com`). Configure via env (e.g. `CORS_ORIGINS`).
- **Auth:** Same JWT mechanism for all (access + refresh). Payload includes `role`; middleware restricts routes by role (e.g. `/api/vendors/me/*` only for `VENDOR`, `/api/admin/*` only for `ADMIN`, `/api/orders/me` only for `CUSTOMER`).
- **Mobile vs Web:** Customer and Vendor apps are mobile (may use Bearer token in header; refresh token in secure storage). Admin is web (can use httpOnly cookie for refresh if same-origin). API should support both: accept `Authorization: Bearer <access>` and optionally accept refresh via cookie or body for `/api/auth/refresh`.

### 2.2 Logical Cases and Scenarios per Client

Implement and handle the following scenarios. Each list covers happy paths and edge cases so the backend behaves correctly for all three clients.

---

#### A. Customer Mobile App – Scenarios

| # | Scenario | Endpoint(s) / logic | Success / edge handling |
|---|----------|---------------------|--------------------------|
| 1 | Register as customer | `POST /api/auth/register` (role=CUSTOMER) | 201; send OTP. Reject if email/phone already exists (409). |
| 2 | Send OTP (register or login) | `POST /api/auth/send-otp` | 200; rate-limit per phone/email (e.g. 5/15min). Invalid purpose → 400. |
| 3 | Verify OTP | `POST /api/auth/verify-otp` | 200; mark OTP used; optionally return tokens or require password next. Expired OTP → 400. |
| 4 | Login | `POST /api/auth/login` | 200 + access + refresh. Invalid credentials → 401. Inactive user → 403. |
| 5 | Refresh token | `POST /api/auth/refresh` | 200 + new access + new refresh; revoke old refresh. Invalid/expired refresh → 401. |
| 6 | Logout | `POST /api/auth/logout` | 200; revoke refresh token. |
| 7 | Get my profile | `GET /api/users/me` | 200 + customer profile. 401 if not logged in. |
| 8 | Update profile (name, address) | `PATCH /api/users/me` | 200. Validate body with Zod. |
| 9 | List / add / update / delete addresses | `GET/POST/PATCH/DELETE /api/users/me/addresses` | 200; customer can only see/edit own addresses. |
| 10 | Browse products (list) | `GET /api/products` (public or with optional auth) | 200; **exclude products with stockQuantity = 0**. Filters: category, vendor, search, price range, pagination. |
| 11 | Product detail | `GET /api/products/:id` | 200; 404 if not found or out of stock. Show retail price, wholesale price, MOQ. |
| 12 | Add to cart | `POST /api/cart/items` (productId, quantity) | 201; validate quantity >= product.moq and quantity <= stock; 400 if not. Create cart if missing. |
| 13 | Update cart item quantity | `PATCH /api/cart/items/:id` | 200; same validation (moq, stock). 404 if item not in cart. |
| 14 | Remove cart item | `DELETE /api/cart/items/:id` | 200. |
| 15 | Get cart | `GET /api/cart` | 200; for each item compute unit price (retail vs wholesale by quantity >= MOQ); show “wholesale applied” where relevant. |
| 16 | Validate coupon | `POST /api/coupons/validate` (code, orderAmount) | 200 + discount amount or 400 if invalid/expired/max uses/min order not met. |
| 17 | Place order | `POST /api/orders` (address, paymentMethod, couponCode?, pointsToRedeem?) | 201; validate cart, stock, MOQ, coupon, points cap. COD → order created with payment PENDING; Visa → stub payment then confirm. Clear cart items that were ordered. 400 if cart empty or validation fails. 409 if stock changed. |
| 18 | List my orders | `GET /api/orders/me` | 200; filter by status, date; pagination. Only own orders. |
| 19 | Order detail | `GET /api/orders/me/:orderId` | 200; 404 if not own order. Include status history for tracking. |
| 20 | Order tracking (status timeline) | `GET /api/orders/me/:orderId/tracking` or inside order detail | 200; return OrderStatusHistory (PENDING → … → DELIVERED). |
| 21 | Request return | `POST /api/returns` (orderId, reason) | 201; validate: order is DELIVERED, within 48h of deliveredAt, no existing approved/pending return for same order. 400 if outside window or already returned. |
| 22 | List my return requests | `GET /api/returns/me` | 200. |
| 23 | Return detail | `GET /api/returns/me/:id` | 200; 404 if not own. |
| 24 | Loyalty: balance and history | `GET /api/loyalty/me` | 200; points balance + recent transactions. |
| 25 | Loyalty: eligibility (how many points for amount) | `GET /api/loyalty/me/eligibility` or in checkout payload | Explain earning (after delivery + return window) and redemption cap. |
| 26 | Edge: product went out of stock between add-to-cart and checkout | In `POST /api/orders` re-check stock; reject with 409 or 400 and clear message. | |
| 27 | Edge: order already cancelled / completed return | Cannot request return again; 400. | |
| 28 | Edge: points redemption exceeds cap or balance | In `POST /api/orders` validate pointsToRedeem <= cap and <= balance; 400 if not. | |

---

#### B. Vendor Mobile App – Scenarios

| # | Scenario | Endpoint(s) / logic | Success / edge handling |
|---|----------|---------------------|--------------------------|
| 1 | Register as vendor | `POST /api/auth/register` (role=VENDOR, businessName, documents) | 201; create user + VendorProfile status=PENDING; send OTP. 409 if email/phone exists. |
| 2 | Login (before approval) | `POST /api/auth/login` | 200 + tokens. Vendor can login but restricted: e.g. block access to products/orders until APPROVED (403 or dedicated message). |
| 3 | Login (after approval) | Same | Full access to vendor routes. |
| 4 | Get my profile & status | `GET /api/vendors/me` | 200; include status (PENDING/APPROVED/REJECTED/SUSPENDED). Dashboard can show “waiting approval” or “rejected (reason)”. |
| 5 | Update business info | `PATCH /api/vendors/me` | 200; no document re-upload in this flow unless specified. |
| 6 | List my products | `GET /api/vendors/me/products` | 200; all products (including out of stock); pagination. |
| 7 | Create product | `POST /api/vendors/me/products` (multipart: images) | 201; validate MOQ, retailPrice, wholesalePrice, stock. Only APPROVED vendor. |
| 8 | Update product | `PATCH /api/vendors/me/products/:id` | 200; 404 if not own product. Validate stock >= 0. |
| 9 | Delete / deactivate product | `DELETE /api/vendors/me/products/:id` | 200; 404 if not own. |
| 10 | List my orders | `GET /api/vendors/me/orders` | 200; only orders that contain this vendor’s items; filter by status, date. |
| 11 | Order detail (vendor view) | From list or `GET /api/vendors/me/orders/:orderId` if you expose it | 200; only if order has items from this vendor; include items, status, customer shipping info (as needed). |
| 12 | Accept order | `POST /api/vendors/me/orders/:orderId/accept` | 200; **only if** payment is COD or payment not yet PAID. If Visa and PAID → 403/400 “Cannot reject paid order”. Transition PENDING → CONFIRMED. |
| 13 | Reject order | `POST /api/vendors/me/orders/:orderId/reject` | 200; **only if** COD or unpaid. If Visa paid → 403. Transition PENDING → REJECTED. |
| 14 | Update order status (manual shipping) | `POST /api/vendors/me/orders/:orderId/status` (status=PREPARING \| HANDED_TO_SHIPPING \| IN_DELIVERY) | 200; validate order belongs to vendor (via items); validate allowed transition (e.g. CONFIRMED → HANDED_TO_SHIPPING). 400 if invalid transition. Append OrderStatusHistory. |
| 15 | View balance | `GET /api/vendors/me/balance` | 200; availableBalance, pendingBalance (COD not yet collected). |
| 16 | List payout requests | `GET /api/vendors/me/payouts` | 200; own payouts only. |
| 17 | Request payout | `POST /api/vendors/me/payouts` (amount) | 201; validate amount <= availableBalance; optional: only on payout day (configurable). 400 if insufficient balance or not payout day. |
| 18 | Edge: vendor suspended | All vendor write routes | 403 “Account suspended”. |
| 19 | Edge: vendor rejected | Login allowed; vendor routes (products, orders) | 403 “Vendor account not approved” with rejection reason if stored. |
| 20 | Edge: update status for order that has another vendor’s items | If order is multi-vendor, vendor can only update “their” part or you treat order as single-status; ensure vendor can only update orders that contain their items. | 403 if order has no items for this vendor. |

---

#### C. Super Admin Dashboard – Scenarios

| # | Scenario | Endpoint(s) / logic | Success / edge handling |
|---|----------|---------------------|--------------------------|
| 1 | Admin login | `POST /api/auth/login` (admin email/password) | 200 + tokens. Only users with role ADMIN. 401 if wrong credentials. |
| 2 | No public admin registration | — | No `POST /api/auth/register` for ADMIN; admin created via seed or internal script. |
| 3 | List pending vendors | `GET /api/admin/vendors/pending` | 200; vendors with status PENDING. |
| 4 | Approve vendor | `POST /api/admin/vendors/:id/approve` | 200; set status=APPROVED, approvedAt, approvedBy. 404 if not found; 400 if not PENDING. |
| 5 | Reject vendor | `POST /api/admin/vendors/:id/reject` (body: reason) | 200; set status=REJECTED, rejectionReason. 404/400 as above. |
| 6 | Set commission rate | `PATCH /api/admin/commission` (rate) | 200; create new CommissionConfig row (effectiveFrom=now). |
| 7 | List all orders | `GET /api/admin/orders` | 200; filters: status, dateFrom, dateTo, vendorId; pagination. |
| 8 | Order detail (admin) | `GET /api/admin/orders/:id` or from list | 200; full order + items + status history. |
| 9 | Set order status (e.g. DELIVERED) | `PATCH /api/admin/orders/:id/status` (status, deliveredAt?, note?) | 200; validate transition; if DELIVERED set deliveredAt. Used for manual shipping when admin confirms delivery. |
| 10 | List return requests | `GET /api/admin/returns` | 200; filter by status; pagination. |
| 11 | Approve return | `POST /api/admin/returns/:id/approve` | 200; set return status APPROVED; process refund (if any); deduct loyalty points for that order; update order/refund state. 400 if already processed. |
| 12 | Reject return | `POST /api/admin/returns/:id/reject` | 200; set return status REJECTED. |
| 13 | List payout requests | `GET /api/admin/payouts` | 200; all vendors’ payout requests; filter by status. |
| 14 | Process payout | `POST /api/admin/payouts/:id/process` | 200; set PayoutRequest status=PROCESSED; decrement VendorBalance.available; update totalWithdrawn, lastPayoutAt. 400 if already processed or insufficient balance. |
| 15 | List coupons | `GET /api/admin/coupons` | 200; pagination. |
| 16 | Create coupon | `POST /api/admin/coupons` | 201; validate code unique, dates, value, applicableTo. |
| 17 | Update coupon | `PATCH /api/admin/coupons/:id` | 200; 404 if not found. Do not allow usedCount > maxUses after update. |
| 18 | Delete / deactivate coupon | `DELETE /api/admin/coupons/:id` | 200; soft delete or set isActive=false. |
| 19 | Get settings | `GET /api/admin/settings` | 200; return default commission, return window hours, points redemption cap %, payout day, etc. |
| 20 | Update settings | `PATCH /api/admin/settings` | 200; persist to DB or config table. |
| 21 | Dashboard report (JSON) | `GET /api/reports/dashboard` | 200; aggregates: total orders, sales, commission, vendor payables, COD to collect, status counts, return/cancel counts; optional date range. **Admin only.** |
| 22 | Excel: Orders | `GET /api/reports/orders/excel` | 200; stream Excel file. Admin only; optional date filter. |
| 23 | Excel: Payments | `GET /api/reports/payments/excel` | 200; stream. Admin only. |
| 24 | Excel: COD collection | `GET /api/reports/cod-collection/excel` | 200; stream. Admin only. |
| 25 | Excel: Vendor earnings | `GET /api/reports/vendor-earnings/excel` | 200; stream; optional vendorId. Admin only. |
| 26 | Excel: Refunds | `GET /api/reports/refunds/excel` | 200; stream. Admin only. |
| 27 | Excel: Wholesale (separate or filter) | As per BRD, support separate report for wholesale orders | Admin only; filter or separate sheet. |
| 28 | Edge: non-admin calls admin endpoint | Any `/api/admin/*` | 403 Forbidden. |
| 29 | Edge: admin calls customer/vendor “me” endpoints | e.g. GET /api/orders/me | Design: admin may have no “me” orders; or block admin from customer/vendor routes (403). Prefer strict: admin only uses /api/admin/* and /api/reports/*. |

---

#### D. Cross-Client and Shared Cases

| # | Scenario | Logic |
|---|----------|--------|
| 1 | Public product listing | `GET /api/products` is callable **without auth** (or with optional auth). Same response for all clients. Enforce stockQuantity > 0. |
| 2 | Product detail public | `GET /api/products/:id` public; 404 if out of stock. |
| 3 | Health check | `GET /health` or `GET /api/health` no auth; for load balancer/monitoring. |
| 4 | CORS preflight | All three origins allowed for API; credentials if using cookies. |
| 5 | Rate limit | Apply per IP (and optionally per user after auth). Stricter on auth routes (login, send-otp) to prevent abuse. |
| 6 | Same user cannot be customer and vendor | Unless BRD allows dual role: one user one role. Register with single role; no “switch role” in this prompt. |
| 7 | Vendor sees only own orders | Filter orders by order items’ vendorId = current vendor. Admin sees all. Customer sees only own orders. |

Ensure every endpoint is assigned to exactly one client type (or public) and that role middleware enforces it. Document in code or README which routes serve which client (Customer App / Vendor App / Admin Dashboard).

---

## 3. Tech Stack (Mandatory)

Use exactly the following stack. Do not replace with alternatives unless a package is deprecated or insecure.

| Layer | Technology | Version / Notes |
|-------|------------|-----------------|
| Runtime | Node.js | LTS (20.x or 22.x). Use `nvm` or system Node on server. |
| Language | TypeScript | Strict mode. Target ES2022+. |
| HTTP Framework | Express | `express` – widely used, easy to maintain. |
| ORM / DB | Prisma | `prisma` + `@prisma/client`. PostgreSQL only. |
| Database | PostgreSQL | 15+ recommended. Single instance for this project. |
| Validation | Zod | `zod` – all request body/query/params validation. |
| Authentication | JWT | Access token (short-lived, e.g. 15 min) + Refresh token (longer, e.g. 7 days). Refresh stored in DB; access can be in memory or cookie. Prefer **httpOnly cookie** for refresh and **Bearer** for access in API calls. |
| Password hashing | bcrypt | `bcrypt` (or `bcryptjs` if native issues on host). |
| Security headers | Helmet | `helmet`. |
| CORS | cors | `cors` – restrict to allowed origins from env. |
| Rate limiting | express-rate-limit | In-memory for single instance; optional Redis store if you add Redis later. |
| File upload | Multer | `multer` – local disk storage; sanitize filenames, limit size and type. |
| Excel export | ExcelJS | `exceljs` – for all Excel reports. |
| Logging | Pino | `pino` + `pino-pretty` (dev). Structured logs. |
| Env config | dotenv | `dotenv`. Use a small config module that validates required env vars at startup. |
| OTP / SMS | Pluggable | Abstract interface (e.g. `sendOTP(phone, code)`). Implement one provider: Twilio, or Akedly, or a mock that logs OTP in dev. Env-based. |
| Payment (online) | Pluggable | Abstract interface for “create payment”, “verify/callback”, “refund”. Implement a stub that returns success for testing; document where to plug Fawry/Visa/etc. |
| Process manager | PM2 | On server: run app with PM2 in cluster mode. |
| Reverse proxy | Nginx | In front of Node; SSL termination, proxy to Node port. |
| SSL | Let's Encrypt | Certbot for free SSL on the domain. |

Optional for v1 (can add later):

- **Redis:** Sessions, rate-limit store, cache. Not required for initial launch.
- **S3-compatible storage:** For vendor documents and product images; start with local `uploads/` and design so switching to S3 is a config change + adapter.

---

## 4. Architecture & Folder Structure

Use a clear **MVC-style** layout. Controllers handle HTTP, services contain business logic, Prisma handles data access. Keep routes thin.

```
backend/
├── src/
│   ├── config/
│   │   ├── index.ts          # Load env, validate, export config
│   │   └── constants.ts     # App constants (roles, order statuses, etc.)
│   ├── middleware/
│   │   ├── auth.ts           # JWT verify, attach user to request
│   │   ├── validate.ts       # Zod schema runner
│   │   ├── upload.ts         # Multer configs (documents, images)
│   │   ├── errorHandler.ts   # Global error handler
│   │   └── rateLimit.ts      # Rate limit config
│   ├── routes/
│   │   ├── index.ts          # Mount all routes
│   │   ├── auth.routes.ts
│   │   ├── users.routes.ts
│   │   ├── vendors.routes.ts
│   │   ├── products.routes.ts
│   │   ├── cart.routes.ts
│   │   ├── orders.routes.ts
│   │   ├── returns.routes.ts
│   │   ├── loyalty.routes.ts
│   │   ├── reports.routes.ts
│   │   ├── coupons.routes.ts
│   │   ├── admin.routes.ts
│   │   └── webhooks.routes.ts   # e.g. Mega shipping status (POST /api/webhooks/mega-shipping)
│   ├── controllers/
│   │   ├── auth.controller.ts
│   │   ├── users.controller.ts
│   │   ├── vendors.controller.ts
│   │   ├── products.controller.ts
│   │   ├── cart.controller.ts
│   │   ├── orders.controller.ts
│   │   ├── returns.controller.ts
│   │   ├── loyalty.controller.ts
│   │   ├── reports.controller.ts
│   │   ├── coupons.controller.ts
│   │   └── admin.controller.ts
│   ├── services/
│   │   ├── auth.service.ts
│   │   ├── otp.service.ts
│   │   ├── users.service.ts
│   │   ├── vendors.service.ts
│   │   ├── products.service.ts
│   │   ├── cart.service.ts
│   │   ├── orders.service.ts
│   │   ├── commission.service.ts
│   │   ├── returns.service.ts
│   │   ├── loyalty.service.ts
│   │   ├── reports.service.ts
│   │   ├── excel.service.ts
│   │   ├── coupons.service.ts
│   │   └── admin.service.ts
│   ├── validators/
│   │   ├── auth.validator.ts
│   │   ├── users.validator.ts
│   │   ├── vendors.validator.ts
│   │   ├── products.validator.ts
│   │   ├── cart.validator.ts
│   │   ├── orders.validator.ts
│   │   ├── returns.validator.ts
│   │   ├── loyalty.validator.ts
│   │   ├── coupons.validator.ts
│   │   └── admin.validator.ts
│   ├── utils/
│   │   ├── errors.ts         # Custom error classes (AppError, 4xx/5xx)
│   │   ├── logger.ts         # Pino instance
│   │   └── helpers.ts        # Generic helpers
│   ├── types/
│   │   └── express.d.ts      # Extend Request (user, role, etc.)
│   ├── prisma/
│   │   ├── schema.prisma
│   │   └── migrations/
│   └── app.ts                # Express app setup (middleware, routes)
├── uploads/                  # Local uploads (gitignore); or mount volume
├── scripts/                  # Optional: seed, migrations, deploy
├── tests/
│   ├── integration/
│   └── unit/
├── .env.example
├── .env                      # Not in git
├── .gitignore
├── package.json
├── tsconfig.json
└── README.md
```

- **Routes:** Only parse request, call controller, send response. No business logic.
- **Controllers:** Call one or more services, map result to HTTP status and JSON. Handle only HTTP concerns.
- **Services:** All business logic, transactions, calls to Prisma. Reusable and testable without HTTP.
- **Validators:** Zod schemas; middleware runs them and attaches parsed data to `req` (e.g. `req.body` replaced with validated body).

---

## 5. Environment & Configuration

- **Required env vars (validate at startup):**
  - `NODE_ENV` (development | production | test)
  - `PORT`
  - `DATABASE_URL` (PostgreSQL connection string)
  - `JWT_ACCESS_SECRET`, `JWT_REFRESH_SECRET` (strong, random)
  - `JWT_ACCESS_EXPIRY` (e.g. 15m), `JWT_REFRESH_EXPIRY` (e.g. 7d)
  - `CORS_ORIGINS` (comma-separated origins)
  - `OTP_PROVIDER` (twilio | akedly | mock), and provider-specific keys if not mock
  - `UPLOAD_PATH` (default `./uploads`)
  - `DEFAULT_COMMISSION_RATE` (e.g. 0.05 for 5%)
- **Optional:** `REDIS_URL` (if you add Redis later), `PAYMENT_CALLBACK_URL`, payment API keys.

Create `src/config/index.ts` that loads `dotenv`, validates required vars (e.g. with Zod), and exports a single `config` object. Fail fast if something is missing.

---

## 6. Database Schema (PostgreSQL + Prisma)

Define the following in `schema.prisma`. Use clear naming (snake_case in DB if you prefer, or camelCase with `@map`). Include indexes for frequent queries (user_id, vendor_id, order status, created_at, etc.).

### 6.1 Core Entities

- **User**
  - id, email, phone, passwordHash, role (CUSTOMER | VENDOR | ADMIN), emailVerified, phoneVerified, isActive, createdAt, updatedAt.
  - One-to-one with CustomerProfile and VendorProfile when role is CUSTOMER or VENDOR.

- **CustomerProfile**
  - id, userId (unique), fullName, defaultShippingAddress (JSON or separate table), createdAt, updatedAt.

- **VendorProfile**
  - id, userId (unique), businessName, status (PENDING | APPROVED | REJECTED | SUSPENDED), documentUrls (JSON or separate table for national_id, commercial_registry, tax_card), rejectionReason, approvedAt, approvedBy (admin user id), createdAt, updatedAt.

- **Product**
  - id, vendorId, name, description, slug (unique per vendor or global), categoryId (optional), retailPrice, wholesalePrice, moq (minimum order quantity), stockQuantity, sku (optional), isActive, createdAt, updatedAt. Ensure products with stockQuantity = 0 are not listed in public listing (filter in API).

- **ProductImage**
  - id, productId, url (path or full URL), sortOrder.

- **Category** (optional but useful)
  - id, name, slug, parentId (self-relation for tree).

- **Cart**
  - id, userId (customer), updatedAt. One cart per user.

- **CartItem**
  - id, cartId, productId, quantity. Validate quantity >= product.moq when adding; when quantity >= product.moq use wholesale price in calculations.

- **Order**
  - id, orderNumber (unique, human-readable), customerId, status (see status enum below), paymentMethod (VISA | COD), paymentStatus (PENDING | PAID | REFUNDED | FAILED), totalAmount, platformCommissionAmount, vendorEarningsAmount, shippingAddress (JSON), shippingPhone, codAmount (if COD), visaTransactionId (nullable), createdAt, updatedAt, deliveredAt (nullable), vendorId (denormalized or from order items – ensure you can filter orders by vendor).
  - **Optional (Mega Technology integration):** shippingWaybill (string, nullable), shippingQrCode (string, nullable), shippingProvider (string, nullable, e.g. "mega"). When Mega is used, store waybill and optionally qr_code from Add Bulk Shipments response; use waybill for webhook mapping and for Get Status History / Get Current Status.

- **OrderItem**
  - id, orderId, productId, productSnapshot (name, price, quantity, unitPrice at time of order), quantity, unitPrice, totalPrice, vendorId (for per-vendor order splitting).

- **OrderStatusHistory**
  - id, orderId, status, note (optional), createdBy (user id), createdAt. Use this for manual shipping updates: when status changes to handed_to_shipping, in_delivery, delivered, etc.

- **ReturnRequest**
  - id, orderId, customerId, reason, status (PENDING | APPROVED | REJECTED), refundAmount, returnShippingCost (paid by customer if applicable), approvedAt, reviewedBy, createdAt, updatedAt.

- **VendorBalance**
  - id, vendorId (unique), availableBalance, pendingBalance (COD not yet collected), totalEarned, totalWithdrawn, lastPayoutAt, createdAt, updatedAt.

- **PayoutRequest**
  - id, vendorId, amount, status (PENDING | PROCESSED | REJECTED), processedAt, processedBy, note, createdAt.

- **LoyaltyPoints**
  - id, userId (customer), pointsBalance, totalEarned, totalSpent, createdAt, updatedAt.

- **PointsTransaction**
  - id, userId, orderId (nullable), pointsDelta (+ or -), reason (PURCHASE | RETURN_DEDUCT | REDEMPTION | ADMIN_ADJUST), createdAt.

- **CommissionConfig**
  - id, rate (decimal, e.g. 0.05), effectiveFrom, effectiveTo (nullable), createdAt. Admin can create new rows for new rate; use the one effective at order time.

- **Coupon**
  - id, code (unique), type (PERCENTAGE | FIXED_AMOUNT), value, minOrderAmount (optional), maxUses (nullable), usedCount, validFrom, validTo, isActive, createdBy (admin), applicableTo (ALL | SPECIFIC_VENDORS | SPECIFIC_PRODUCTS), applicableIds (JSON), createdAt, updatedAt.

- **CouponUse**
  - id, couponId, orderId, userId, discountAmount, createdAt.

- **OTP**
  - id, phoneOrEmail, code, purpose (REGISTER | LOGIN | RESET), expiresAt, usedAt (nullable), createdAt.

- **RefreshToken**
  - id, userId, token (hashed or value), expiresAt, revokedAt (nullable), createdAt.

### 6.2 Order Status Enum (Manual Shipping)

Use an enum or string literal union:

- `PENDING` – Order placed, waiting vendor confirmation.
- `CONFIRMED` – Vendor confirmed (for COD: not yet paid; for Visa: paid).
- `REJECTED` – Vendor rejected (only allowed for COD or if not yet paid).
- `PREPARING` – Vendor preparing (optional).
- `HANDED_TO_SHIPPING` – Vendor handed order to shipping company (manual step).
- `IN_DELIVERY` – Shipping company has order, in transit (manual update).
- `DELIVERED` – Customer received.
- `RETURN_REQUESTED` – Customer requested return within 48h.
- `RETURN_APPROVED` / `RETURN_REJECTED` – Admin/vendor decision.
- `RETURNED` – Product returned; refund processed if applicable.
- `CANCELLED` – Order cancelled.

Business rule: If payment is VISA and paid, vendor **cannot** reject. Only for COD or unpaid orders can vendor reject.

### 6.3 Indexes (Prisma)

Add indexes in schema for:

- User: email, phone, role.
- Product: vendorId, isActive, stockQuantity (for “in stock” listing), slug.
- Order: customerId, vendorId (if you store it), status, createdAt, orderNumber.
- OrderItem: orderId, vendorId.
- ReturnRequest: orderId, status.
- VendorBalance: vendorId.
- PayoutRequest: vendorId, status.
- LoyaltyPoints: userId.
- PointsTransaction: userId, orderId, createdAt.
- Coupon: code, isActive, validFrom, validTo.
- OTP: phoneOrEmail, purpose, expiresAt.
- RefreshToken: userId, token (if you store token value for lookup).

---

## 7. Authentication & Authorization

### 7.1 Registration / Login

- **Customer:** Register with mobile + email. Send OTP to phone (and optionally email). Verify OTP then set password (or passwordless with OTP only – your choice; BRD says “تسجيل حساب (موبايل + Email)”).
- **Vendor:** Register with same identity fields plus business info. Upload documents (national_id, commercial_registry, tax_card). Status = PENDING until admin approves.
- **Admin:** Created by seed or first-user script; no public registration.

### 7.2 JWT Strategy

- **Access token:** Short-lived (e.g. 15 min), payload: `{ userId, role, email }`. Sent in `Authorization: Bearer <token>`.
- **Refresh token:** Long-lived (e.g. 7 days), stored in DB (and optionally in httpOnly cookie). When client sends refresh token, issue new access + new refresh (rotation); invalidate old refresh.
- Use separate secrets for access and refresh. Sign with HS256 or RS256; verify algorithm in middleware.

### 7.3 Roles & Middleware

- Middleware `requireAuth`: verify access token, attach `req.user` (id, role, email).
- Middleware `requireRole('VENDOR' | 'ADMIN' | 'CUSTOMER')`: after requireAuth, check role.
- Protect routes: e.g. vendor routes require VENDOR and optionally check vendor status = APPROVED; admin routes require ADMIN.

### 7.4 Password & OTP

- Hash passwords with bcrypt (rounds >= 10).
- OTP: 4–6 digits, expiry e.g. 10 minutes. Store hashed or plain in OTP table; delete or mark used after successful verification. Use the pluggable OTP service (Twilio/Akedly/mock).

---

## 8. API Modules & Endpoints

Implement the following modules. Use REST conventions; return JSON; use consistent response shape (e.g. `{ success, data?, message?, error? }`). Use Zod-validated bodies and params.

### 8.1 Auth

- `POST /api/auth/register` – Body: email, phone, password, role (CUSTOMER | VENDOR). If VENDOR, include businessName and document files (multipart). Create user + profile; if vendor, set status PENDING. Send OTP.
- `POST /api/auth/send-otp` – Body: phone or email, purpose (REGISTER | LOGIN). Send OTP.
- `POST /api/auth/verify-otp` – Body: phone or email, code. Mark OTP used; optionally issue tokens or require password next.
- `POST /api/auth/login` – Body: email or phone, password. Return access + refresh tokens.
- `POST /api/auth/refresh` – Body or cookie: refresh token. Return new access + refresh; revoke old refresh.
- `POST /api/auth/logout` – Body: refresh token (or from cookie). Revoke refresh token.
- `POST /api/auth/forgot-password` – Send OTP for reset.
- `POST /api/auth/reset-password` – Body: token (OTP or one-time link), new password.

### 8.2 Users (Customer profile)

- `GET /api/users/me` – Current user profile (customer or vendor).
- `PATCH /api/users/me` – Update profile (name, default address, etc.).
- `GET /api/users/me/addresses` – List addresses.
- `POST /api/users/me/addresses` – Add address.
- `PATCH /api/users/me/addresses/:id` – Update address.
- `DELETE /api/users/me/addresses/:id` – Delete address.

### 8.3 Vendors

- `GET /api/vendors/me` – Vendor profile + status.
- `PATCH /api/vendors/me` – Update business info (no document re-upload unless you define a flow).
- `GET /api/vendors/me/balance` – Balance (available, pending).
- `GET /api/vendors/me/orders` – Orders for this vendor (with filters: status, date).
- `POST /api/vendors/me/orders/:orderId/accept` – Accept order (if allowed by business rule).
- `POST /api/vendors/me/orders/:orderId/reject` – Reject order (only COD or unpaid).
- `POST /api/vendors/me/orders/:orderId/status` – Update order status (e.g. HANDED_TO_SHIPPING, IN_DELIVERY). This is the **manual shipping** update: vendor or admin sets status when they hand to shipping or when shipping company notifies them.
- `GET /api/vendors/me/payouts` – List payout requests.
- `POST /api/vendors/me/payouts` – Create payout request (only on payout day if you enforce it; or allow request and process weekly).

### 8.4 Products

- `GET /api/products` – Public listing. Query: vendorId?, categoryId?, search?, minPrice?, maxPrice?, page, limit. **Exclude products where stockQuantity = 0.**
- `GET /api/products/:id` – Public detail by id or slug. 404 if out of stock.
- `GET /api/vendors/me/products` – Vendor’s own products (all).
- `POST /api/vendors/me/products` – Create product (multipart: images). Validate MOQ, retailPrice, wholesalePrice.
- `PATCH /api/vendors/me/products/:id` – Update product.
- `DELETE /api/vendors/me/products/:id` – Soft delete or hard delete (your choice).

### 8.5 Cart

- `GET /api/cart` – Get current user’s cart with items; for each item compute unit price (retail vs wholesale based on quantity >= product.moq) and show “wholesale applied” if applicable.
- `POST /api/cart/items` – Add item (productId, quantity). Validate quantity >= product.moq; check stock.
- `PATCH /api/cart/items/:id` – Update quantity.
- `DELETE /api/cart/items/:id` – Remove item.
- `DELETE /api/cart` – Clear cart.

### 8.6 Orders

- `POST /api/orders` – Create order from cart. Body: shippingAddressId or inline address, paymentMethod (VISA | COD). Calculate totals, platform commission, vendor earnings. If VISA, call payment stub and return payment URL or success; if COD, create order with paymentStatus PENDING. Lock stock; clear cart items that were ordered.
- `GET /api/orders/me` – Customer’s orders (with status filter).
- `GET /api/orders/me/:orderId` – Order detail (customer).
- `GET /api/orders/me/:orderId/tracking` – Order status history (for “متابعة حالة الطلب”).

### 8.7 Returns

- `POST /api/returns` – Create return request. Body: orderId, reason. Validate: order status = DELIVERED; deliveredAt within last 48 hours (configurable); order not already returned.
- `GET /api/returns/me` – Customer’s return requests.
- `GET /api/returns/me/:id` – Return request detail.

### 8.8 Loyalty

- `GET /api/loyalty/me` – Current user’s points balance and history (or last N transactions).
- `GET /api/loyalty/me/eligibility` – Explain how many points will be earned for an amount (e.g. 1 EGP = 1 point; points added after delivery + return window).
- Apply points at checkout: in `POST /api/orders` accept optional `pointsToRedeem`; validate against max allowed (admin-configured % of product/subtotal, e.g. max 25%); deduct points and reduce order total.

### 8.9 Reports (Dashboard + Excel)

- `GET /api/reports/dashboard` – Aggregates: total orders, total sales, platform commissions, vendor payables, COD to be collected, counts by order status, return/cancel counts. Optional query: dateFrom, dateTo.
- `GET /api/reports/orders/excel` – Excel export: orders in date range (columns: order number, date, customer, status, total, payment method, etc.).
- `GET /api/reports/payments/excel` – Payments report.
- `GET /api/reports/cod-collection/excel` – COD collection report.
- `GET /api/reports/vendor-earnings/excel` – Per-vendor earnings (optional query: vendorId).
- `GET /api/reports/refunds/excel` – Refunds/returns report.
- Support separate filters or sheets for wholesale vs retail if needed (BRD: “Support separate reports for wholesale orders”).

### 8.10 Coupons

- `POST /api/coupons/validate` – Body: code, orderAmount (or cart total). Return validity and discount amount (for display). Used at checkout.
- Apply coupon in `POST /api/orders`: body includes `couponCode`; validate and store in CouponUse; reduce order total.

Admin-only: create/update/delete coupons (see Admin below).

### 8.11 Admin

- `GET /api/admin/vendors/pending` – List vendors with status PENDING.
- `POST /api/admin/vendors/:id/approve` – Approve vendor.
- `POST /api/admin/vendors/:id/reject` – Reject vendor (body: reason).
- `PATCH /api/admin/commission` – Set new commission rate (create new CommissionConfig row).
- `GET /api/admin/orders` – List all orders (filters: status, date, vendor).
- `PATCH /api/admin/orders/:id/status` – Set order status (manual shipping: e.g. IN_DELIVERY, DELIVERED).
- `GET /api/admin/returns` – List return requests.
- `POST /api/admin/returns/:id/approve` – Approve return (refund logic; deduct points if any were given).
- `POST /api/admin/returns/:id/reject` – Reject return.
- `GET /api/admin/payouts` – List payout requests (vendor).
- `POST /api/admin/payouts/:id/process` – Mark payout as processed; update VendorBalance.
- `GET /api/admin/coupons` – List coupons.
- `POST /api/admin/coupons` – Create coupon.
- `PATCH /api/admin/coupons/:id` – Update coupon.
- `DELETE /api/admin/coupons/:id` – Deactivate or delete.
- `GET /api/admin/settings` – e.g. default commission, payout day, return window hours, points redemption cap %.
- `PATCH /api/admin/settings` – Update settings (store in DB or config table).

### 8.12 Webhooks (External Services → Backend)

- `POST /api/webhooks/mega-shipping` – **Mega Technology** shipment status webhook. No JWT; verify using Mega’s method (secret header, signature, or IP whitelist – obtain from Mega). Body: JSON with `response` array of objects (waybill, status_id, order_id, ar_status, status_en, notes, reason, scheduled, store, client_id). Map status_id to Order status (see Section 10.5.6 and Appendix W); update Order and OrderStatusHistory; return 200 OK. If Mega integration is disabled (env), this endpoint may return 404 or 501.

---

## 9. Business Rules (Implementation Notes)

- **No product with stockQuantity = 0** in public listing. Filter in `GET /api/products` and `GET /api/products/:id`.
- **Vendor can reject order** only if payment is COD or order is not yet paid. If payment is VISA and paid, vendor cannot reject.
- **COD:** Vendor earnings are added to “pending” until COD is collected. When marking order as DELIVERED and payment is COD, you can assume COD collected by shipping company (or add a separate “COD collected” step); then move amount from pending to available for vendor. Settlement with shipping company is offline; system only tracks “COD to be collected” for reporting.
- **Vendor balance:** On order delivery (and COD collected if COD), add vendor share to VendorBalance.available (or pending first, then move on “COD collected” event). On return/refund, deduct from vendor and platform as per policy.
- **Payout:** Vendor can request payout (e.g. weekly). Admin processes; mark PayoutRequest as PROCESSED and decrease VendorBalance.available.
- **Return within 48 hours:** From `deliveredAt`. If return approved: refund (full or partial); customer pays return shipping if policy says so; deduct any points earned for that order (PointsTransaction with negative delta).
- **Retail vs wholesale:** Default display is retail price. When cart item quantity >= product.moq, use wholesale price for that line. Show in cart that “wholesale price applied”. Commission (e.g. 5%) applies to the price used (retail or wholesale).
- **Points:** Add points only after order is DELIVERED and return window (e.g. 48h) has passed. Formula: e.g. 1 EGP spent = 1 point (BRD: 0.02 point per 1 EGP then 1000 points = 20 EGP value – clarify: 1 EGP = 1 point earning; redemption 1 point = 0.02 EGP or as per admin). On return, deduct all points earned for that order.
- **Points redemption cap:** Admin sets max % of product (or order) that can be paid with points (e.g. 25%). Enforce in checkout.
- **Preview before delivery / defect:** If customer reports defect before accepting, notify vendor (log or notification); if customer wants to return, they pay return shipping only; product must be in original condition with labels. Implement as part of return flow and notes.

---

## 10. Manual Shipping Flow (No External API)

### 10.1 Critical Business Rule

**Shipping is manual.** The shipping company has **no API**. The vendor physically hands the order to the shipping company; the shipping company coordinates delivery and (for COD) collects cash. The system does **not** integrate with any shipping API. It only:

- Stores order shipping-related statuses.
- Lets the vendor or admin update those statuses when something happens in the real world (e.g. handed to shipping, in delivery, delivered).
- Exposes status history to the customer as order tracking.

So: no webhooks from shipping, no automatic status updates. Every status change is a **manual** action in the app (vendor or admin clicks "mark as handed to shipping", "mark as in delivery", "mark as delivered").

### 10.2 Flow (Step by Step)

1. **Order CONFIRMED**
   Vendor has accepted the order (or it was auto-confirmed for paid Visa). Vendor prepares the items.

2. **Vendor hands order to shipping company (offline)**
   Vendor goes to shipping company (or they pick up). No API call from shipping company.
   **In the system:** Vendor (or admin) sets status to **HANDED_TO_SHIPPING**. Optional: allow a short  (e.g. "Handed to ABC Couriers, waybill #123").

3. **Shipping company has order, in transit**
   Shipping company contacts customer (phone/WhatsApp etc.) to coordinate delivery – outside the system.
   When vendor or admin knows it is on the way, **in the system:** set status to **IN_DELIVERY**.

4. **Customer receives order**
   Delivery happens offline.
   **In the system:** Vendor or admin sets status to **DELIVERED** and sets .
   This triggers: return window starts (e.g. 48h), and later (after window) loyalty points can be credited.

5. **Customer sees tracking**
    (or order detail with history) returns **OrderStatusHistory** rows: PENDING → CONFIRMED → HANDED_TO_SHIPPING → IN_DELIVERY → DELIVERED (with timestamps and optional notes). No live GPS, no third-party API – just this manual history.

### 10.3 Implementation Logic

- **Who can update status**
  - **Vendor:** Only for orders that contain their items (filter by order items' ). Allowed statuses from vendor: , , . Vendor may **not** set  if you want only admin to confirm delivery (recommended: admin or vendor can set DELIVERED).
  - **Admin:** Can set any valid status, including  and .

- **Validation**
  - Enforce **allowed transitions** (e.g. CONFIRMED → HANDED_TO_SHIPPING → IN_DELIVERY → DELIVERED). Reject invalid jumps (e.g. PENDING → DELIVERED) with 400 and a clear message.
  - When setting **DELIVERED:** require  to be set (server sets it if not provided).

- **Persistence**
  - Every status change: (1) update , (2) if DELIVERED, set , (3) insert **OrderStatusHistory** (orderId, status, note, createdBy, createdAt).
  - Use a single service method e.g.  that validates transition, updates order, and appends history.

- **Endpoints**
  - **Vendor:**     Body: .
    Ensure order belongs to this vendor (via order items). Validate allowed transition; then update order + history.
  - **Admin:**     Body: .
    Validate transition; if status is DELIVERED, set  (body or now()).
  - **Customer tracking:**  or     Return order plus  (or only history) so the app can show the timeline.

### 10.4 Summary

- No shipping API; all shipping statuses are **manual**.
- Flow: CONFIRMED → (PREPARING) → HANDED_TO_SHIPPING → IN_DELIVERY → DELIVERED.
- Vendor updates up to IN_DELIVERY (or PREPARING); admin (or vendor, if you allow) sets DELIVERED and `deliveredAt`.
- Every change is stored in OrderStatusHistory for customer-facing tracking.

### 10.5 Mega Technology Shipping API Integration

When the platform integrates with **Mega Technology** (mega-technology.info) as the shipping provider, the backend must support both: **(1) creating shipments via their API** and **(2) receiving status updates via webhook** (so order status can be updated automatically instead of manually). If Mega credentials are not configured, keep using the manual flow (Section 10.1–10.4).

**Base URL (all requests over HTTPS):** `https://mega-technology.info/api/shipment.php`  
**Rate limit (Mega):** 50 requests per minute. Stay within this limit.  
**Authentication:** Every request to Mega requires `user` (API username) and `password` (API password). Store these in env (e.g. `MEGA_SHIPPING_USER`, `MEGA_SHIPPING_PASSWORD`). Invalid credentials return `"User Not Found"`.  
**Responses:** All Mega API responses are JSON with a `response` array or object.

---

#### 10.5.1 Add Bulk Shipments (Create Shipments)

- **URL:** `POST https://mega-technology.info/api/shipment.php?action=addBulkShipments`
- **Purpose:** Send one or many shipments in a single request. Maximum **1000 shipments per request**. Do not duplicate: one request with all shipments, not one request per shipment.
- **Request body (JSON):**

| Parameter   | Required | Description |
|------------|----------|-------------|
| user       | Yes      | API username (from env). |
| password   | Yes      | API password (from env). |
| shipments  | Yes      | Array of shipment objects. **Exclude** `user` and `password` from each object. |

**Each shipment object:**

| Parameter     | Required | Description |
|---------------|----------|-------------|
| sector_id     | Yes*     | Destination sector ID from Get Sectors API. |
| keyword       | Optional | Area name as keyword; use if sector_id is unknown (clarify with Mega how it works). |
| product_name  | Yes      | String(250). Product name. |
| product_desc  | No       | Text. Product description. |
| phone_1       | Yes      | Int(11). Consignee mobile number. |
| phone_2       | No       | Int(11). Alternative phone. |
| service_type  | Yes      | Int(11). **1** = تسليم وتحصيل (delivery + COD), **2** = شحنة استبدال, **3** = استرجاع طرد (return). Use 1 for normal COD orders, 3 for returns. |
| price         | Yes      | Int(11). Shipment COD amount (EGP). Use 0 for non-COD. |
| weight        | No       | String(20). Package weight (e.g. "5 kg"). |
| address       | Yes      | Text. Full delivery address. |
| notes         | No       | Text. Additional notes. |
| client_name   | Yes      | String(250). Client (customer) name. |
| order_id      | Yes      | String(255). **Your platform order ID** (e.g. orderNumber). Mega returns this in responses and webhook so you can map back to Order. |
| email         | No       | String(100). Client email. |
| client_id     | No       | Int(11). Client ID. |
| quantity      | No       | String(20). Quantity. |

**Example request:**

```json
{
  "user": "your_api_username",
  "password": "your_api_password",
  "shipments": [
    {
      "sector_id": "100",
      "product_name": "Product Name",
      "product_desc": "Product Description",
      "phone_1": "01000000011",
      "phone_2": "01000000022",
      "service_type": 1,
      "price": 300,
      "weight": "5 kg",
      "address": "Full Address",
      "notes": "Additional notes",
      "client_name": "Client Name",
      "order_id": "DA-20260226-0001",
      "email": "client@example.com",
      "quantity": "2"
    }
  ]
}
```

**Example response:**

```json
{
  "response": [
    {
      "waybill": "WY154830",
      "id": "52",
      "qr_code": "52-WY154830--7LpyIfWCebfL6znr9bv0LemKdFdGggjj891009266948",
      "order_id": "DA-20260226-0001",
      "sector_store_name": "المهندسين فرع"
    }
  ]
}
```

**Implementation:** After creating the shipment(s), store on the Order (or on a `Shipment` table): `waybill`, optional `qr_code`, and optionally `sector_store_name`. Use `order_id` in the request to match the response and webhook to your Order. If Mega returns an error (e.g. invalid sector, User Not Found), log it and return a clear error to the caller; do not update order status to shipped until you have a waybill.

---

#### 10.5.2 Get Sectors (Address → sector_id)

- **URL:** `POST https://mega-technology.info/api/shipment.php?action=getAllSectors`
- **Body:** `{ "user": "...", "password": "..." }`
- **Purpose:** Get all sectors (areas) so you can map customer address (governorate/city/area) to `sector_id` when calling Add Bulk Shipments. Cache this list (e.g. in DB or memory) and refresh periodically.

**Example response:**

```json
{
  "response": [
    {
      "id": "105",
      "name": "الأزبكية",
      "key_words": "",
      "gov_id": "29",
      "gov_name": "القاهرة"
    },
    {
      "id": "110",
      "name": "الأميرية",
      "key_words": "",
      "gov_id": "29",
      "gov_name": "القاهرة"
    }
  ]
}
```

Use `id` as `sector_id` in shipments. Optionally store governorate/area in CustomerProfile or in a mapping table (gov_name + name → sector_id) so at checkout or when creating shipment you can resolve sector_id from the customer’s selected address.

---

#### 10.5.3 Instant Shipment Status Webhook (Mega → Your Backend)

Mega sends **instant status updates** to a URL you provide. You must expose a **public HTTPS endpoint** (e.g. `POST /api/webhooks/mega-shipping`) that:

1. Accepts POST from Mega’s servers.
2. Verifies the request is from Mega (see 10.5.7 – request from Mega: exact payload format, auth header or signature; if they do not document it, ask them for webhook request format and authentication).
3. Parses the body (JSON). Example payload they send:

```json
{
  "response": [
    {
      "waybill": "TS879292",
      "status_id": "13",
      "ar_status": "فشل التسليم",
      "status_en": "Delivery Failed",
      "notes": "Status Note",
      "reason": "فشل التسليم",
      "scheduled": "2024-07-10 05:20 AM",
      "store": "فرع المهندسين",
      "order_id": "EM12848",
      "client_id": "121845"
    }
  ]
}
```

4. For each item: find Order by `order_id` (your orderNumber) and optionally by waybill if stored. Map Mega `status_id` to your Order status (see 10.5.6). Update Order and append OrderStatusHistory. If status_id = 5 (تسليم ناجح), set `Order.deliveredAt = now()` and apply any post-delivery logic (return window, later loyalty points). If status_id = 13 (فشل التسليم) or return-related codes, update to appropriate failed/returned state.
5. Respond with 200 OK so Mega does not retry unnecessarily.

**Important:** Obtain from Mega: (1) exact webhook request format (body and headers), (2) how they authenticate the webhook (token, signature, or IP whitelist), (3) whether they send every status change or only some.

---

#### 10.5.4 Get Status History (Single Waybill)

- **URL:** `POST https://mega-technology.info/api/shipment.php?action=statusHistory`
- **Body:** `{ "user": "...", "password": "...", "waybill": "TS879292" }`
- **Purpose:** Get full status history for a waybill. Use this to display “tracking” in the customer app when you have a waybill (e.g. merge with OrderStatusHistory or show as shipping provider timeline).

**Example response:**

```json
{
  "response": [
    {
      "waybill": "TS879292",
      "date_created": "2023-09-17 17:04:01",
      "ar_status": "طلب بيك اب",
      "status_en": "Pickup Request",
      "reason_en": "Pickup Done",
      "ar_reason": "التليفون مغلق",
      "scheduled_date": "0000-00-00 00:00:00"
    }
  ]
}
```

---

#### 10.5.5 Get Current Status (Bulk, Max 50 Waybills)

- **URL:** `POST https://mega-technology.info/api/shipment.php?action=getCurrentStatus`
- **Body:** `{ "user": "...", "password": "...", "waybill": ["TS8792162", "TS8792167"] }` — array of waybill numbers, **maximum 50 per request**.
- **Purpose:** Poll current status for multiple orders (e.g. as backup if webhook fails or for admin dashboard).

**Example response:**

```json
{
  "response": [
    {
      "waybill": "TS8792162",
      "ar_name": "شحنة مؤجلة",
      "name_en": "Time Scheduled"
    },
    {
      "waybill": "TS8792167",
      "ar_name": "طلب بيك أب",
      "name_en": "Pickup Request"
    }
  ]
}
```

---

#### 10.5.6 Mega Status Codes → Order Status Mapping

Map Mega `status_id` to your internal Order status and OrderStatusHistory so the app and reports stay consistent. Suggested mapping:

| Mega status_id | ar_status (example)     | Suggested internal status / action |
|----------------|-------------------------|------------------------------------|
| 1              | طلب بيك أب              | PREPARING or HANDED_TO_SHIPPING (pickup requested) |
| 2              | تم استلام البيك أب      | HANDED_TO_SHIPPING                 |
| 3              | تم الاستلام في المخزن   | HANDED_TO_SHIPPING                 |
| 4              | في الطريق للتوصيل       | IN_DELIVERY                        |
| 5              | تسليم ناجح              | **DELIVERED**; set `deliveredAt`; start return window; schedule loyalty points after window. |
| 6              | شحنة مؤجلة              | Keep current or IN_DELIVERY + note |
| 7              | تم الارتداع للمخزن      | Return flow                        |
| 8              | تقفيل مرتجع             | RETURNED or similar                |
| 13             | فشل التسليم             | Failed delivery; do not set DELIVERED. |
| 14             | تم الارتداع للراسل      | RETURNED                           |
| 19             | شحنة ملغاه              | CANCELLED                          |
| 25             | رفض الاستلام والدفع     | Failed delivery                    |

Implement this mapping in the webhook handler and (if you poll) in the getCurrentStatus consumer. Do not set DELIVERED or `deliveredAt` unless status_id = 5 (تسليم ناجح).

---

#### 10.5.7 Get Delivery Cost By Sector / GetAll Delivery Costs

- **By sector:** `POST .../shipment.php?action=getDeliveryCost` — body: `user`, `password`, `sector_id`. Returns e.g. `{ "response": [{ "sector_name": "test", "costing_delivery": "60", "costing_replace": "0", "sector_id": "10" }] }`.
- **All costs:** `POST .../shipment.php?action=getAllDeliveryCost` — body: `user`, `password`. Returns array of sectors with `costing_delivery`, `costing_replace`, `sector_id`.

Use these to show shipping cost at checkout (after resolving sector_id from customer address). Store or cache costs if needed.

---

#### 10.5.8 Implementation Checklist (Mega)

- Add env: `MEGA_SHIPPING_ENABLED` (true/false), `MEGA_SHIPPING_USER`, `MEGA_SHIPPING_PASSWORD`, and optionally `MEGA_SHIPPING_WEBHOOK_SECRET` (if they provide one for verifying webhook).
- Add on Order (or Shipment table): `shippingWaybill` (string, nullable), optional `shippingQrCode`, optional `shippingProvider` (e.g. "mega").
- When order is ready to ship (e.g. CONFIRMED and vendor/admin triggers “create shipment”): resolve sector_id from order address (using Get Sectors cache or keyword if documented), call Add Bulk Shipments with one shipment per order (or batch), store waybill on Order.
- Expose `POST /api/webhooks/mega-shipping` (no auth by JWT; verify using Mega’s method). Parse body, map status_id to Order status, update Order and OrderStatusHistory, return 200.
- Optionally: cron or job to poll Get Current Status for orders that have waybill but are not yet DELIVERED/failed, to catch missed webhooks.
- Customer tracking: if Order has waybill, you can merge OrderStatusHistory with data from Get Status History (Mega) for richer display.
- Returns: if using Mega for returns, create a shipment with service_type = 3 and link waybill to ReturnRequest.

---

#### 10.5.9 What to Request from Mega (If Not Documented)

- Webhook: exact URL they call, request body format, and **authentication** (token in header, signature, or IP whitelist).
- Clarification on **keyword** (when sector_id unknown): how to use it and limits.
- Test/sandbox credentials and test webhook behavior if available.

---

## 11. Security (Server & Application)

### 11.1 Application Level

- **Helmet:** Use `helmet()` for security headers (X-Content-Type-Options, X-Frame-Options, etc.).
- **CORS:** Restrict to `CORS_ORIGINS` from env. Do not use `*` in production.
- **Rate limiting:** Apply `express-rate-limit` (e.g. 100 req/15 min per IP for API; stricter for auth: e.g. 5 login attempts per 15 min per IP). Use in-memory store for single instance.
- **Input validation:** Every request body/query/param that you use must pass through Zod. Reject invalid input with 400 and clear message.
- **SQL/NoSQL injection:** Prisma uses parameterized queries; avoid raw queries with string concatenation.
- **XSS:** Sanitize any user-generated content if you render HTML; for API-only, ensure you don’t store unsanitized HTML in DB that might be shown elsewhere. Validate content types for file uploads.
- **File upload:** Only allow allowed MIME types and extensions; limit file size; store outside web root or serve with safe headers; use random filenames (UUID + extension).
- **Passwords:** Never log or return passwords; hash with bcrypt.
- **JWT:** Verify signature and expiry; use short-lived access token; rotate refresh token; store refresh tokens in DB and revoke on logout.

### 11.2 Server Level (Deployment Section)

- Run app as non-root user.
- Firewall: allow only 22 (SSH), 80 (HTTP), 443 (HTTPS). Close direct access to Node port from internet.
- Keep Node and system packages updated.
- Use HTTPS only in production (Nginx + Let’s Encrypt).
- Optional: fail2ban for SSH.

---

## 12. File Upload (Vendor Documents & Product Images)

- **Multer:** Use `multer` with `diskStorage`. Configure two upload middlewares (or one with fields): one for vendor documents (e.g. max 5 MB, types: pdf, jpg, png), one for product images (jpg, png, webp; max 2 MB per file; max 5–10 images per product).
- **Paths:** Save under `UPLOAD_PATH` (e.g. `./uploads/documents`, `./uploads/products`). Filename: `uuid.v4() + ext` to avoid collisions and path traversal.
- **Serving:** Expose via static route (e.g. `/uploads/:path`) or through a controller that checks auth and path (avoid serving arbitrary files). Prefer storing relative path in DB; base URL from env for full URL in API responses.
- **Vendor documents:** On vendor registration/update, save files and store paths in VendorProfile (e.g. documentUrls: { nationalId, commercialRegistry, taxCard }).

---

## 13. Payments (Visa Placeholder & COD)

- **COD:** No gateway. Order is created with paymentMethod = COD, paymentStatus = PENDING. On DELIVERED, consider COD collected (or add explicit “COD collected” flag); then update vendor balance. Reports: “COD to be collected” = sum of COD order amounts not yet marked collected.
- **Visa / Online:** Create an abstract payment service (e.g. `createPayment(orderId, amount, callbackUrl)`, `verifyCallback(payload)`). Implement a **stub** that returns success and a fake transaction id for testing. Document where to plug in Fawry/Visa/etc. (Egypt: Fawry has Node SDK; Visa may be via acquirer). Callback URL should verify signature/secret and update order paymentStatus to PAID; then confirm order (status CONFIRMED). If payment fails, keep order in PENDING or FAILED.

---

## 14. Loyalty & Points

- **Earning:** After order is DELIVERED and return window (e.g. 48 hours) has passed, add points (e.g. 1 EGP = 1 point; store formula in config). Create PointsTransaction (positive delta, reason PURCHASE) and update LoyaltyPoints.totalEarned and pointsBalance.
- **Scheduler:** Use a cron job or scheduled task (e.g. every hour) to “close” return window for delivered orders and credit points. Or run on-demand when user views balance (and backfill any missing) – ensure idempotency.
- **Redemption:** At checkout, user can pass `pointsToRedeem`. Validate: pointsBalance >= pointsToRedeem; pointsToRedeem <= max allowed (admin-configured % of subtotal, e.g. 25%). Deduct points; create PointsTransaction (negative, reason REDEMPTION); reduce order total.
- **Return:** When return is approved, deduct points earned for that order (if any were already credited); create negative PointsTransaction with reason RETURN_DEDUCT.

---

## 15. Reports (Dashboard & Excel)

- **Dashboard:** Single endpoint that returns JSON: counts (orders, by status), total sales, platform commission, vendor payables, COD pending collection, refunds total, etc. Filter by date range. Use Prisma aggregations and raw queries if needed; keep response small.
- **Excel:** Use ExcelJS. Generate workbooks with clear sheet names and headers. Stream response with `Content-Disposition: attachment; filename="orders-report.xlsx"`. Implement: Orders, Payments, COD Collection, Vendor Earnings, Refunds. Add a sheet or filter for “wholesale only” if required. Protect sensitive data (no passwords, minimal PII as needed).

---

## 16. Coupons

- **Model:** Coupon with code, type (PERCENTAGE | FIXED_AMOUNT), value, minOrderAmount, maxUses, usedCount, validFrom, validTo, isActive, applicableTo (ALL | SPECIFIC_VENDORS | SPECIFIC_PRODUCTS), applicableIds.
- **Validation:** At checkout, check code exists, is active, within date range, usedCount < maxUses, order total >= minOrderAmount, and (if applicable) vendor/product in applicableIds. Compute discount amount.
- **Apply:** Create CouponUse; reduce order total; increment usedCount.

---

## 17. Testing & Quality

- **Unit tests:** For critical services (order total calculation, commission, points earning/redemption, coupon discount). Use Jest or Vitest; mock Prisma if needed.
- **Integration tests:** For auth flow (register, login, refresh), create order (COD path), add to cart, apply coupon. Use a test DB (e.g. SQLite with Prisma or separate PostgreSQL database).
- **Manual testing:** Before production, run through: customer registration → browse product → add to cart (retail and wholesale) → place order (COD and Visa stub) → vendor accept/reject → status updates (manual shipping) → delivery → return request → admin approve return → payout request → reports export.
- **Linting:** Use ESLint with TypeScript. No `any` unless justified.
- **Pre-commit or CI:** Run lint + tests.

---

## 18. Deployment (Hostinger VPS)

- **OS:** Ubuntu 22.04 LTS (or provided by Hostinger).
- **Node:** Install Node 20 LTS (via nvm or NodeSource). Use `npm ci` in production.
- **PostgreSQL:** Install PostgreSQL 15+; create database and user; set `DATABASE_URL` in env. Run migrations: `npx prisma migrate deploy`.
- **App directory:** e.g. `/var/www/dar-alabaya-backend`. Clone repo or upload build. Install deps, build TypeScript (`tsc` or `npm run build`). Create `uploads` directory with correct permissions.
- **Environment:** Create `.env` from `.env.example`; set all production values. Never commit `.env`.
- **PM2:** Install globally `npm i -g pm2`. Start app: `pm2 start dist/app.js` (or your entry) with `-i max` for cluster mode. Name: `dar-alabaya-api`. Save process list: `pm2 save`. Startup script: `pm2 startup`.
- **Nginx:** Install Nginx. Create server block: listen 80 and 443 (after SSL). Proxy pass to `http://127.0.0.1:3000` (or your PORT). Set `proxy_set_header Host $host`, `X-Real-IP`, `X-Forwarded-For`, `X-Forwarded-Proto`. For uploads, you can proxy or serve static from Nginx.
- **SSL:** Use Certbot: `certbot --nginx -d yourdomain.com`. Auto-renewal: `certbot renew --dry-run`.
- **Firewall:** UFW: allow 22, 80, 443; enable `ufw enable`.
- **Logs:** PM2 logs: `pm2 logs`. Application logs (Pino) to stdout or file; rotate if needed (e.g. PM2 module or logrotate).
- **Restart on deploy:** After git pull and build, `pm2 reload dar-alabaya-api` for zero-downtime.

---

## 19. Pre-Launch Checklist

- [ ] All env vars set and validated on server.
- [ ] Database migrations applied; no pending migrations.
- [ ] Seed or script created for first admin user.
- [ ] Public product listing excludes out-of-stock products.
- [ ] Vendor cannot reject paid Visa orders.
- [ ] COD flow: vendor balance updated only when COD collected/delivered as per policy.
- [ ] Return window (48h from delivery) enforced; points deducted on return.
- [ ] Points earned only after delivery + return window; redemption cap enforced.
- [ ] Manual shipping statuses (HANDED_TO_SHIPPING, IN_DELIVERY, DELIVERED) updatable by vendor/admin; history stored.
- [ ] If Mega Technology integration enabled: Add Bulk Shipments called when order ready to ship; waybill stored on Order; webhook endpoint exposed and verified; status_id mapped to Order status; DELIVERED and deliveredAt only when Mega status_id = 5 (تسليم ناجح).
- [ ] Commission configurable; applied correctly for retail and wholesale.
- [ ] Excel reports generate and download without error.
- [ ] Dashboard report returns correct aggregates.
- [ ] Coupons validate and apply; maxUses and dates respected.
- [ ] File uploads: type and size validated; paths stored correctly.
- [ ] Helmet, CORS, rate limit enabled.
- [ ] JWT refresh rotation and logout revoke refresh token.
- [ ] HTTPS and firewall enabled on server.
- [ ] PM2 cluster mode and Nginx proxy working.
- [ ] No secrets in code or in git.

---

## 20. References & Research

- **OWASP Node.js Security:** Input validation, parameterized queries, secure session/JWT, dependency audit.
- **Prisma:** Schema, migrations, indexes, transactions (for order creation and balance updates).
- **Express:** Middleware order (CORS, helmet, rate limit, body parser, auth, routes, error handler).
- **Zod:** Schema design, refinements, error messages.
- **JWT:** RFC 8725; short-lived access, refresh rotation, httpOnly cookie for refresh.
- **PM2:** Cluster mode, env, logging, reload.
- **Nginx:** Reverse proxy, SSL with Certbot, proxy headers.
- **ExcelJS:** Create workbook, add rows, stream to response.
- **Egypt payments:** Fawry Node SDK for future integration; Visa via acquirer documentation.
- **Mega Technology Shipping API:** mega-technology.info – Add Bulk Shipments, Get Sectors, Get Status History, Get Current Status, Get Delivery Cost(s), and Instant Status Webhook. See Section 10.5 and Appendix W. Base URL: `https://mega-technology.info/api/shipment.php`. Rate limit 50 req/min; HTTPS only.

---

## Appendix A: Example Response Shape

Use a consistent API response format, for example:

**Success (data):**
```json
{
  "success": true,
  "data": { ... }
}
```

**Success (message):**
```json
{
  "success": true,
  "message": "Order accepted"
}
```

**Error (4xx/5xx):**
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": [ { "path": "email", "message": "Invalid email" } ]
  }
}
```

Use appropriate HTTP status codes (200, 201, 400, 401, 403, 404, 409, 500).

---

## Appendix B: Example Prisma Transaction (Order Creation)

When creating an order from cart:

1. Start transaction.
2. Lock cart and cart items; load products and validate stock and MOQ.
3. Calculate totals, commission, vendor earnings per line.
4. Create Order and OrderItem rows.
5. Create OrderStatusHistory (PENDING).
6. If COD: create or update VendorBalance (pending). If Visa: call payment service; on success continue.
7. Decrement product stockQuantity for each order item.
8. Clear cart items (or delete cart).
9. Commit.
10. If any step fails, rollback.

Use `prisma.$transaction([ ... ])` or sequential operations inside a transaction callback.

---

## Appendix C: Environment Variables (.env.example)

```env
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://user:password@localhost:5432/dar_alabaya
JWT_ACCESS_SECRET=your-access-secret-min-32-chars
JWT_REFRESH_SECRET=your-refresh-secret-min-32-chars
JWT_ACCESS_EXPIRY=15m
JWT_REFRESH_EXPIRY=7d
CORS_ORIGINS=http://localhost:3000,http://localhost:8080
OTP_PROVIDER=mock
# Twilio (if OTP_PROVIDER=twilio):
# TWILIO_ACCOUNT_SID=
# TWILIO_AUTH_TOKEN=
# TWILIO_PHONE_NUMBER=
UPLOAD_PATH=./uploads
DEFAULT_COMMISSION_RATE=0.05
RETURN_WINDOW_HOURS=48
POINTS_REDEMPTION_CAP_PERCENT=25
PAYOUT_DAY_OF_WEEK=1

# Mega Technology Shipping (optional – if set, use API + webhook; otherwise manual shipping)
# MEGA_SHIPPING_ENABLED=false
# MEGA_SHIPPING_USER=
# MEGA_SHIPPING_PASSWORD=
# MEGA_SHIPPING_WEBHOOK_SECRET=
```

---

## Appendix D: Order Status Transitions (Manual Shipping)

Allowed transitions (enforce in service layer):

- PENDING → CONFIRMED (vendor accept) or REJECTED (vendor reject, only if COD/unpaid).
- CONFIRMED → PREPARING (optional) → HANDED_TO_SHIPPING (vendor).
- HANDED_TO_SHIPPING → IN_DELIVERY (vendor or admin).
- IN_DELIVERY → DELIVERED (vendor or admin; set deliveredAt).
- DELIVERED → RETURN_REQUESTED (customer, within 48h).
- RETURN_REQUESTED → RETURN_APPROVED or RETURN_REJECTED (admin).
- RETURN_APPROVED → RETURNED (after refund/process).
- Any appropriate state → CANCELLED (admin or business rule).

Reject invalid transitions with 400 and clear message.

---

## Appendix E: Points Formula (BRD Alignment)

- **Earning:** 1 EGP spent = 1 point (or as per BRD: 0.02 point per 1 EGP – if so, 50 EGP = 1 point). Stored in config. Add points only after delivery + return window.
- **Redemption value:** 1 point = 0.02 EGP (so 1000 points = 20 EGP). Max redemption = admin-defined % of product/order (e.g. 25%).
- Store in config table or env: `POINTS_PER_EGP`, `EGP_PER_POINT`, `POINTS_REDEMPTION_CAP_PERCENT`.

---

## Appendix F: Commission Calculation

- Default 5% (0.05). Stored in CommissionConfig; use rate effective at order creation time.
- Apply to: retail price in retail orders, wholesale price in wholesale orders (when quantity >= MOQ).
- Formula: `commissionAmount = round(subtotal * commissionRate, 2)`. Vendor earnings = subtotal - commissionAmount (and minus any discount/coupon share if you split discount between platform and vendor).

---

## Appendix G: Suggested package.json Scripts

```json
{
  "scripts": {
    "build": "tsc",
    "start": "node dist/app.js",
    "dev": "ts-node-dev --respawn src/app.ts",
    "lint": "eslint src --ext .ts",
    "test": "jest",
    "test:integration": "jest --config jest.integration.js",
    "prisma:generate": "prisma generate",
    "prisma:migrate": "prisma migrate dev",
    "prisma:migrate:deploy": "prisma migrate deploy",
    "prisma:seed": "ts-node prisma/seed.ts"
  }
}
```

---

## Appendix H: Error Handling Middleware

- Use a central error handler at the end of the middleware chain.
- Map known errors (e.g. AppError with statusCode) to HTTP status and JSON.
- For unexpected errors, log full error (with stack) and return generic 500 message to client (do not leak stack or internal details).
- Use async wrapper or catch in route handlers so that rejected promises are passed to the error handler.

---

## Appendix I: Logging

- Use Pino with a single logger instance. Log request id (generate or from header), method, url, status, duration. Log errors with stack in development; in production log only message and code. Do not log passwords, tokens, or full card numbers.

---

## Appendix J: Admin Seed

Create a script or Prisma seed that:

1. Creates one User with role ADMIN (email and password from env or fixed for first deploy).
2. Optionally creates default CommissionConfig (0.05), default settings (return window, points cap).

Run once after first migration on production (or document for operator).

---

## Appendix K: Prisma Schema Skeleton (Expanded)

Below is a minimal skeleton for `schema.prisma`. Expand with all fields mentioned in Section 6.

```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

enum Role { CUSTOMER VENDOR ADMIN }
enum VendorStatus { PENDING APPROVED REJECTED SUSPENDED }
enum OrderStatus {
  PENDING CONFIRMED REJECTED PREPARING
  HANDED_TO_SHIPPING IN_DELIVERY DELIVERED
  RETURN_REQUESTED RETURN_APPROVED RETURN_REJECTED RETURNED CANCELLED
}
enum PaymentMethod { VISA COD }
enum PaymentStatus { PENDING PAID REFUNDED FAILED }
enum ReturnStatus { PENDING APPROVED REJECTED }
enum PayoutStatus { PENDING PROCESSED REJECTED }
enum PointsReason { PURCHASE RETURN_DEDUCT REDEMPTION ADMIN_ADJUST }
enum CouponType { PERCENTAGE FIXED_AMOUNT }
enum CouponApplicable { ALL SPECIFIC_VENDORS SPECIFIC_PRODUCTS }

model User {
  id           String    @id @default(cuid())
  email        String    @unique
  phone        String    @unique
  passwordHash String    @map("password_hash")
  role         Role
  emailVerified Boolean @default(false) @map("email_verified")
  phoneVerified  Boolean @default(false) @map("phone_verified")
  isActive     Boolean   @default(true) @map("is_active")
  createdAt    DateTime @default(now()) @map("created_at")
  updatedAt    DateTime @updatedAt @map("updated_at")
  customerProfile CustomerProfile?
  vendorProfile   VendorProfile?
  cart            Cart?
  orders          Order[]         @relation("CustomerOrders")
  refreshTokens   RefreshToken[]
  otps            OTP[]
  loyaltyPoints   LoyaltyPoints?
  pointsTransactions PointsTransaction[]
  @@index([email])
  @@index([phone])
  @@index([role])
}

model CustomerProfile {
  id                    String   @id @default(cuid())
  userId                String   @unique @map("user_id")
  fullName               String   @map("full_name")
  defaultShippingAddress Json?    @map("default_shipping_address")
  createdAt              DateTime @default(now()) @map("created_at")
  updatedAt              DateTime @updatedAt @map("updated_at")
  user                  User     @relation(fields: [userId], references: [id], onDelete: Cascade)
}

model VendorProfile {
  id                String       @id @default(cuid())
  userId            String       @unique @map("user_id")
  businessName      String       @map("business_name")
  status            VendorStatus @default(PENDING)
  documentUrls      Json?        @map("document_urls")
  rejectionReason   String?      @map("rejection_reason")
  approvedAt        DateTime?    @map("approved_at")
  approvedBy        String?      @map("approved_by")
  createdAt         DateTime     @default(now()) @map("created_at")
  updatedAt         DateTime     @updatedAt @map("updated_at")
  user              User         @relation(fields: [userId], references: [id], onDelete: Cascade)
  products          Product[]
  vendorBalance     VendorBalance?
  payoutRequests    PayoutRequest[]
  @@index([status])
}

model Product {
  id              String    @id @default(cuid())
  vendorId        String    @map("vendor_id")
  name            String
  description    String?
  slug            String
  retailPrice     Decimal   @map("retail_price") @db.Decimal(10, 2)
  wholesalePrice  Decimal   @map("wholesale_price") @db.Decimal(10, 2)
  moq             Int       @default(1)
  stockQuantity   Int       @map("stock_quantity") @default(0)
  sku             String?   @unique
  isActive        Boolean   @default(true) @map("is_active")
  createdAt       DateTime  @default(now()) @map("created_at")
  updatedAt       DateTime  @updatedAt @map("updated_at")
  vendor          VendorProfile @relation(fields: [vendorId], references: [id], onDelete: Cascade)
  images          ProductImage[]
  cartItems       CartItem[]
  orderItems      OrderItem[]
  @@unique([vendorId, slug])
  @@index([vendorId])
  @@index([isActive, stockQuantity])
}

model ProductImage {
  id        String  @id @default(cuid())
  productId String @map("product_id")
  url       String
  sortOrder Int     @default(0) @map("sort_order")
  product   Product @relation(fields: [productId], references: [id], onDelete: Cascade)
  @@index([productId])
}

model Cart {
  id        String     @id @default(cuid())
  userId    String     @unique @map("user_id")
  updatedAt DateTime   @updatedAt @map("updated_at")
  user      User       @relation(fields: [userId], references: [id], onDelete: Cascade)
  items     CartItem[]
}

model CartItem {
  id        String  @id @default(cuid())
  cartId    String  @map("cart_id")
  productId String @map("product_id")
  quantity  Int
  cart      Cart    @relation(fields: [cartId], references: [id], onDelete: Cascade)
  product   Product @relation(fields: [productId], references: [id], onDelete: Cascade)
  @@index([cartId])
  @@index([productId])
}

model Order {
  id                    String        @id @default(cuid())
  orderNumber            String        @unique @map("order_number")
  customerId             String        @map("customer_id")
  status                 OrderStatus   @default(PENDING)
  paymentMethod          PaymentMethod @map("payment_method")
  paymentStatus          PaymentStatus @default(PENDING) @map("payment_status")
  totalAmount            Decimal       @map("total_amount") @db.Decimal(10, 2)
  platformCommissionAmount Decimal?    @map("platform_commission_amount") @db.Decimal(10, 2)
  vendorEarningsAmount   Decimal?      @map("vendor_earnings_amount") @db.Decimal(10, 2)
  shippingAddress       Json          @map("shipping_address")
  shippingPhone         String        @map("shipping_phone")
  codAmount             Decimal?      @map("cod_amount") @db.Decimal(10, 2)
  visaTransactionId     String?       @map("visa_transaction_id")
  deliveredAt           DateTime?     @map("delivered_at")
  createdAt             DateTime      @default(now()) @map("created_at")
  updatedAt             DateTime      @updatedAt @map("updated_at")
  customer              User          @relation("CustomerOrders", fields: [customerId], references: [id])
  items                 OrderItem[]
  statusHistory         OrderStatusHistory[]
  returnRequests        ReturnRequest[]
  couponUses            CouponUse[]
  @@index([customerId])
  @@index([status])
  @@index([createdAt])
  @@index([orderNumber])
}

model OrderItem {
  id             String  @id @default(cuid())
  orderId        String  @map("order_id")
  productId      String  @map("product_id")
  productSnapshot Json  @map("product_snapshot")
  quantity       Int
  unitPrice      Decimal @map("unit_price") @db.Decimal(10, 2)
  totalPrice     Decimal @map("total_price") @db.Decimal(10, 2)
  vendorId       String  @map("vendor_id")
  order         Order   @relation(fields: [orderId], references: [id], onDelete: Cascade)
  product       Product @relation(fields: [productId], references: [id])
  @@index([orderId])
  @@index([vendorId])
}

model OrderStatusHistory {
  id        String      @id @default(cuid())
  orderId   String      @map("order_id")
  status    OrderStatus
  note      String?
  createdBy String?     @map("created_by")
  createdAt DateTime    @default(now()) @map("created_at")
  order     Order       @relation(fields: [orderId], references: [id], onDelete: Cascade)
  @@index([orderId])
}

model ReturnRequest {
  id                  String       @id @default(cuid())
  orderId             String       @map("order_id")
  customerId          String       @map("customer_id")
  reason              String
  status              ReturnStatus @default(PENDING)
  refundAmount        Decimal?     @map("refund_amount") @db.Decimal(10, 2)
  returnShippingCost  Decimal?     @map("return_shipping_cost") @db.Decimal(10, 2)
  approvedAt          DateTime?    @map("approved_at")
  reviewedBy          String?      @map("reviewed_by")
  createdAt           DateTime     @default(now()) @map("created_at")
  updatedAt           DateTime     @updatedAt @map("updated_at")
  order               Order        @relation(fields: [orderId], references: [id])
  @@index([orderId])
  @@index([status])
}

model VendorBalance {
  id               String   @id @default(cuid())
  vendorId         String   @unique @map("vendor_id")
  availableBalance Decimal  @default(0) @map("available_balance") @db.Decimal(12, 2)
  pendingBalance   Decimal  @default(0) @map("pending_balance") @db.Decimal(12, 2)
  totalEarned      Decimal  @default(0) @map("total_earned") @db.Decimal(12, 2)
  totalWithdrawn   Decimal  @default(0) @map("total_withdrawn") @db.Decimal(12, 2)
  lastPayoutAt     DateTime? @map("last_payout_at")
  createdAt        DateTime @default(now()) @map("created_at")
  updatedAt        DateTime @updatedAt @map("updated_at")
  vendor           VendorProfile @relation(fields: [vendorId], references: [id], onDelete: Cascade)
  @@index([vendorId])
}

model PayoutRequest {
  id          String       @id @default(cuid())
  vendorId    String       @map("vendor_id")
  amount      Decimal      @db.Decimal(10, 2)
  status      PayoutStatus @default(PENDING)
  processedAt DateTime?    @map("processed_at")
  processedBy String?      @map("processed_by")
  note        String?
  createdAt   DateTime     @default(now()) @map("created_at")
  vendor      VendorProfile @relation(fields: [vendorId], references: [id], onDelete: Cascade)
  @@index([vendorId])
  @@index([status])
}

model LoyaltyPoints {
  id           String   @id @default(cuid())
  userId       String   @unique @map("user_id")
  pointsBalance Int    @default(0) @map("points_balance")
  totalEarned  Int      @default(0) @map("total_earned")
  totalSpent   Int      @default(0) @map("total_spent")
  createdAt    DateTime @default(now()) @map("created_at")
  updatedAt    DateTime @updatedAt @map("updated_at")
  user         User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  @@index([userId])
}

model PointsTransaction {
  id         String       @id @default(cuid())
  userId     String       @map("user_id")
  orderId    String?      @map("order_id")
  pointsDelta Int        @map("points_delta")
  reason     PointsReason
  createdAt  DateTime     @default(now()) @map("created_at")
  user       User         @relation(fields: [userId], references: [id], onDelete: Cascade)
  @@index([userId])
  @@index([orderId])
  @@index([createdAt])
}

model CommissionConfig {
  id            String    @id @default(cuid())
  rate         Decimal   @db.Decimal(5, 4)
  effectiveFrom DateTime @map("effective_from")
  effectiveTo   DateTime? @map("effective_to")
  createdAt     DateTime @default(now()) @map("created_at")
}

model Coupon {
  id             String            @id @default(cuid())
  code           String            @unique
  type           CouponType
  value          Decimal           @db.Decimal(10, 2)
  minOrderAmount Decimal?          @map("min_order_amount") @db.Decimal(10, 2)
  maxUses        Int?              @map("max_uses")
  usedCount      Int               @default(0) @map("used_count")
  validFrom      DateTime          @map("valid_from")
  validTo        DateTime          @map("valid_to")
  isActive       Boolean           @default(true) @map("is_active")
  createdBy      String?          @map("created_by")
  applicableTo   CouponApplicable  @default(ALL) @map("applicable_to")
  applicableIds  Json?             @map("applicable_ids")
  createdAt      DateTime         @default(now()) @map("created_at")
  updatedAt      DateTime         @updatedAt @map("updated_at")
  uses           CouponUse[]
  @@index([code])
  @@index([isActive, validFrom, validTo])
}

model CouponUse {
  id             String   @id @default(cuid())
  couponId       String   @map("coupon_id")
  orderId        String   @map("order_id")
  userId         String   @map("user_id")
  discountAmount Decimal  @map("discount_amount") @db.Decimal(10, 2)
  createdAt      DateTime @default(now()) @map("created_at")
  coupon         Coupon   @relation(fields: [couponId], references: [id])
  @@index([couponId])
  @@index([orderId])
}

model OTP {
  id         String   @id @default(cuid())
  phoneOrEmail String @map("phone_or_email")
  code       String
  purpose    String
  expiresAt  DateTime @map("expires_at")
  usedAt     DateTime? @map("used_at")
  createdAt  DateTime @default(now()) @map("created_at")
  user       User?    @relation(fields: [], references: [id])
  @@index([phoneOrEmail, purpose, expiresAt])
}

model RefreshToken {
  id        String    @id @default(cuid())
  userId    String    @map("user_id")
  token     String    @unique
  expiresAt DateTime  @map("expires_at")
  revokedAt DateTime? @map("revoked_at")
  createdAt DateTime  @default(now()) @map("created_at")
  user      User      @relation(fields: [userId], references: [id], onDelete: Cascade)
  @@index([userId])
  @@index([token])
}
```

Note: Fix OTP relation if you link to User (e.g. add userId to OTP or remove relation). Cart needs a relation to User – add User model relation to Cart with userId. Order.vendorId can be derived from OrderItem.vendorId for per-vendor order listing; or add a denormalized vendorId on Order if each order is single-vendor. Adjust as needed for multi-vendor single order (split orders per vendor or one order with multiple vendor items).

---

## Appendix L: Nginx Server Block Example

```nginx
# /etc/nginx/sites-available/dar-alabaya-api
upstream node_backend {
    server 127.0.0.1:3000;
    keepalive 64;
}

server {
    listen 80;
    server_name api.daralabaya.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.daralabaya.com;

    ssl_certificate     /etc/letsencrypt/live/api.daralabaya.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.daralabaya.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    client_max_body_size 20M;

    location / {
        proxy_pass http://node_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 90;
        proxy_connect_timeout 90;
        proxy_send_timeout 90;
    }

    location /uploads/ {
        alias /var/www/dar-alabaya-backend/uploads/;
        add_header Cache-Control "public, max-age=86400";
    }
}
```

Enable: `sudo ln -s /etc/nginx/sites-available/dar-alabaya-api /etc/nginx/sites-enabled/` then `sudo nginx -t` and `sudo systemctl reload nginx`.

---

## Appendix M: PM2 Ecosystem Config

Create `ecosystem.config.cjs` in project root:

```javascript
module.exports = {
  apps: [{
    name: 'dar-alabaya-api',
    script: './dist/app.js',
    instances: 'max',
    exec_mode: 'cluster',
    env: { NODE_ENV: 'development' },
    env_production: { NODE_ENV: 'production' },
    max_memory_restart: '500M',
    error_file: './logs/err.log',
    out_file: './logs/out.log',
    merge_logs: true,
    time: true
  }]
};
```

Create `logs/` and add to `.gitignore`. On server: `pm2 start ecosystem.config.cjs --env production`.

---

## Appendix N: Zod Validation Examples

**Auth register body:**
```typescript
const registerSchema = z.object({
  email: z.string().email(),
  phone: z.string().min(10).max(15),
  password: z.string().min(8).max(128),
  role: z.enum(['CUSTOMER', 'VENDOR']),
  businessName: z.string().optional() // required when role is VENDOR
}).refine(data => data.role !== 'VENDOR' || data.businessName, {
  message: 'businessName required for VENDOR',
  path: ['businessName']
});
```

**Order create body:**
```typescript
const createOrderSchema = z.object({
  shippingAddressId: z.string().cuid().optional(),
  shippingAddress: z.object({
    governorate: z.string(),
    city: z.string(),
    street: z.string(),
    building: z.string().optional(),
    floor: z.string().optional()
  }).optional(),
  shippingPhone: z.string().min(10),
  paymentMethod: z.enum(['VISA', 'COD']),
  couponCode: z.string().optional(),
  pointsToRedeem: z.number().int().min(0).optional()
}).refine(data => data.shippingAddressId || data.shippingAddress, {
  message: 'Provide shippingAddressId or shippingAddress',
  path: ['shippingAddress']
});
```

**Vendor order status update:**
```typescript
const orderStatusSchema = z.object({
  status: z.enum(['HANDED_TO_SHIPPING', 'IN_DELIVERY', 'DELIVERED', 'PREPARING']),
  note: z.string().max(500).optional()
});
```

Always use these in middleware: `validate(registerSchema)` then in controller use `req.body` as the parsed type.

---

## Appendix O: Middleware Order in app.ts

Recommended order of middleware (top to bottom):

1. Trust proxy (if behind Nginx): `app.set('trust proxy', 1);`
2. Helmet: `app.use(helmet());`
3. CORS: `app.use(cors({ origin: config.corsOrigins, credentials: true }));`
4. Body parsers: `app.use(express.json({ limit: '1mb' }));` and `express.urlencoded({ extended: true })`
5. Request ID (optional): generate and attach to req and response header
6. Rate limit: `app.use(rateLimiter);`
7. Logging: log request start
8. Public routes (auth login, register, health check) – no auth
9. `app.use(requireAuth)` for protected routes
10. Role checks per route group (e.g. admin routes use requireRole('ADMIN'))
11. Mount routes: `app.use('/api/auth', authRoutes);` etc.
12. 404 handler: `app.use((req, res) => res.status(404).json({ success: false, error: { code: 'NOT_FOUND', message: 'Resource not found' } }));`
13. Global error handler: `app.use(errorHandler);`

---

## Appendix P: BRD to API Mapping (Summary)

| BRD Item | API / Behavior |
|----------|----------------|
| تسجيل حساب (موبايل + Email) | POST /api/auth/register, send OTP, verify OTP |
| تصفح المنتجات، كمية 0 لا تُعرض | GET /api/products, GET /api/products/:id – filter stockQuantity > 0 |
| سلة، MOQ وسعر جملة | GET /api/cart shows unit price (retail/wholesale by quantity); POST /api/cart/items validates quantity >= MOQ |
| عنوان التوصيل، دفع، تأكيد الطلب | POST /api/orders with shippingAddress/shippingPhone, paymentMethod |
| متابعة حالة الطلب | GET /api/orders/me/:orderId/tracking (OrderStatusHistory) |
| إرجاع خلال 48 ساعة | POST /api/returns; validate deliveredAt + 48h |
| نقاط بعد انتهاء فترة الإرجاع | Loyalty service: credit points after DELIVERED + RETURN_WINDOW_HOURS |
| تاجر: تسجيل، مستندات، موافقة | POST /api/auth/register (VENDOR) + upload docs; GET /api/admin/vendors/pending, POST approve/reject |
| تاجر: قبول/رفض الطلب | POST accept/reject; business rule: no reject if Visa paid |
| تاجر: تسليم للشحن، تحديث حالة | POST /api/vendors/me/orders/:id/status (HANDED_TO_SHIPPING, IN_DELIVERY); admin can set DELIVERED |
| تاجر: رصيد وصرف | GET /api/vendors/me/balance; POST /api/vendors/me/payouts; admin processes payouts |
| عمولة 5% قابلة للتعديل | CommissionConfig; GET/PATCH /api/admin/settings or PATCH /api/admin/commission |
| تقارير Dashboard + Excel | GET /api/reports/dashboard; GET /api/reports/*/excel |
| كوبونات عامة/خاصة | Coupon.applicableTo (ALL, SPECIFIC_VENDORS, SPECIFIC_PRODUCTS); admin CRUD coupons |
| دورة تحصيل COD | Config/settings (daily/weekly); reporting only – no shipping API |

---

## Appendix Q: Security Checklist (Detailed)

- [ ] All routes that modify data require authentication (except auth register/login and public product list).
- [ ] Role-based access: customer cannot call vendor endpoints; vendor cannot call admin endpoints.
- [ ] Vendor can update order status only for orders that belong to their items (filter by vendorId on order items).
- [ ] Admin-only: commission config, vendor approval, return approval, payout process, coupon CRUD, settings.
- [ ] Passwords never logged; never returned in API response.
- [ ] JWT access token verified on every protected request; refresh token validated and rotated on refresh.
- [ ] Rate limit applied globally and optionally stricter on /api/auth/login and /api/auth/send-otp.
- [ ] File upload: whitelist MIME types (e.g. image/jpeg, image/png, application/pdf); max size 5MB docs, 2MB images; random filename; store path only in DB.
- [ ] No raw SQL with string concatenation; use Prisma only or parameterized rawQuery.
- [ ] CORS origin list from env; no wildcard in production.
- [ ] Helmet applied; sensitive headers removed.
- [ ] Dependency audit: `npm audit`; fix high/critical before production.
- [ ] Environment variables for all secrets; .env not in git.
- [ ] Server: non-root user; UFW 22,80,443 only; SSH key-based preferred.

---

## Appendix R: Hostinger VPS Step-by-Step (Summary)

1. **Access:** SSH as root or sudo user to the VPS (IP and key from Hostinger).
2. **Update system:** `apt update && apt upgrade -y`
3. **Create deploy user (optional):** `adduser deploy`, add to sudo, use for running app.
4. **Install Node 20:** e.g. `curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -` then `apt install -y nodejs`
5. **Install PostgreSQL 15:** `apt install -y postgresql postgresql-contrib`; create user and database; set DATABASE_URL.
6. **Install Nginx:** `apt install -y nginx`
7. **Install PM2:** `npm i -g pm2`
8. **Clone or upload app** to `/var/www/dar-alabaya-backend`; `npm ci`, `npm run build`; create .env; run `npx prisma migrate deploy`; run seed if needed.
9. **Create uploads dir:** `mkdir -p uploads logs`; chown to deploy or www-data as needed.
10. **Start app:** `pm2 start ecosystem.config.cjs --env production`; `pm2 save`; `pm2 startup`
11. **Configure Nginx:** Add server block (Appendix L); enable site; `nginx -t`; `systemctl reload nginx`
12. **SSL:** `apt install certbot python3-certbot-nginx`; `certbot --nginx -d api.yourdomain.com`
13. **Firewall:** `ufw allow 22 && ufw allow 80 && ufw allow 443 && ufw enable`
14. **Smoke test:** `curl https://api.yourdomain.com/health` (implement GET /health that returns 200 and maybe DB check).
15. **Document:** In README add deploy section with these steps and any project-specific env vars.

---

## Appendix S: Health Check Endpoint

Implement `GET /health` or `GET /api/health` for load balancer and monitoring:

- Return 200 with `{ "status": "ok", "timestamp": "<ISO>", "db": "connected" }`.
- Optionally run a simple DB query (e.g. `prisma.$queryRaw\`SELECT 1\``) and set `db: "connected"` or `db: "error"` and return 503 if DB fails.
- Do not require authentication for this route.
- Rate limit can be relaxed for /health (e.g. exclude from main limiter or use a higher limit).

---

## Appendix T: Order Number Generation

Generate unique, human-readable order numbers (e.g. for invoices and support):

- Format suggestion: `DA-YYYYMMDD-XXXX` (e.g. DA-20260226-0001). Use a daily sequence or global sequence stored in DB.
- Implementation: create table `OrderSequence` with `date` and `lastNumber`; in transaction get next number and increment; then set `orderNumber` on Order. Or use `cuid()`/uuid and map to a short display code. Ensure uniqueness in DB (unique constraint on orderNumber).

---

## Appendix U: Return Window Calculation

- Store `deliveredAt` when order status becomes DELIVERED.
- Return window = `deliveredAt + RETURN_WINDOW_HOURS` (e.g. 48 hours).
- When customer submits return request: check `order.status === 'DELIVERED'` and `now() <= deliveredAt + RETURN_WINDOW_HOURS`. If outside window, return 400 with message "Return window expired".
- In loyalty: credit points only when `now() > deliveredAt + RETURN_WINDOW_HOURS` (run job or on-demand with idempotent check).

---

## Appendix V: Recommended Dependencies (package.json)

```json
{
  "dependencies": {
    "@prisma/client": "^5.x",
    "bcrypt": "^5.x",
    "cors": "^2.x",
    "dotenv": "^16.x",
    "exceljs": "^4.x",
    "express": "^4.x",
    "express-rate-limit": "^7.x",
    "helmet": "^7.x",
    "jsonwebtoken": "^9.x",
    "multer": "^1.x",
    "pino": "^8.x",
    "pino-pretty": "^10.x",
    "zod": "^3.x"
  },
  "devDependencies": {
    "@types/bcrypt": "^5.x",
    "@types/cors": "^2.x",
    "@types/express": "^4.x",
    "@types/jsonwebtoken": "^9.x",
    "@types/multer": "^1.x",
    "@types/node": "^20.x",
    "eslint": "^8.x",
    "jest": "^29.x",
    "prisma": "^5.x",
    "ts-jest": "^29.x",
    "ts-node": "^10.x",
    "ts-node-dev": "^2.x",
    "typescript": "^5.x"
  }
}
```

Use exact or caret versions; run `npm audit` before production.

---

## Appendix W: Mega Technology – Full Status Codes and Webhook Reference

Complete list of Mega Technology `status_id` values (from their documentation) for webhook and Get Status History / Get Current Status mapping:

| status_id | ar_status (Arabic) | status_en (English) | Suggested internal action |
|-----------|--------------------|----------------------|----------------------------|
| 1 | طلب بيك أب | Pickup Request | PREPARING or HANDED_TO_SHIPPING |
| 2 | تم استلام البيك أب | Pickup received | HANDED_TO_SHIPPING |
| 3 | تم الاستلام في المخزن | Received in warehouse | HANDED_TO_SHIPPING |
| 4 | في الطريق للتوصيل | Out for delivery | IN_DELIVERY |
| 5 | تسليم ناجح | Successful delivery | **DELIVERED**; set deliveredAt; start return window; schedule loyalty |
| 6 | شحنة مؤجلة | Time scheduled / postponed | Keep current or note |
| 7 | تم الارتداع للمخزن | Returned to warehouse | Return flow |
| 8 | تقفيل مرتجع | Return closed | RETURNED |
| 13 | فشل التسليم | Delivery Failed | Do not set DELIVERED; failed delivery |
| 14 | تم الارتداع للراسل | Returned to sender | RETURNED |
| 16 | في الطريق للمخزن | On the way to warehouse | HANDED_TO_SHIPPING / note |
| 17 | استبدال او استلام طرد | Replace or receive package | Replace flow |
| 18 | تسليم جزئي | Partial delivery | Note; partial |
| 19 | شحنة ملغاه | Shipment cancelled | CANCELLED |
| 20 | مرتجع و تم دفع الشحن | Returned and shipping paid | RETURNED |
| 21 | مرتجع جزئي | Partial return | Return flow |
| 22 | مرتجع استبدال | Replacement return | Return flow |
| 23 | --- | --- | Map as needed |
| 24 | طرد مرتجع | Returned package | RETURNED |
| 25 | رفض الاستلام والدفع | Refused receive and pay | Failed delivery |
| 26 | في الطريق إلي الفرع | On the way to branch | HANDED_TO_SHIPPING |
| 27 | في الطريق للراسل | On the way to sender | Return flow |
| 28 | تخصيص البيك أب | Pickup assigned | PREPARING |
| 29 | تم الاستلام في المخزن (اعادة تشغيل) | Received in warehouse (restart) | HANDED_TO_SHIPPING |
| 100 | معلقة (متابعة مع الراسل) | Pending (follow up with sender) | Keep current + note |
| 105 | مرتجعات انتجريشن | Integration returns | Return flow |
| 110 | خروج للمخزن وعدم وصول | Left for warehouse, did not arrive | Note |
| 115 | استلام انتجريشن | Integration receive | HANDED_TO_SHIPPING |
| 120 | وصول لمخزن خطأ | Wrong warehouse arrival | Note |
| 125 | استلام في الفرع | Received at branch | HANDED_TO_SHIPPING |
| 135 | مرتجعات فى الطريق | Returns on the way | Return flow |
| 400 | توجيه لجهة التوزيع | Routing to distribution | IN_DELIVERY / note |
| 450 | توجيه من جهة التوزيع | Routing from distribution | IN_DELIVERY / note |

**Webhook response example (Mega sends to your endpoint):**

```json
{
  "response": [
    {
      "waybill": "TS879292",
      "status_id": "13",
      "ar_status": "فشل التسليم",
      "status_en": "Delivery Failed",
      "notes": "Status Note",
      "reason": "فشل التسليم",
      "scheduled": "2024-07-10 05:20 AM",
      "store": "فرع المهندسين",
      "order_id": "EM12848",
      "client_id": "121845"
    }
  ]
}
```

Your webhook handler must: (1) verify request is from Mega (get auth method from them), (2) parse `response` array, (3) for each item find Order by `order_id` (your orderNumber), (4) map `status_id` using table above, (5) update Order and OrderStatusHistory, (6) return 200 OK.

**API base:** All Mega requests go to `https://mega-technology.info/api/shipment.php?action=<action>`. Use HTTPS only. Response times typically under 500ms. Rate limit: 50 requests per minute.

---

This document is the single source of truth for building the Dar Alabaya backend from A to production. Implement every section; use the checklist before going live; keep the structure simple and maintainable. When in doubt, prefer clarity and security over cleverness.
