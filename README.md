# 🌾 GoviChain

GoviChain is a **role-based digital marketplace** designed to connect **farmers, small/medium entrepreneurs, and buyers** directly — without unnecessary intermediaries.  
This platform enables sellers to list products with **quantity-based pricing tiers** and buyers to **post tenders**, allowing sellers to bid with competitive prices.  
The result: **fair trade, transparency, and better profits for producers**, while buyers get fresh, quality products at fair rates.

---

## 🚀 Features
- **Role-based system** — Buyers and Sellers get tailored dashboards.
- **Sellers** can:
  - List products with **quantity range pricing** (e.g., 1–3kg @ Rs. 110/kg, 4–10kg @ Rs. 90/kg, etc.)
  - Receive **tender notifications** from relevant categories.
  - Accept or reject purchase requests.
- **Buyers** can:
  - Browse products by category/subcategory.
  - Post tenders for specific product quantities.
  - Accept bids from sellers.
- **Real-time Notifications** for tenders, bids, and purchase request updates.
- **SLUDI, NDX, PayDPI** integration placeholders with mock validation flows for competition purposes.

---

## 📜 Important Note on SLUDI, NDX & PayDPI Integration
The competition **did not provide proper sandbox endpoints** for these services.  
To ensure functional flows in the prototype, we assumed **mock validation logic**:

### **SLUDI Validation**
- SLUDI number **must start with `SL`**
- Followed by **exactly 6 digits**
- Example: `SL123456` ✅

### **NDX Validation**
- Fetch **control prices** of products from NDX (mocked) and compare with sellers’ advertised prices.
- Fetch **mock delivery prices** for several districts/provinces to simulate delivery cost checks.

### **PayDPI**
- Pending official endpoints from organizers.
- Payment flows are **currently simulated** for the prototype.

> These assumptions are for **demo & evaluation purposes only** and will be replaced with real integrations when endpoints are provided.

---

## 🛠 Tech Stack
- **Frontend**: Flutter
- **Backend**: Node.js (Express, MongoDB)
- **Authentication**: JWT-based
- **Deployment-ready**: Docker

---

## ⚙️ Setup Instructions

### **1. Backend Setup**
No manual code setup needed — just pull the public Docker image and run:
```bash
docker pull nuwandharmarathna/govichain-backend:v1.0.0
```

### **2. Frontend Setup **
# Clone the repository
```
git clone https://github.com/<your-username>/govichain.git
cd govichain-frontend
```

# Update your local IP address in:
utils/constants.dart

# Clean and fetch dependencies
```
flutter clean
flutter pub get
```

# Select a target device (emulator or real device)
```
flutter run
```

## 🧑‍🤝‍🧑 Who Can Use GoviChain?

GoviChain is designed for both men and women, covering:

- **Farmers**
- **Fishermen**
- **Small/Medium food producers**
- **Craft product makers**
- **Agricultural suppliers**
- **And any other seller who wants to reach buyers directly**

## 👨‍💻 Developer

Nuwan Dharmarathna
nuwandharmarathna20@gmail.com
