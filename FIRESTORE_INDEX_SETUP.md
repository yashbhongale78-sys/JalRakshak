# Firestore Index Setup Guide

## Issue
The app requires a Firestore composite index for querying resolved alerts by date.

## Error Message
```
The query requires an index. You can create it here: [Firebase Console URL]
```

## Solution Options

### Option 1: Click the Auto-Generated Link (Easiest)
1. Copy the URL from the error message in your console
2. Paste it in your browser
3. Click "Create Index" in Firebase Console
4. Wait 2-5 minutes for the index to build

### Option 2: Manual Creation in Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `waterborne-detection`
3. Navigate to: Firestore Database → Indexes
4. Click "Create Index"
5. Configure:
   - Collection ID: `alerts`
   - Fields to index:
     - Field: `resolved` | Order: Ascending
     - Field: `triggered_at` | Order: Ascending
   - Query scope: Collection
6. Click "Create"

### Option 3: Deploy Using Firebase CLI
If you have Firebase CLI installed:

```bash
cd JalRakshak
firebase deploy --only firestore:indexes
```

This will deploy the index configuration from `firestore.indexes.json`.

## What Was Fixed

### 1. UI Overflow Issue
- Added `maxLines: 1` and `overflow: TextOverflow.ellipsis` to stat card texts
- Added `mainAxisSize: MainAxisSize.min` to prevent overflow
- This prevents the "RenderFlex overflowed by 15 pixels" error

### 2. Firestore Index Configuration
- Created `firestore.indexes.json` with the required composite index
- Index allows querying: `where('resolved', isEqualTo: true).where('triggered_at', isGreaterThanOrEqualTo: date)`

## Verification
After creating the index:
1. Restart your app
2. The "Resolved Today" count should load without errors
3. No more Firestore index errors in console

## Index Build Time
- Simple indexes: 1-2 minutes
- Complex indexes: 5-10 minutes
- Large collections: May take longer

Check index status in Firebase Console → Firestore → Indexes tab.
