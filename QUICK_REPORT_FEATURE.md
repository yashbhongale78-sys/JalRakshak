# Quick Report Feature Documentation

## Overview
Added a Quick Report form directly on the home screen that allows users to quickly submit disease reports. The form automatically connects to Firebase and creates alerts when thresholds are met.

## Features Implemented

### 1. Quick Report Card Widget
**Location**: `lib/presentation/widgets/quick_report_card.dart`

#### Form Fields:
1. **Name** - Auto-populated from user profile
2. **Location** - Auto-populated from user's village and district
3. **Disease/Symptom** - Dropdown with options:
   - Fever
   - Diarrhea
   - Vomiting
   - Skin Rash
   - Cholera
   - Typhoid
   - Jaundice
   - Other (shows text field to type custom disease)

4. **Specify Disease/Symptom** - Text field (appears only when "Other" is selected)
   - Allows users to type any disease name
   - Required when "Other" is selected
   - Validates that field is not empty

5. **Caused By** - Dropdown with options:
   - Contaminated Water
   - Poor Sanitation
   - Food Poisoning
   - Unknown
   - Other

5. **Additional Details** - Optional text area for more information

6. **Submit Button** - Submits the report to Firebase

### 2. Automatic Features

#### A. Location Capture
- Automatically requests and captures GPS coordinates (lat/lng)
- Falls back gracefully if location permission is denied
- Uses `geolocator` package for accurate positioning

#### B. Severity Calculation
Automatically calculates severity based on disease type:
- **High Severity**: Cholera, Typhoid, Jaundice
- **Medium Severity**: Diarrhea, Vomiting
- **Low Severity**: Fever, Skin Rash, Other

#### C. Community Aggregation
When a report is submitted:
1. Updates `community_reports` collection
2. Increments disease count for that location
3. Recalculates total cases
4. Updates risk level (LOW/MEDIUM/HIGH)
5. Updates timestamp

#### D. Automatic Alert Creation
Creates alerts when thresholds are met:
- **Warning Alert**: 3+ cases of same disease in 24 hours
- **Critical Alert**: 5+ cases of same disease in 24 hours

Alert includes:
- Title: "{Disease} Outbreak Alert"
- Message: "{count} cases of {disease} reported in {village} in the last 24 hours"
- Severity: warning or critical
- Location details
- Report count
- Progress indicator

### 3. Database Integration

#### Reports Collection
```javascript
{
  name: "John Doe",
  location: "Guwahati, Kamrup",
  symptom_type: "Fever",
  caused_by: "Contaminated Water",
  description: "High fever for 3 days",
  severity: "Low",
  lat: 26.1445,
  lng: 91.7362,
  submitted_by: "user_uid",
  timestamp: Timestamp,
  status: "Pending",
  district: "Kamrup",
  village: "Guwahati",
  state: "Assam"
}
```

#### Community Reports Collection
```javascript
{
  location: "Guwahati",
  district: "Kamrup",
  state: "Assam",
  diseaseCounts: {
    "Fever": 5,
    "Diarrhea": 3,
    "Cholera": 1
  },
  totalCases: 9,
  riskLevel: "MEDIUM",
  lastUpdated: Timestamp
}
```

#### Alerts Collection
```javascript
{
  title: "Fever Outbreak Alert",
  message: "5 cases of Fever reported in Guwahati in the last 24 hours.",
  severity: "critical",
  district: "Kamrup",
  zone: "Guwahati",
  timestamp: Timestamp,
  reportCount: 5,
  progress: 0.8,
  status: "Active"
}
```

### 4. UI Integration

#### Added to Villager Dashboard
- Positioned after the Survey Banner
- Before the Map Section
- Easily accessible on home screen

#### Added to Main Dashboard
- Positioned after the Welcome Card
- Before the Stats Section
- Available to all user types

### 5. User Experience Flow

```
User opens app
  ↓
Sees Quick Report Card on home screen
  ↓
Form auto-fills name and location
  ↓
User selects disease and cause
  ↓
(Optional) Adds description
  ↓
Clicks Submit
  ↓
System captures GPS location
  ↓
Report saved to Firebase
  ↓
Community aggregation updated
  ↓
Alert check performed
  ↓
If threshold met → Alert created
  ↓
Success message shown
  ↓
Form cleared for next report
```

### 6. Alert Threshold Logic

```javascript
// Check recent reports in same location
const recentReports = reports in last 24 hours
  .where(village == user.village)
  .where(district == user.district)
  .where(symptom_type == selected_disease)

if (recentReports.count >= 5) {
  createAlert(severity: 'critical')
} else if (recentReports.count >= 3) {
  createAlert(severity: 'warning')
}
```

### 7. Error Handling

- Validates all required fields
- Handles location permission denial gracefully
- Shows user-friendly error messages
- Prevents duplicate submissions with loading state
- Catches and displays Firebase errors

### 8. Security Features

- Requires user authentication
- Validates user session before submission
- Stores submitter UID for tracking
- Prevents anonymous submissions

### 9. Testing the Feature

#### Test Case 1: Submit Single Report
1. Open app and login
2. Scroll to Quick Report Card
3. Verify name and location are pre-filled
4. Select "Fever" and "Contaminated Water"
5. Click Submit
6. Verify success message
7. Check Firebase console for new report

#### Test Case 2: Trigger Warning Alert
1. Submit 3 reports of same disease
2. From same location
3. Within 24 hours
4. Verify warning alert is created
5. Check alerts collection in Firebase

#### Test Case 3: Trigger Critical Alert
1. Submit 5 reports of same disease
2. From same location
3. Within 24 hours
4. Verify critical alert is created
5. Check alert severity is "critical"

#### Test Case 4: Community Aggregation
1. Submit report for "Fever"
2. Check community_reports collection
3. Verify Fever count incremented
4. Verify totalCases updated
5. Verify riskLevel calculated correctly

### 10. Permissions Required

Add to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

Add to `Info.plist` (iOS):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to accurately report disease cases in your area</string>
```

### 11. Future Enhancements

- [ ] Add photo upload for symptoms
- [ ] Voice input for description
- [ ] Offline support with sync
- [ ] Push notifications for nearby alerts
- [ ] Multi-language support
- [ ] Report history for user
- [ ] Edit/delete submitted reports
- [ ] Share reports with health officials
- [ ] Export reports as PDF
- [ ] Analytics dashboard

### 12. Performance Considerations

- Form validation is instant (no API calls)
- Location capture is async (doesn't block UI)
- Firebase writes are batched when possible
- Alert checks use indexed queries
- Community aggregation uses transactions (prevents race conditions)

### 13. Accessibility

- All form fields have proper labels
- Color contrast meets WCAG standards
- Touch targets are 48x48dp minimum
- Screen reader compatible
- Keyboard navigation supported

## Summary

The Quick Report feature provides a streamlined way for users to report disease cases directly from the home screen. It automatically:
- Captures location data
- Calculates severity
- Updates community statistics
- Creates alerts when needed
- Provides instant feedback

This makes disease surveillance more efficient and helps health officials respond quickly to potential outbreaks.
