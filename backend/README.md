# JALARAKSHA WhatsApp Chatbot Backend

## Overview
This is the backend service for the JALARAKSHA WhatsApp chatbot that allows villagers to report waterborne diseases and health issues via WhatsApp messages. The chatbot integrates with the main JALARAKSHA Flutter app and Firebase database.

## Features

### 🤖 AI-Powered Health Assistant
- **Gemini AI Integration**: Uses Google's Gemini AI for intelligent symptom detection
- **Multi-language Support**: Supports Marathi, Hindi, and English
- **Intent Recognition**: Automatically detects health symptoms from natural language

### 📱 WhatsApp Integration
- **Message Processing**: Handles text and voice messages
- **Voice Transcription**: Converts voice messages to text for processing
- **Interactive Menus**: Location selection and language preferences
- **Session Management**: Maintains user context across conversations

### 🏥 Health Reporting System
- **Symptom Detection**: Recognizes fever, diarrhea, vomiting, stomach pain, etc.
- **Location Tracking**: District and village selection for Maharashtra
- **Firebase Integration**: Saves reports to the same database as the mobile app
- **Alert System**: Triggers alerts when disease thresholds are reached

### 🌍 Location Support
- **Maharashtra Districts**: Complete coverage of all districts
- **Village Selection**: Detailed village mapping
- **Division-wise Organization**: Konkan, Pune, Nashik, Aurangabad, Amravati, Nagpur

## Tech Stack

- **Framework**: FastAPI (Python)
- **AI**: Google Gemini AI
- **Database**: Firebase Firestore
- **Messaging**: WhatsApp Business API
- **Voice**: Speech-to-text transcription
- **Deployment**: Railway/Heroku compatible

## File Structure

```
backend/
├── main.py              # FastAPI application entry point
├── ai.py                # Gemini AI integration
├── whatsapp.py          # WhatsApp API integration
├── intent.py            # Intent detection logic
├── reply.py             # Response generation
├── voice.py             # Voice message processing
├── sessions.py          # User session management
├── menu.py              # Interactive menu systems
├── firebase_db.py       # Firebase database operations
├── alerts.py            # Health alert system
├── language.py          # Multi-language support
├── database.py          # Database utilities
├── requirements.txt     # Python dependencies
├── Procfile            # Deployment configuration
├── runtime.txt         # Python version
└── .env.example        # Environment variables template
```

## Setup Instructions

### 1. Environment Variables
Create a `.env` file with:

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

### 2. Firebase Setup
- Place your `firebase_key.json` service account file in the backend folder
- Ensure Firestore database is configured with proper collections

### 3. Install Dependencies
```bash
cd backend
pip install -r requirements.txt
```

### 4. Run Development Server
```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

## API Endpoints

### WhatsApp Webhook
- **POST** `/webhook` - Receives WhatsApp messages
- **GET** `/webhook` - Webhook verification

### Health Check
- **GET** `/` - Service status
- **GET** `/health` - Health check endpoint

## Integration with Flutter App

The chatbot integrates seamlessly with the JALARAKSHA Flutter app:

1. **Shared Database**: Both use the same Firebase Firestore collections
2. **Report Format**: Chatbot reports match the mobile app structure
3. **Alert System**: Triggers same alert thresholds as mobile app
4. **User Data**: Can access user profiles and location data

## Supported Languages

### Marathi (मराठी)
- ताप, जुलाब, उलटी, पोटदुखी, अंग दुखणे
- जिल्हा आणि गाव निवड
- मराठी भाषेत प्रतिसाद

### Hindi (हिंदी)
- बुखार, दस्त, उल्टी, पेट दर्द, कमजोरी
- जिला और गांव चयन
- हिंदी में जवाब

### English
- Fever, diarrhea, vomiting, stomach pain, weakness
- District and village selection
- English responses

## Deployment

### Railway Deployment
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login and deploy
railway login
railway init
railway up
```

### Heroku Deployment
```bash
# Install Heroku CLI
heroku create jalaraksha-chatbot
git push heroku main
```

## Usage Flow

1. **User sends WhatsApp message** → "मला ताप आहे" (I have fever)
2. **AI processes message** → Detects symptom intent
3. **Location collection** → Asks for district/village if new user
4. **Report generation** → Creates structured health report
5. **Database storage** → Saves to Firebase Firestore
6. **Alert checking** → Triggers alerts if thresholds met
7. **Response sent** → Confirmation message to user

## Monitoring & Logs

- **FastAPI logs**: Application-level logging
- **Firebase logs**: Database operation logs
- **WhatsApp logs**: Message delivery status
- **AI logs**: Gemini API usage and responses

## Security Features

- **Environment variables**: Sensitive data in .env
- **Firebase security**: Service account authentication
- **Webhook verification**: WhatsApp token validation
- **Input sanitization**: Message content filtering

## Contributing

1. Fork the repository
2. Create feature branch
3. Add tests for new functionality
4. Submit pull request

## License

This project is part of the JALARAKSHA health monitoring system.