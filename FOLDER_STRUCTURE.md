# 📁 Project Folder Structure — JalSuraksha (Part 1)

```
lib/
│
├── core/                          # App-wide foundational code
│   ├── constants/
│   │   └── app_constants.dart     # All constants: colors, roles, tips, clinics, Hive keys
│   ├── theme/
│   │   └── app_theme.dart         # Material theme, color palette, text styles
│   └── utils/
│       ├── app_utils.dart         # Date formatting, validation, helper functions
│       └── network_utils.dart     # Internet connectivity checker, stream
│
├── data/                          # Data layer (models, services, repositories)
│   ├── models/
│   │   ├── user_model.dart        # UserModel — Firestore serializable, roles
│   │   ├── symptom_report_model.dart  # SymptomReportModel — Hive + Firestore
│   │   ├── water_report_model.dart    # WaterReportModel — Hive + Firestore
│   │   └── alert_model.dart       # AlertModel — Firestore only (issued by health workers)
│   ├── repositories/
│   │   └── sync_repository.dart   # Coordinates offline → Firestore sync
│   └── services/
│       ├── auth_service.dart      # Firebase Auth: sign up, login, logout
│       ├── firestore_service.dart # All Firestore CRUD operations
│       ├── storage_service.dart   # Firebase Storage: photo uploads
│       ├── offline_storage_service.dart  # Hive local storage operations
│       └── notification_service.dart    # FCM setup, topic subscriptions
│
├── features/                      # Feature-based modules
│   ├── auth/
│   │   ├── screens/
│   │   │   ├── login_screen.dart  # Email/password login UI
│   │   │   └── signup_screen.dart # Registration with role selection
│   │   └── providers/
│   │       └── auth_provider.dart # Riverpod auth state management
│   ├── villager/
│   │   └── screens/
│   │       └── villager_dashboard.dart  # 6-card dashboard for villagers
│   └── reports/
│       └── screens/
│           ├── symptom_report_screen.dart  # Symptom reporting form
│           └── water_report_screen.dart    # Water contamination form
│
├── presentation/                  # Shared screens and widgets
│   └── screens/
│       ├── alerts_screen.dart     # Real-time outbreak alerts list
│       ├── prevention_tips_screen.dart  # Expandable health tips
│       └── nearby_clinics_screen.dart   # Google Maps with clinic markers
│
└── main.dart                      # App entry point, Firebase init, Hive init, routing
```

## Folder Responsibilities

| Folder | Purpose |
|--------|---------|
| `core/` | Constants, theme, and utility functions shared across the entire app |
| `data/models/` | Pure data classes with Firestore and Hive serialization |
| `data/services/` | Firebase-specific service classes (one responsibility each) |
| `data/repositories/` | Higher-level logic combining multiple services (e.g. sync) |
| `features/auth/` | Authentication screens and state management |
| `features/villager/` | Villager-specific UI (dashboard) |
| `features/reports/` | Report submission screens (symptom + water) |
| `presentation/screens/` | Shared screens used across feature modules |
| `main.dart` | App bootstrapping: Firebase, Hive, FCM, routing |
