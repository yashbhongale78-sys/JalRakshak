# Role-Based Navigation Guide

## Overview
The app now supports two user types with different dashboards:

### 1. Villagers (role: `villager`)
**Bottom Navigation:** Home | Map | Alerts | More (4 tabs)
- Can report symptoms and water issues
- View alerts and maps
- Access community features

### 2. ASHA Workers (role: `health_worker`)
**Bottom Navigation:** Home | Map | **Reports** | Alerts | More (5 tabs)
- All villager features PLUS
- **Reports tab** - View and manage all community reports
- Monitor health data across villages

## How to Create Accounts

### Signup Screen
1. Open the app and click "Register"
2. Select your role:
   - **Villager** - For community members
   - **ASHA Worker** - For health workers
3. Fill in your details
4. Submit

### Login Screen
1. Enter email and password
2. Select account type from dropdown:
   - **Villagers**
   - **ASHA Worker**
3. Sign in

## Testing Different Roles

### To test as Villager:
1. Create account with "Villager" role
2. Login
3. You'll see: Home, Map, Alerts, More

### To test as ASHA Worker:
1. Create account with "ASHA Worker" role
2. Login  
3. You'll see: Home, Map, **Reports**, Alerts, More

## Switching Your Current Account Role

If you're logged in as a villager but want to test ASHA Worker features:

### Option 1: Create New Account
- Logout
- Register new account
- Select "ASHA Worker" role

### Option 2: Update Existing Account in Firebase
1. Go to Firebase Console
2. Navigate to Firestore Database
3. Find your user document in the `users` collection
4. Change the `role` field from `villager` to `health_worker`
5. Logout and login again

### Option 3: Use the Fix Button (if still on Coming Soon screen)
- Click "Switch to Villager Dashboard" button
- This updates your role in the database

## Current Implementation

- **Villagers**: 4 tabs (no Reports)
- **ASHA Workers**: 5 tabs (with Reports)
- Role is checked dynamically when the app loads
- Navigation adapts based on user role from Firebase

## Files Modified
- `lib/presentation/screens/main_navigation.dart` - Role-based navigation
- `lib/features/auth/screens/signup_screen.dart` - Role selection
- `lib/features/auth/screens/login_screen.dart` - Role dropdown
- `lib/main.dart` - Routing logic
