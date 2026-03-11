# 💧 Water-Borne Disease Early Detection Platform
### Part 1: Foundation, Authentication & Villager Features
#### Rural Northeast India Health Monitoring System

---

## 📋 Project Overview

The **Water-Borne Disease Early Detection Platform** is a Flutter mobile application designed to empower rural communities in Northeast India to detect, report, and respond to water-borne disease outbreaks early. By bridging the gap between remote villages and health authorities, this platform aims to reduce outbreak severity through timely reporting and alerts.

---

## 🚨 Problem Statement

Northeast India's rural communities face recurring outbreaks of water-borne diseases such as:
- **Cholera**, **Typhoid**, **Hepatitis A**, **Dysentery**, and **Giardiasis**

Key challenges include:
- Lack of early reporting mechanisms in remote villages
- Poor connectivity between villagers and health authorities
- No centralized system for outbreak tracking
- Language and literacy barriers in digital reporting
- Inadequate awareness of prevention measures

---

## ✅ Solution Overview

A mobile-first platform that enables:
1. **Villagers** to report symptoms and water contamination issues with or without internet
2. **Health Workers** to receive and respond to reports (Part 2)
3. **Government Officials** to monitor outbreaks on a dashboard (Part 2)

The app works **offline** using Hive local storage and syncs data to Firebase when connectivity is restored.

---

## 🎯 Features Implemented in Part 1

| Feature | Status |
|---|---|
| Firebase Integration (Auth, Firestore, Storage, FCM) | ✅ |
| Role-Based Authentication (Villager / Health Worker / Govt) | ✅ |
| Villager Dashboard | ✅ |
| Symptom Reporting with Photo Upload | ✅ |
| Water Contamination Reporting | ✅ |
| Outbreak Alerts Screen | ✅ |
| Prevention Tips Screen | ✅ |
| Nearby Clinics Map (Google Maps) | ✅ |
| Offline Reporting with Hive | ✅ |
| Auto-sync when internet returns | ✅ |
| Data Models (User, Symptom, Water, Alert) | ✅ |
| Loading indicators & Error handling | ✅ |

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

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Firebase project configured (see above)

### Steps
```bash
# 1. Clone repository
git clone https://github.com/your-org/waterborne-detection.git
cd waterborne-detection

# 2. Install dependencies
flutter pub get

# 3. Run code generation (for Hive adapters)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run app
flutter run
```

### Environment
- Minimum Android SDK: **21 (Android 5.0)**
- Minimum iOS: **12.0**
- Target Android SDK: **33**

---

## 📁 Project Structure

```
lib/
├── core/               # App-wide constants, theme, utilities
├── data/               # Models, repositories, Firebase services  
├── features/           # Auth, villager, reports feature modules
├── presentation/       # Shared screens, widgets, providers
└── main.dart           # App entry point
```

---

## 🛣️ Roadmap

- **Part 1** ✅ → Foundation + Villager Features
- **Part 2** 🔜 → Health Worker Dashboard + Government Analytics
- **Part 3** 🔜 → ML-based Outbreak Prediction + SMS Alerts

---

## 👥 Target Users

- **Villagers** in remote areas of Assam, Meghalaya, Manipur, Nagaland
- **ASHA Health Workers** making village rounds
- **State Health Department Officials**

---

*Built with ❤️ for Northeast India's rural communities*
