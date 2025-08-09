# Solution Overview – GoviChain

## 🧩 Overview

GoviChain is a lightweight digital supply chain coordination platform for women-led rural SMEs in Sri Lanka. It enables sellers to manage product listings, accept orders, communicate delivery preferences, and receive secure escrow-based payments — all without needing complex infrastructure.

By integrating with Sri Lanka’s Digital Public Infrastructure (DPI) stack — SLUDI, NDX, and PayDPI — GoviChain ensures trust, data portability, and secure financial transactions between buyers and sellers.

---

## 🏛️ Architecture Sketch

**High-Level Components:**

- **Flutter Frontend (PWA / Mobile App):**
  - Buyer/Seller login via SLUDI
  - Product listings, order placement
  - Delivery preference: pickup / self-delivery toggle
  - Maps widget for viewing seller pickup location
  - Buyer request submission (optional feature)
  - Offer management interface for sellers and buyers

- **Node.js Backend (Express.js):**
  - API endpoints for products, orders, users, and buyer requests
  - Integration with:
    - SLUDI for auth
    - NDX for postal rates + logistics
    - PayDPI for payment flows
  - AI Agent for middleman detection
  - Swagger UI for documented OpenAPI spec

- **Sandbox Integrations:**
  - SLUDI-Sandbox for login flow
  - NDX-Sandbox for logistics/postal info
  - PayDPI-Sandbox for payment simulation

- **DevOps:**
  - Dockerized frontend and backend
  - Helm charts for Kubernetes deployment (to organizer-provided cluster)

---

## 🔐 DPI Integrations

| DPI Component | Purpose | Integration |
|---------------|---------|-------------|
| **SLUDI** | User authentication | Sellers & buyers login using SLUDI sandbox (OAuth 2.0 / OIDC) |
| **NDX** | Logistics & marketplace data | Backend fetches sample postal rates, SME registry, and maps delivery cost estimates |
| **PayDPI** | Payment system | Escrow-style payments: buyer pays upfront, seller receives payment after delivery confirmation |

---

## 🤖 AI Middleman Detection Agent

To maintain fairness and transparency in the marketplace, GoviChain includes an **AI-powered middleman detection system**.

### **How It Works:**
1. **Periodic Review:** The agent reviews each seller account at scheduled intervals.
2. **Data Collection:** Fetches:
   - Tenders posted
   - Accepted bids
   - Advertisements
   - Completed orders
3. **Behavior Analysis:** Uses rule-based and pattern recognition logic to check if the seller’s activity indicates:
   - Direct production (authentic seller)
   - Reselling without production (possible middleman behavior)
4. **Scoring:** Assigns a **Middleman Score** with reasoning.
5. **Admin Action:** High scores flag sellers for manual review by platform administrators.

### **Benefits:**
- Protects genuine producers from unfair competition.
- Improves buyer trust by ensuring product source transparency.
- Allows for early intervention before middleman abuse impacts the platform.

---

## 🔁 User Flows

### 👩‍🌾 Seller Flow
1. Login using SLUDI
2. Add products (name, description, price, delivery toggle, pickup location)
3. View incoming orders
4. Mark order as shipped / ready
5. Receive payment upon buyer confirmation

### 🛒 Buyer Flow
1. Login using SLUDI
2. Browse products
3. Select delivery preference (pickup or delivery)
4. Place order and initiate PayDPI payment
5. Confirm delivery → triggers seller payout

---

## ✨ Bonus Feature: Buyer Request System (Reverse Marketplace)

In addition to browsing seller listings, GoviChain allows buyers to post custom **product requests** (e.g., “Need 100kg onions”) and receive price offers from available sellers.

### 💼 Why This Matters:
- Encourages **competitive pricing**
- Surfaces **hidden seller inventory**
- Helps buyers source bulk orders from trusted micro-entrepreneurs
- Encourages **transparent, data-driven commerce**

### 🔄 Extended Flow:
#### Buyer:
1. Submit a new request (product + quantity + notes)
2. View incoming price offers
3. Accept one offer to initiate an order (auto-created)
4. Pay via PayDPI → receive product → confirm

#### Seller:
1. View open buyer requests
2. Submit price offers with optional notes (delivery available, etc.)
3. Get notified if selected
4. Fulfill the order as usual

## 🛡️ Security & Consent

- All users authenticated via SLUDI (OAuth 2.0)
- Data sharing (NDX) happens with fine-grained consent
- Buyer data is not exposed to sellers beyond order context
- Payments are escrow-based — no risk of fraud
- AI agent operates on internal transaction data, ensuring privacy
- Environment variables and tokens secured in Docker build

---

## 🧱 Modular & Scalable Design

- **Frontend decoupled** from DPI logic (handled in backend)
- Easily replace sandbox with production endpoints later
- Delivery system can be extended with real logistics APIs or GPS modules
- Buyer request system could support ratings, filters, and NLP in the future
- AI agent can be enhanced with machine learning models over time

---

GoviChain delivers a functional, realistic, and DPI-powered solution that balances tech feasibility with real-world usability — empowering micro-entrepreneurs to operate like pros, even with minimal tech access. The reverse marketplace model further enhances its potential as a dynamic, two-way trade platform for local communities, while the **AI Middleman Detection Agent** ensures a fair and transparent marketplace for all.
