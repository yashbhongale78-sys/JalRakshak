# Visual Guide - Quick Report & Community Health Features

## 📱 Home Screen - Quick Report Form (New Position)

```
┌─────────────────────────────────────┐
│  🏠 Home                      🔔 👤 │
├─────────────────────────────────────┤
│                                     │
│  💧 JALARAKSHA Active               │
│  System monitoring 45 villages      │
│                                     │
│  📊 Statistics                      │
│  ┌──────┐ ┌──────┐ ┌──────┐       │
│  │ 12   │ │  3   │ │ 45   │       │
│  │Today │ │Alerts│ │ Safe │       │
│  └──────┘ └──────┘ └──────┘       │
│                                     │
│  🚨 Active Alerts                   │
│  ┌───────────────────────────────┐ │
│  │ ⚠️  Fever Outbreak Alert      │ │
│  │ 5 cases in Guwahati           │ │
│  │ [Resolve] [Dispatch]          │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ ➕ Quick Report              │ │
│  ├───────────────────────────────┤ │
│  │                               │ │
│  │ 👤 Name                       │ │
│  │ [John Doe            ]        │ │
│  │                               │ │
│  │ 📍 Location                   │ │
│  │ [Guwahati, Kamrup    ]        │ │
│  │                               │ │
│  │ 🏥 Disease/Symptom            │ │
│  │ [Fever              ▼]        │ │
│  │                               │ │
│  │ ⚠️  Caused By                 │ │
│  │ [Contaminated Water ▼]        │ │
│  │                               │ │
│  │ 📝 Additional Details         │ │
│  │ [Optional...         ]        │ │
│  │                               │ │
│  │  ┌─────────────────────────┐ │ │
│  │  │   Submit Report         │ │ │
│  │  └─────────────────────────┘ │ │
│  └───────────────────────────────┘ │
│                                     │
│  📋 Recent Reports                  │
│  ┌───────────────────────────────┐ │
│  │ Fever - Guwahati              │ │
│  │ 2 hours ago                   │ │
│  └───────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

## 📊 Community Health Reports Screen

```
┌─────────────────────────────────────┐
│  ← Community Health Reports         │
├─────────────────────────────────────┤
│                                     │
│  [All] [High Risk] [Medium] [Low]  │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ 📍 Guwahati              🔴   │ │
│  │    Kamrup, Assam         HIGH │ │
│  │                               │ │
│  │    👥 12 Total Cases          │ │
│  │    Updated 2 hours ago        │ │
│  │                               │ │
│  │    Disease Breakdown:         │ │
│  │    • Fever         5 cases    │ │
│  │    • Diarrhea      4 cases    │ │
│  │    • Cholera       3 cases    │ │
│  │                               │ │
│  │    [View Details]             │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ 📍 Jorhat               🟡    │ │
│  │    Jorhat, Assam        MEDIUM│ │
│  │                               │ │
│  │    👥 7 Total Cases           │ │
│  │    Updated 5 hours ago        │ │
│  │                               │ │
│  │    Disease Breakdown:         │ │
│  │    • Fever         4 cases    │ │
│  │    • Vomiting      3 cases    │ │
│  │                               │ │
│  │    [View Details]             │ │
│  └───────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

## 🚨 Automatic Alert Creation

```
When 3+ reports submitted:
┌─────────────────────────────────────┐
│  ⚠️  WARNING ALERT CREATED          │
├─────────────────────────────────────┤
│                                     │
│  Fever Outbreak Alert               │
│                                     │
│  3 cases of Fever reported in       │
│  Guwahati in the last 24 hours.     │
│                                     │
│  Severity: Warning                  │
│  Location: Guwahati, Kamrup         │
│  Status: Active                     │
│                                     │
└─────────────────────────────────────┘

When 5+ reports submitted:
┌─────────────────────────────────────┐
│  🔴 CRITICAL ALERT CREATED          │
├─────────────────────────────────────┤
│                                     │
│  Fever Outbreak Alert               │
│                                     │
│  5 cases of Fever reported in       │
│  Guwahati in the last 24 hours.     │
│                                     │
│  Severity: Critical                 │
│  Location: Guwahati, Kamrup         │
│  Status: Active                     │
│                                     │
│  [Resolve] [Dispatch] [Escalate]    │
│                                     │
└─────────────────────────────────────┘
```

## 🔄 Data Flow Diagram

```
┌─────────────┐
│   User      │
│ Submits     │
│  Report     │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────┐
│  Quick Report Form              │
│  • Name: John Doe               │
│  • Location: Guwahati           │
│  • Disease: Fever               │
│  • Cause: Contaminated Water    │
└──────┬──────────────────────────┘
       │
       ▼
┌─────────────────────────────────┐
│  System Processing              │
│  1. Capture GPS (lat/lng)       │
│  2. Calculate severity          │
│  3. Get user info               │
└──────┬──────────────────────────┘
       │
       ├──────────────────────────┐
       │                          │
       ▼                          ▼
┌─────────────┐          ┌─────────────────┐
│  Firebase   │          │  Community      │
│  reports    │          │  Aggregation    │
│  Collection │          │  Update         │
│             │          │                 │
│  + New      │          │  Fever: 4 → 5   │
│    Report   │          │  Total: 8 → 9   │
│    Saved    │          │  Risk: MED      │
└─────────────┘          └────────┬────────┘
                                  │
                                  ▼
                         ┌─────────────────┐
                         │  Alert Check    │
                         │                 │
                         │  Count recent   │
                         │  reports:       │
                         │  • Same disease │
                         │  • Same location│
                         │  • Last 24h     │
                         └────────┬────────┘
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
                    ▼                           ▼
            ┌──────────────┐          ┌──────────────┐
            │  < 3 reports │          │  ≥ 3 reports │
            │              │          │              │
            │  No Alert    │          │  Create      │
            │              │          │  Alert       │
            └──────────────┘          └──────┬───────┘
                                             │
                                             ▼
                                    ┌─────────────────┐
                                    │  Alert Created  │
                                    │  in Firebase    │
                                    │                 │
                                    │  Users notified │
                                    └─────────────────┘
```

## 📈 Risk Level Calculation

```
Total Cases in Location:

0-4 cases   →  🟢 LOW Risk
5-9 cases   →  🟡 MEDIUM Risk
10+ cases   →  🔴 HIGH Risk

Example:
┌─────────────────────────────────┐
│  Guwahati, Kamrup               │
│                                 │
│  Fever:     5 cases             │
│  Diarrhea:  3 cases             │
│  Cholera:   2 cases             │
│  ─────────────────              │
│  Total:     10 cases            │
│                                 │
│  Risk Level: 🔴 HIGH            │
└─────────────────────────────────┘
```

## 🎯 User Journey

```
1. User Opens App
   ↓
2. Sees Quick Report on Home
   ↓
3. Form Pre-filled with User Data
   ↓
4. Selects Disease & Cause
   ↓
5. Adds Optional Details
   ↓
6. Clicks Submit
   ↓
7. GPS Location Captured
   ↓
8. Report Saved to Firebase
   ↓
9. Community Stats Updated
   ↓
10. Alert Check Performed
    ↓
11. Success Message Shown
    ↓
12. Form Cleared
    ↓
13. User Can View in Community Reports
```

## 🔔 Notification Flow

```
Report Submitted
    ↓
Alert Threshold Met (3+ cases)
    ↓
┌─────────────────────────────────┐
│  🔔 Notification Bell           │
│     Shows Red Dot               │
└─────────────────────────────────┘
    ↓
User Clicks Bell
    ↓
┌─────────────────────────────────┐
│  Alerts Screen Opens            │
│                                 │
│  🔴 Fever Outbreak Alert        │
│     5 cases in Guwahati         │
│     Status: Active              │
│                                 │
│  🟡 Diarrhea Warning            │
│     3 cases in Jorhat           │
│     Status: Active              │
└─────────────────────────────────┘
```

## 📱 Mobile Screen Sizes

### Phone (Portrait)
```
┌──────────┐
│  Header  │
├──────────┤
│          │
│  Quick   │
│  Report  │
│  Form    │
│          │
├──────────┤
│  Stats   │
├──────────┤
│  Reports │
└──────────┘
```

### Tablet (Landscape)
```
┌────────────────────────────────┐
│         Header                 │
├──────────────┬─────────────────┤
│              │                 │
│  Quick       │   Community     │
│  Report      │   Reports       │
│  Form        │   List          │
│              │                 │
├──────────────┼─────────────────┤
│  Statistics  │   Alerts        │
└──────────────┴─────────────────┘
```

## 🎨 Color Coding

```
Risk Levels:
🟢 LOW      - Green  (#4CAF50)
🟡 MEDIUM   - Orange (#FF9800)
🔴 HIGH     - Red    (#F44336)

Severity:
🔵 Low      - Blue   (#2196F3)
🟡 Medium   - Orange (#FF9800)
🔴 High     - Red    (#F44336)

Status:
⚪ Pending   - Gray   (#9E9E9E)
🔵 Active    - Blue   (#2196F3)
🟢 Resolved  - Green  (#4CAF50)
```

## 📊 Dashboard Statistics

```
┌─────────────────────────────────────┐
│  Today's Reports        12          │
│  ↑ +3 from yesterday                │
├─────────────────────────────────────┤
│  Active Alerts          3           │
│  🔴 1 critical                      │
├─────────────────────────────────────┤
│  Villages Safe          45          │
│  📊 85% coverage                    │
├─────────────────────────────────────┤
│  Response Rate          94%         │
│  ⏱️  Avg 2.3 hrs                    │
└─────────────────────────────────────┘
```

---

This visual guide shows how the features look and work together in the app!
