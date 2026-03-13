# 💧 JALARAKSHA - Water-Borne Disease Early Detection Platform
### Complete Health Monitoring System with Mobile App & WhatsApp Chatbot
#### Rural Maharashtra Health Monitoring System

---

## 📋 Project Overview

**JALARAKSHA** is a comprehensive health monitoring platform designed to empower rural communities in Maharashtra, India to detect, report, and respond to water-borne disease outbreaks early. The platform consists of:

1. **📱 Flutter Mobile App** - Complete health reporting and monitoring system
2. **🤖 WhatsApp Chatbot** - AI-powered health assistant for WhatsApp users
3. **🔥 Firebase Backend** - Unified database and real-time synchronization

By bridging the gap between remote villages and health authorities, this platform aims to reduce outbreak severity through timely reporting and alerts.

---

## 🏗️ System Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │ WhatsApp Bot    │    │   Firebase      │
│                 │    │                 │    │                 │
│ • Villagers     │◄──►│ • AI Assistant  │◄──►│ • Firestore DB  │
│ • ASHA Workers  │    │ • Voice Support │    │ • Authentication│
│ • Officials     │    │ • Multi-language│    │ • Cloud Storage │
│ • 5 Languages   │    │ • Gemini AI     │    │ • Push Notifications│
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

---

## 🚨 Problem Statement

Maharashtra's rural communities face recurring outbreaks of water-borne diseases such as:
- **Cholera**, **Typhoid**, **Hepatitis A**, **Dysentery**, and **Giardiasis**

Key challenges include:
- Lack of early reporting mechanisms in remote villages
- Poor connectivity between villagers and health authorities
- No centralized system for outbreak tracking
- Language and literacy barriers in digital reporting
- Limited smartphone access in rural areas
- Inadequate awareness of prevention measures

---

## ✅ Solution Overview

A comprehensive multi-platform system that enables:

### 📱 Mobile App Features
1. **Villagers** - Report symptoms and view community health status
2. **ASHA Health Workers** - Monitor reports and manage community health
3. **Government Officials** - Dashboard analytics and outbreak management
4. **Multi-language Support** - English, Hindi, Marathi, Tamil, Telugu

### 🤖 WhatsApp Chatbot Features
1. **AI-Powered Health Assistant** - Gemini AI for symptom detection
2. **Voice Message Support** - Speech-to-text transcription
3. **Multi-language Conversations** - Marathi, Hindi, English
4. **Location-based Reporting** - District and village selection
5. **Automated Alerts** - Integration with mobile app alert system

Both platforms work together, sharing the same Firebase database for unified health monitoring.

---

## 🎯 Features Implemented

### 📱 Mobile App Features
| Feature | Status |
|---|---|
| **Authentication & User Management** | |
| Firebase Integration (Auth, Firestore, Storage, FCM) | ✅ |
| Role-Based Authentication (Villager/ASHA/Government) | ✅ |
| Enhanced Login/Signup UI | ✅ |
| **Multi-language Support** | |
| 5 Languages (English, Hindi, Marathi, Tamil, Telugu) | ✅ |
| Complete UI Translation | ✅ |
| Language Settings & Persistence | ✅ |
| **Health Reporting System** | |
| Quick Report Form on Dashboard | ✅ |
| Symptom Reporting with GPS Location | ✅ |
| Community Health Reports with Disease Counts | ✅ |
| Location-based Disease Aggregation | ✅ |
| **Alert & Notification System** | |
| Real-time Health Alerts | ✅ |
| Push Notifications (FCM) | ✅ |
| Alert Severity Levels (Warning/Critical) | ✅ |
| **Role-based Navigation** | |
| Villager Dashboard (4 tabs: Home, Map, Alerts, More) | ✅ |
| ASHA Worker Dashboard (5 tabs: + Reports) | ✅ |
| Dynamic Navigation based on User Role | ✅ |
| **Dashboard & Analytics** | |
| Real-time Statistics (Today's Reports, Active Alerts) | ✅ |
| Village Safety Status | ✅ |
| Interactive Alert Cards | ✅ |

### 🤖 WhatsApp Chatbot Features
| Feature | Status |
|---|---|
| **AI Integration** | |
| Gemini AI for Symptom Detection | ✅ |
| Natural Language Processing | ✅ |
| Intent Recognition | ✅ |
| **Multi-language Support** | |
| Marathi Language Support | ✅ |
| Hindi Language Support | ✅ |
| English Language Support | ✅ |
| **WhatsApp Integration** | |
| Message Processing | ✅ |
| Voice Message Transcription | ✅ |
| Interactive Menus | ✅ |
| **Location & Reporting** | |
| Maharashtra District Selection | ✅ |
| Village Selection | ✅ |
| Health Report Generation | ✅ |
| Firebase Integration | ✅ |
| **Session Management** | |
| User Context Tracking | ✅ |
| Language Preferences | ✅ |
| Location Memory | ✅ |

---

## 🔥 Firebase Setup Guide

### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add Project"** → Name it `waterborne-detection`
3. Enable **Google Analytics** (optional but recommended)

### Step 2: Add Android App
1. Click **"Add App"** → Select Android
2. Enter package name: `com.northeast.waterborne`
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

### Step 3: Add iOS App
1. Click **"Add App"** → Select iOS
2. Enter bundle ID: `com.northeast.waterborne`
3. Download `GoogleService-Info.plist`
4. Place it in: `ios/Runner/GoogleService-Info.plist`

### Step 4: Enable Firebase Services
In Firebase Console, enable:
- **Authentication** → Email/Password provider
- **Cloud Firestore** → Start in test mode
- **Firebase Storage** → Default bucket
- **Cloud Messaging** → No setup needed

### Step 5: Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    match /symptom_reports/{doc} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    match /water_reports/{doc} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    match /alerts/{doc} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.role == 'health_worker' 
                   || request.auth.token.role == 'government';
    }
  }
}
```

### Step 6: Google Maps API Key
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable **Maps SDK for Android** and **Maps SDK for iOS**
3. Create an API key
4. Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_API_KEY_HERE"/>
```

---

## 🚀 How to Run the Project

### 📱 Mobile App Setup

#### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Firebase project configured (see Firebase setup below)

#### Steps
```bash
# 1. Clone repository
git clone https://github.com/yashbhongale78-sys/JalRakshak.git
cd JalRakshak

# 2. Install dependencies
flutter pub get

# 3. Run app
flutter run
```

### 🤖 WhatsApp Chatbot Setup

#### Prerequisites
- Python 3.9+
- WhatsApp Business API access
- Gemini AI API key
- Firebase service account

#### Steps
```bash
# 1. Navigate to backend
cd backend

# 2. Install dependencies
pip install -r requirements.txt

# 3. Setup environment variables
cp .env.example .env
# Edit .env with your API keys

# 4. Add Firebase credentials
# Place firebase_key.json in backend folder

# 5. Run the server
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

#### Environment Variables (.env)
```env
# Gemini AI
GEMINI_API_KEY=your_gemini_api_key

# WhatsApp Business API
WHATSAPP_TOKEN=your_whatsapp_token
WHATSAPP_PHONE_ID=your_phone_number_id
VERIFY_TOKEN=your_webhook_verify_token

# Firebase
FIREBASE_PROJECT_ID=waterborne-detection
```

### Environment Requirements
- **Mobile App**: Minimum Android SDK 21, iOS 12.0
- **Backend**: Python 3.9+, FastAPI, Firebase Admin SDK

---

## 📁 Project Structure

```
JalRakshak/
├── lib/                          # Flutter Mobile App
│   ├── core/                     # App-wide constants, theme, localization
│   ├── data/                     # Models, repositories, Firebase services  
│   ├── features/                 # Auth, villager, reports feature modules
│   ├── presentation/             # Shared screens, widgets, providers
│   └── main.dart                 # App entry point
├── backend/                      # WhatsApp Chatbot Backend
│   ├── main.py                   # FastAPI application entry point
│   ├── ai.py                     # Gemini AI integration
│   ├── whatsapp.py              # WhatsApp API integration
│   ├── firebase_db.py           # Firebase database operations
│   ├── sessions.py              # User session management
│   ├── menu.py                  # Interactive menu systems
│   ├── requirements.txt         # Python dependencies
│   └── README.md                # Backend documentation
├── android/                     # Android-specific files
├── ios/                         # iOS-specific files
└── README.md                    # This file
```

---

## 🛣️ Development Roadmap

- **Phase 1** ✅ → Foundation + Authentication + Basic Reporting
- **Phase 2** ✅ → Multi-language Support + Role-based Navigation  
- **Phase 3** ✅ → WhatsApp Chatbot + AI Integration
- **Phase 4** 🔜 → Advanced Analytics + ML Outbreak Prediction
- **Phase 5** 🔜 → SMS Alerts + Offline Sync Enhancement

---

## 👥 Target Users

### Primary Users
- **Villagers** in rural Maharashtra reporting health issues
- **ASHA Health Workers** monitoring community health
- **Government Health Officials** managing district-level health data

### Access Methods
- **Smartphone Users** → Flutter Mobile App
- **WhatsApp Users** → AI Chatbot (no app installation needed)
- **Feature Phone Users** → SMS integration (planned)

---

## 🌍 Geographic Coverage

**Current**: Maharashtra State, India
- All 36 districts supported
- Village-level location tracking
- Division-wise organization (Konkan, Pune, Nashik, Aurangabad, Amravati, Nagpur)

**Planned**: Expansion to other Indian states

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📞 Support

For support and queries:
- **Issues**: [GitHub Issues](https://github.com/yashbhongale78-sys/JalRakshak/issues)
- **Documentation**: Check individual README files in `/backend` folder
- **Firebase Setup**: Follow the detailed Firebase setup guide above

---

*Built with ❤️ for Maharashtra's rural communities*
