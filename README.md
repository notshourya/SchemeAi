# 🇮🇳 SchemeAI - AI-Powered Government Scheme Recommendation App

<div align="center">

![SchemeAI Logo](https://img.shields.io/badge/SchemeAI-Government%20Schemes-blue?style=for-the-badge)

**Discover Government Schemes Tailored for You with AI**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Authentication-orange.svg)](https://firebase.google.com/)
[![Gemini AI](https://img.shields.io/badge/Gemini-AI%20Powered-green.svg)](https://ai.google.dev/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

</div>

## 📱 About SchemeAI

SchemeAI is an intelligent Flutter application that leverages Google's Gemini AI to provide personalized government scheme recommendations to Indian citizens. By analyzing user profiles and preferences, the app matches users with relevant government benefits, subsidies, and programs they're eligible for.

### 🎯 Key Features

- **🤖 AI-Powered Recommendations**: Uses Google Gemini AI for intelligent scheme matching
- **👤 Personalized Profiles**: Detailed user profiling for accurate recommendations  
- **🏛️ Comprehensive Database**: Covers schemes from various government ministries
- **📊 Relevance Scoring**: Shows percentage match for each recommended scheme
- **🔍 Smart Filtering**: Filter schemes by category, ministry, and relevance
- **📱 Modern UI**: Clean, intuitive interface following Material Design
- **🔐 Secure Authentication**: Firebase-powered user authentication
- **📝 Application Tracking**: Save and track your scheme applications

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter](https://flutter.dev/docs/get-started/install) (3.0 or later)
- [Dart](https://dart.dev/get-dart) (3.0 or later)  
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/)

### 📦 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/SchemeAI.git
   cd SchemeAI
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` file and add your API keys:
   ```env
   GEMINI_API_KEY=your_gemini_api_key_here
   FIREBASE_WEB_API_KEY=your_firebase_web_api_key_here
   ```

4. **Configure Firebase**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add your Android/iOS app to the project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the respective directories:
     - `android/app/google-services.json`
     - `ios/Runner/GoogleService-Info.plist`

5. **Set up Gemini AI**
   - Get your API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Add it to your `.env` file

6. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Architecture

Built using **GetX Architecture** with:
- **State Management**: GetX Controllers for reactive state management
- **Routing**: GetX navigation with named routes
- **Dependency Injection**: GetX service locator pattern
- **Data Layer**: Repository pattern with Firebase services
- **UI Components**: Reusable custom widgets with consistent theming

## 🔧 Configuration

### Firebase Setup

1. **Authentication**: Enable Email/Password authentication in Firebase Console
2. **Firestore**: Create a Firestore database with the following collections:
   - `users` - User profile data
   - `schemes` - Government scheme information  
   - `applications` - User application history

### Environment Variables

Create a `.env` file in the root directory:

```env
# Gemini AI Configuration
GEMINI_API_KEY=your_gemini_api_key_here

# Firebase Configuration  
FIREBASE_WEB_API_KEY=your_firebase_web_api_key_here
```

## 🤖 AI Integration

SchemeAI uses **Google Gemini AI** for intelligent scheme recommendations:

- **Profile Analysis**: AI analyzes user demographics, income, location, and preferences
- **Scheme Matching**: Compares user profile against comprehensive scheme database
- **Relevance Scoring**: Provides percentage match scores for each recommendation
- **Natural Language Processing**: Understands complex eligibility criteria

## 📱 Features Overview

### 🔐 Authentication
- **Sign Up/Sign In**: Secure email-based authentication
- **Profile Management**: Complete user profile setup
- **Data Security**: All personal data encrypted and secure

### 🏠 Dashboard  
- **Quick Actions**: Fast access to key features
- **Recent Activity**: View your recent scheme interactions
- **Statistics**: Personal recommendations overview

### 📋 Profile Form
- **Comprehensive Details**: Personal, professional, and location information
- **Smart Validation**: Real-time form validation
- **Category Selection**: Choose areas of interest

### 🎯 AI Recommendations
- **Intelligent Matching**: AI analyzes your profile against 500+ schemes
- **Relevance Scoring**: Percentage match for each recommendation
- **Category Filtering**: Filter by scheme categories
- **Detailed Information**: Complete scheme details with application process

### 📊 Scheme Details
- **Comprehensive Information**: Eligibility, benefits, documents required
- **Application Process**: Step-by-step application guidance
- **Official Links**: Direct links to government portals
- **Save Feature**: Bookmark schemes for later

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── app/
│   ├── data/
│   │   ├── models/             # Data models
│   │   └── services/           # Firebase & API services
│   ├── modules/                # Feature modules
│   └── routes/                 # App routing configuration
├── features/                   # Feature screens
│   ├── splash/                 # Splash screen
│   ├── auth/                   # Login & Register
│   ├── home/                   # Home dashboard
│   ├── form/                   # Multi-step form
│   ├── results/                # Scheme recommendations
│   ├── profile/                # User profile
│   ├── scheme_detail/          # Scheme details
│   └── history/                # Search history
├── shared/
│   ├── theme/                  # App theming
│   ├── widgets/                # Reusable UI components
│   ├── utils/                  # Utilities and validators
│   └── constants/              # App constants
```

## Setup Instructions

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- Android Studio / VS Code
- Google Gemini AI API Key
- Firebase project

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd scheme_a_i
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables**
   ```bash
   cp .env.template .env
   ```
   Edit `.env` file and add your API keys:
   ```
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

4. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password and Google Sign-In)
   - Enable Firestore Database
   - Download configuration files:
     - `google-services.json` for Android → `android/app/`
     - `GoogleService-Info.plist` for iOS → `ios/Runner/`
     - Firebase config for Web → add to `web/index.html`

5. **Get Gemini AI API Key**
   - Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Create an API key
   - Add it to your `.env` file

6. **Run the app**
   ```bash
   flutter run
   ```

## Key Dependencies

- **GetX**: State management, routing, and dependency injection
- **Firebase**: Authentication and data storage
- **flutter_dotenv**: Environment variable management
- **http**: API communication with Gemini AI
- **google_fonts**: Custom typography
- **flutter_secure_storage**: Secure local storage

## API Integration

### Gemini AI Integration
The app uses Google's Gemini AI to analyze user profiles and recommend schemes:

```dart
// Example API call structure
final response = await geminiService.getSchemeRecommendations(userFormData);
```

### Firebase Services
- **Authentication**: Email/password and Google Sign-In
- **Firestore**: User profiles, search history, and recommendations
- **Security**: Rule-based access control

## UI/UX Features

- **Material Design 3**: Modern, accessible design system
- **Dark/Light Theme**: Automatic theme switching
- **Responsive Design**: Adapts to different screen sizes
- **Loading States**: Smooth loading animations
- **Error Handling**: User-friendly error messages
- **Form Validation**: Real-time input validation

## Data Models

### UserFormData
Comprehensive user profile including:
- Personal information (name, age, gender, etc.)
- Educational background
- Employment status and income
- Family details
- Location information
- Special categories and preferences

### SchemeRecommendation
AI-generated scheme recommendations with:
- Scheme name and description
- Eligibility criteria
- Required documents
- Application process
- Benefits and coverage
- Confidence score

## Security Features

- **Environment Variables**: Secure API key management
- **Firebase Security Rules**: Server-side data protection
- **Input Validation**: Client-side and server-side validation
- **Secure Storage**: Encrypted local storage for sensitive data

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-feature`
3. Commit changes: `git commit -am 'Add new feature'`
4. Push to branch: `git push origin feature/new-feature`
5. Submit a pull request

## Testing

```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test.dart

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## Build and Deployment

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Troubleshooting

### Common Issues

1. **API Key Issues**
   - Ensure `.env` file is in the root directory
   - Verify API key is valid and has proper permissions
   - Check if flutter_dotenv is properly configured

2. **Firebase Configuration**
   - Verify configuration files are in correct directories
   - Ensure Firebase services are enabled in console
   - Check Firestore security rules

3. **Build Issues**
   - Run `flutter clean && flutter pub get`
   - Update Flutter SDK: `flutter upgrade`
   - Clear build cache

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Check the documentation
- Review the troubleshooting section

## Acknowledgments

- Google Gemini AI for intelligent recommendations
- Firebase for backend services
- Flutter team for the amazing framework
- GetX community for state management solutions

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
