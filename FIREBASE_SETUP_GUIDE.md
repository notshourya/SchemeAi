# 🔥 Firebase Configuration Guide

## Files Created
I've created placeholder files for you to replace:

### Android
- **Location**: `android/app/google-services.json` ✅ CREATED
- **Status**: Placeholder - REPLACE WITH REAL FILE

### iOS  
- **Location**: `ios/Runner/GoogleService-Info.plist` ✅ CREATED
- **Status**: Placeholder - REPLACE WITH REAL FILE

## 📋 Step-by-Step Setup

### 1. Create Firebase Project
1. Go to https://console.firebase.google.com/
2. Click "Create a project" 
3. Project name: `scheme-ai` (or any name)
4. Enable Google Analytics: ✅ (recommended)
5. Click "Create project"

### 2. Add Android App
1. In Firebase Console → Click "Add app" → Android icon
2. **Android package name**: `com.shourya.scheme_a_i`
3. **App nickname**: "Scheme AI Android" 
4. **Debug signing certificate SHA-1**: Skip for now
5. Click "Register app"
6. **Download `google-services.json`**
7. **Replace** the placeholder file at `android/app/google-services.json`

### 3. Add iOS App  
1. Click "Add app" → iOS icon
2. **iOS bundle ID**: `com.shourya.scheme-a-i`
3. **App nickname**: "Scheme AI iOS"
4. Click "Register app" 
5. **Download `GoogleService-Info.plist`**
6. **Replace** the placeholder file at `ios/Runner/GoogleService-Info.plist`

### 4. Enable Firebase Services

#### Authentication
1. Go to **Authentication** → **Sign-in method**
2. Enable **Email/Password** ✅
3. Enable **Google Sign-In** ✅ (optional but recommended)

#### Firestore Database
1. Go to **Firestore Database** 
2. Click **"Create database"**
3. **Start in test mode** ✅
4. **Choose location**: Select closest to you
5. Click **"Done"**

### 5. Configure Firestore Security Rules
Go to **Firestore Database** → **Rules** and replace with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // User's search sessions
      match /search_sessions/{sessionId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
        
        // Recommendations within sessions
        match /recommendations/{recommendationId} {
          allow read, write: if request.auth != null && request.auth.uid == userId;
        }
      }
    }
  }
}
```

## ✅ After Adding Real Files

Once you've replaced both placeholder files with real ones:

1. **Clean and rebuild**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Test the app** - Firebase should initialize properly

3. **Enable authentication** - Login/Register should work

4. **Test AI features** - Form submission should save to Firestore

## 🚨 Important Notes

- **Package Name**: Must be exactly `com.shourya.scheme_a_i` for Android
- **Bundle ID**: Must be exactly `com.shourya.scheme-a-i` for iOS  
- **File Locations**: Must be exact - don't create subfolders
- **Test Mode**: Firestore rules allow all reads/writes for 30 days in test mode

## 🔧 Build Configuration Updated

I've already updated your Android build files to include Google Services plugin.

## 📱 What Will Work After Setup

- ✅ **Firebase Authentication** (Email/Password, Google Sign-In)
- ✅ **User Profile Storage** in Firestore
- ✅ **Search History** tracking
- ✅ **AI Recommendations** with Gemini API
- ✅ **Offline Support** for cached data

## 🆘 Troubleshooting

**Build Errors**: Run `flutter clean && flutter pub get`
**Firebase Errors**: Check file locations and package names
**API Errors**: Verify Firestore rules and authentication setup

Replace the placeholder files and your app will be fully functional! 🚀
