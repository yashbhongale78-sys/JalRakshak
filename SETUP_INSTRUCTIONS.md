# Setup Instructions

## Prerequisites

1. Flutter SDK installed
2. Firebase project created
3. Android Studio / VS Code
4. Physical device or emulator

## Step 1: Firebase Setup

### 1.1 Enable Firestore
```
1. Go to Firebase Console
2. Select your project
3. Click "Firestore Database"
4. Click "Create database"
5. Choose "Start in production mode"
6. Select location
7. Click "Enable"
```

### 1.2 Create Collections

Run this in Firebase Console > Firestore > Start collection:

#### Collection: `reports`
```javascript
// Sample document
{
  name: "John Doe",
  location: "Guwahati, Kamrup",
  symptom_type: "Fever",
  caused_by: "Contaminated Water",
  description: "High fever for 3 days",
  severity: "Low",
  lat: 26.1445,
  lng: 91.7362,
  submitted_by: "user_uid_here",
  timestamp: Timestamp.now(),
  status: "Pending",
  district: "Kamrup",
  village: "Guwahati",
  state: "Assam"
}
```

#### Collection: `community_reports`
```javascript
// Sample document (auto-created by app)
{
  location: "Guwahati",
  district: "Kamrup",
  state: "Assam",
  diseaseCounts: {
    "Fever": 5,
    "Diarrhea": 3
  },
  totalCases: 8,
  riskLevel: "MEDIUM",
  lastUpdated: Timestamp.now()
}
```

#### Collection: `alerts`
```javascript
// Sample document (auto-created by app)
{
  title: "Fever Outbreak Alert",
  message: "5 cases of Fever reported in Guwahati in the last 24 hours.",
  severity: "critical",
  district: "Kamrup",
  zone: "Guwahati",
  timestamp: Timestamp.now(),
  reportCount: 5,
  progress: 0.8,
  status: "Active"
}
```

### 1.3 Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Reports collection
    match /reports/{reportId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null 
        && request.resource.data.submitted_by == request.auth.uid;
      allow update: if request.auth != null;
    }
    
    // Community reports collection
    match /community_reports/{locationId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Alerts collection
    match /alerts/{alertId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

### 1.4 Create Indexes

Go to Firebase Console > Firestore > Indexes and create:

#### Index 1: Reports by location and time
```
Collection: reports
Fields:
  - village (Ascending)
  - district (Ascending)
  - symptom_type (Ascending)
  - timestamp (Descending)
```

#### Index 2: Community reports by risk
```
Collection: community_reports
Fields:
  - riskLevel (Ascending)
  - totalCases (Descending)
```

#### Index 3: Alerts by district
```
Collection: alerts
Fields:
  - district (Ascending)
  - timestamp (Descending)
```

## Step 2: Android Permissions

### 2.1 Update AndroidManifest.xml

File: `android/app/src/main/AndroidManifest.xml`

Add these permissions before `<application>`:

```xml
<!-- Location permissions -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

<!-- Internet permission -->
<uses-permission android:name="android.permission.INTERNET" />
```

## Step 3: iOS Permissions

### 3.1 Update Info.plist

File: `ios/Runner/Info.plist`

Add these keys:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to accurately report disease cases in your area</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to accurately report disease cases in your area</string>
```

## Step 4: Install Dependencies

Run in terminal:

```bash
flutter pub get
```

Verify these packages are in `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  
  # Location
  geolocator: ^11.0.0
  
  # State Management
  flutter_riverpod: ^2.4.9
  
  # UI
  google_maps_flutter: ^2.5.0
  
  # Utils
  intl: ^0.18.1
  timeago: ^3.6.0
```

## Step 5: Run the App

### 5.1 Clean and Build

```bash
flutter clean
flutter pub get
flutter run
```

### 5.2 For Android

```bash
flutter run -d android
```

### 5.3 For iOS

```bash
flutter run -d ios
```

## Step 6: Test the Features

### Test 1: Quick Report Submission

1. Login to the app
2. Go to Home screen
3. Scroll to "Quick Report" card
4. Verify name and location are pre-filled
5. Select "Fever" from disease dropdown
6. Select "Contaminated Water" from cause dropdown
7. Add optional description
8. Click "Submit Report"
9. Verify success message appears
10. Check Firebase Console > Firestore > reports collection
11. Verify new document was created

### Test 2: Community Aggregation

1. Submit 2-3 reports with same disease and location
2. Go to Firebase Console > Firestore > community_reports
3. Verify document exists for that location
4. Verify disease count is correct
5. Verify totalCases is updated
6. Verify riskLevel is calculated

### Test 3: Alert Creation

1. Submit 3 reports of same disease in same location
2. Go to Firebase Console > Firestore > alerts
3. Verify warning alert was created
4. Submit 2 more reports (total 5)
5. Verify critical alert was created
6. Check alert severity is "critical"

### Test 4: Community Reports Screen

1. Click "Community Health Reports" button on home
2. Verify locations are listed
3. Verify disease counts are shown
4. Click filter chips (All/High/Medium/Low)
5. Verify filtering works
6. Click "View Details" on a location
7. Verify modal shows correct data

### Test 5: Navigation

1. Click notification bell → should go to Alerts
2. Click "View All" reports → should go to Reports
3. Click "Open Full Map" → should go to Map
4. Verify all buttons work without errors

## Step 7: Troubleshooting

### Issue: Location permission denied

**Solution:**
```
1. Go to device Settings
2. Apps → Your App → Permissions
3. Enable Location permission
4. Restart the app
```

### Issue: Firebase connection error

**Solution:**
```
1. Verify google-services.json is in android/app/
2. Verify GoogleService-Info.plist is in ios/Runner/
3. Run: flutter clean && flutter pub get
4. Rebuild the app
```

### Issue: Reports not appearing

**Solution:**
```
1. Check Firebase Console > Firestore
2. Verify collections exist
3. Check Firestore security rules
4. Verify user is authenticated
5. Check console for errors
```

### Issue: Alerts not creating

**Solution:**
```
1. Verify 3+ reports submitted
2. Check same disease and location
3. Check timestamp is within 24 hours
4. Verify Firestore indexes are created
5. Check console for errors
```

### Issue: Community reports not updating

**Solution:**
```
1. Check Firestore security rules
2. Verify transaction is completing
3. Check console for errors
4. Verify document ID format: {village}_{district}_{state}
```

## Step 8: Production Deployment

### 8.1 Update Firestore Rules

Change to production rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 8.2 Enable Analytics

```
1. Go to Firebase Console
2. Click Analytics
3. Enable Google Analytics
4. Link to your project
```

### 8.3 Build Release APK

```bash
flutter build apk --release
```

### 8.4 Build iOS Release

```bash
flutter build ios --release
```

## Step 9: Monitoring

### 9.1 Enable Crashlytics

```yaml
# Add to pubspec.yaml
dependencies:
  firebase_crashlytics: ^3.4.9
```

```dart
// Add to main.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  
  runApp(MyApp());
}
```

### 9.2 Monitor Firestore Usage

```
1. Go to Firebase Console
2. Click Firestore Database
3. Click Usage tab
4. Monitor reads/writes/deletes
5. Set up billing alerts
```

## Step 10: Backup Strategy

### 10.1 Export Firestore Data

```bash
gcloud firestore export gs://[BUCKET_NAME]
```

### 10.2 Schedule Automatic Backups

```
1. Go to Firebase Console
2. Click Firestore Database
3. Click Import/Export
4. Set up scheduled exports
```

## Support

For issues or questions:
1. Check documentation files
2. Review Firebase Console logs
3. Check Flutter console output
4. Review Firestore security rules

## Quick Reference

### Important Files
- `lib/presentation/widgets/quick_report_card.dart` - Quick report form
- `lib/presentation/screens/community_reports_screen.dart` - Community reports
- `lib/data/services/community_reports_service.dart` - Backend logic

### Firebase Collections
- `reports` - Individual disease reports
- `community_reports` - Aggregated data by location
- `alerts` - Automatic alerts

### Key Features
- ✅ Quick report form on home screen
- ✅ Automatic GPS location capture
- ✅ Community aggregation by location
- ✅ Automatic alert creation
- ✅ Real-time updates
- ✅ Risk level calculation

---

**Setup Complete!** 🎉

Your app is now ready to track disease reports and create automatic alerts!
