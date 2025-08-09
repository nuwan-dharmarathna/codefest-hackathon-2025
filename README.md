# 🌾 GoviChain - Direct Agricultural Marketplace

GoviChain is a **role-based digital marketplace** that directly connects farmers, small/medium entrepreneurs, and buyers—eliminating unnecessary intermediaries. Our platform ensures fair trade, transparency, and better profits for producers while providing buyers with fresh, quality products at competitive rates.

## 🚀 Key Features

### 👩‍🌾 Seller Features
- **Tailored seller dashboard**
- **Quantity-based pricing tiers** (e.g., 1-3kg @ Rs. 110/kg, 4-10kg @ Rs. 90/kg)
- **Tender notification system** for relevant product categories
- **Bid management** for buyer tenders
- **Purchase request handling** (accept/reject)

### 🛒 Buyer Features
- **Custom buyer dashboard**
- **Product browsing** by category/subcategory
- **Tender creation** for specific product quantities
- **Bid evaluation and acceptance**
- **Price comparison tools**

### 🔔 Platform Features
- **Real-time notifications** for tenders, bids, and purchases
- **Mock integrations** for SLUDI, NDX, and PayDPI (for competition purposes)
- **Role-based access control**
- **Transparent pricing system**

## 📋 Important Note: Service Integrations
*For competition purposes only* - The following mock validations are implemented pending official endpoints:

### SLUDI Validation
- Format: `SL` followed by exactly 6 digits
- Example: `SL123456` (valid)

### NDX Integration
- Mocked control price comparisons
- Simulated delivery cost calculations by region

### PayDPI
- Payment flow simulation (not implemented in backend)
- Will be replaced with real integration when available

## 🛠 Technology Stack
| Component        | Technology                          |
|------------------|-------------------------------------|
| Frontend         | Flutter (Cross-platform)            |
| Backend          | Node.js (Express + MongoDB)         |
| Authentication  | JWT-based secure access             |
| Deployment       | Docker containers                   |
| API Docs         | Swagger UI                          |

## 🚀 Getting Started
### Prerequisites
- Docker (for backend)
- Flutter SDK (for frontend)
- Git

### Backend Setup
```bash
docker pull nuwandharmarathna/govichain-backend:v1.0.0
docker run -p 8086:8086 nuwandharmarathna/govichain-backend:v1.0.0
```

### 2. Frontend Setup
# Clone the repository
```
git clone https://github.com/<your-username>/govichain.git
cd govichain-frontend
```

# Configure your local IP
utils/constants.dart

# Install dependencies
```
flutter clean
flutter pub get
```

# Select a target device (emulator or real device)
```
flutter run
```

## 📖 API Documentation

For local development, the API documentation is available via Swagger UI.

- **URL:** [http://localhost:8086/api-docs](http://localhost:8086/api-docs)  
- **Base URL:** `https://127.0.0.1:8086/api/v1`  

Swagger UI provides an interactive interface to explore all endpoints, request/response formats, and authentication requirements for the GoviChain backend.

> **Note:** Make sure your backend server is running before accessing Swagger UI.

## 🧑‍🤝‍🧑 Who Can Use GoviChain?

GoviChain is designed for both men and women, covering:

- **Farmers**
- **Fishermen**
- **Small/Medium food producers**
- **Craft product makers**
- **Agricultural suppliers**
- **And any other seller who wants to reach buyers directly**

## 📞 Contact

**Developer:** Nuwan Dharmarathna  
**Email:** [nuwandharmarathna20@gmail.com](mailto:nuwandharmarathna20@gmail.com)
