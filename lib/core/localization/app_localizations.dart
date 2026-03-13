// lib/core/localization/app_localizations.dart
// Simple localization system for multilingual support

import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('hi', ''), // Hindi
    Locale('mr', ''), // Marathi
    Locale('ta', ''), // Tamil
    Locale('te', ''), // Telugu
  ];

  // Translations map
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Common
      'app_name': 'JALARAKSHA',
      'welcome': 'Welcome',
      'submit': 'Submit',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'search': 'Search',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',

      // Auth
      'login': 'Login',
      'signup': 'Sign Up',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'name': 'Name',
      'phone': 'Phone Number',
      'forgot_password': 'Forgot Password?',

      // Dashboard
      'good_morning': 'Good Morning',
      'good_afternoon': 'Good Afternoon',
      'good_evening': 'Good Evening',
      'active_alerts': 'Active Alerts',
      'quick_report': 'Quick Report',
      'recent_reports': 'Recent Reports',
      'system_monitoring': 'System monitoring',
      'villages': 'villages',
      'todays_reports': "Today's Reports",
      'villages_safe': 'Villages Safe',
      'response_rate': 'Response Rate',
      'from_yesterday': 'from yesterday',
      'critical_count': 'critical',
      'coverage': 'coverage',
      'avg_hours': 'Avg 2.3 hrs',
      'error_loading': 'Error loading',

      // Reports
      'disease': 'Disease/Symptom',
      'location': 'Location',
      'description': 'Description',
      'caused_by': 'Caused By',
      'submit_report': 'Submit Report',
      'report_submitted': 'Report submitted successfully!',
      'is_required': 'is required',
      'please_specify_disease': 'Please specify the disease',

      // Diseases
      'fever': 'Fever',
      'diarrhea': 'Diarrhea',
      'vomiting': 'Vomiting',
      'skin_rash': 'Skin Rash',
      'cholera': 'Cholera',
      'typhoid': 'Typhoid',
      'jaundice': 'Jaundice',
      'other': 'Other',

      // Navigation
      'home': 'Home',
      'map': 'Map',
      'reports': 'Reports',
      'alerts': 'Alerts',
      'more': 'More',

      // Settings
      'settings': 'Settings',
      'language': 'Language',
      'select_language': 'Select Language',
      'english': 'English',
      'hindi': 'हिंदी',
      'marathi': 'मराठी',
      'tamil': 'தமிழ்',
      'telugu': 'తెలుగు',

      // Alerts
      'critical': 'CRITICAL',
      'warning': 'WARNING',
      'outbreak_alert': 'Outbreak Alert',
      'cases_reported': 'cases reported',
      'in_last_24_hours': 'in the last 24 hours',
      'no_active_alerts': 'No active alerts',
      'resolve': 'Resolve',
      'dispatch': 'Dispatch',
      'escalate': 'Escalate',
      'cases_in_24h': 'cases in 24h',
      'unknown_location': 'Unknown Location',

      // More Screen
      'officials_directory': 'Officials Directory',
      'contact_health_officials': 'Contact health officials',
      'supply_chain': 'Supply Chain',
      'medical_supplies_tracking': 'Medical supplies tracking',
      'analytics': 'Analytics',
      'health_data_insights': 'Health data insights',
      'app_preferences': 'App preferences & language',
      'help_support': 'Help & Support',
      'get_assistance': 'Get assistance',
      'sign_out_account': 'Sign out of your account',
      'coming_soon': 'Coming Soon',
      'feature_being_developed':
          'This feature is being developed and will be available in the next update.',
      'ok': 'OK',
      'are_you_sure_logout':
          'Are you sure you want to sign out of your account?',
    },
    'hi': {
      // Common
      'app_name': 'जलरक्षा',
      'welcome': 'स्वागत है',
      'submit': 'जमा करें',
      'cancel': 'रद्द करें',
      'save': 'सहेजें',
      'delete': 'हटाएं',
      'edit': 'संपादित करें',
      'search': 'खोजें',
      'loading': 'लोड हो रहा है...',
      'error': 'त्रुटि',
      'success': 'सफलता',

      // Auth
      'login': 'लॉगिन',
      'signup': 'साइन अप',
      'logout': 'लॉगआउट',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'name': 'नाम',
      'phone': 'फोन नंबर',
      'forgot_password': 'पासवर्ड भूल गए?',

      // Dashboard
      'good_morning': 'सुप्रभात',
      'good_afternoon': 'शुभ दोपहर',
      'good_evening': 'शुभ संध्या',
      'active_alerts': 'सक्रिय अलर्ट',
      'quick_report': 'त्वरित रिपोर्ट',
      'recent_reports': 'हाल की रिपोर्ट',
      'system_monitoring': 'सिस्टम निगरानी',
      'villages': 'गांव',
      'todays_reports': 'आज की रिपोर्ट',
      'villages_safe': 'सुरक्षित गांव',
      'response_rate': 'प्रतिक्रिया दर',
      'from_yesterday': 'कल से',
      'critical_count': 'गंभीर',
      'coverage': 'कवरेज',
      'avg_hours': 'औसत 2.3 घंटे',
      'error_loading': 'लोड करने में त्रुटि',

      // Reports
      'disease': 'रोग/लक्षण',
      'location': 'स्थान',
      'description': 'विवरण',
      'caused_by': 'कारण',
      'submit_report': 'रिपोर्ट जमा करें',
      'report_submitted': 'रिपोर्ट सफलतापूर्वक जमा की गई!',
      'is_required': 'आवश्यक है',
      'please_specify_disease': 'कृपया रोग निर्दिष्ट करें',

      // Diseases
      'fever': 'बुखार',
      'diarrhea': 'दस्त',
      'vomiting': 'उल्टी',
      'skin_rash': 'त्वचा पर चकत्ते',
      'cholera': 'हैजा',
      'typhoid': 'टाइफाइड',
      'jaundice': 'पीलिया',
      'other': 'अन्य',

      // Navigation
      'home': 'होम',
      'map': 'मानचित्र',
      'reports': 'रिपोर्ट',
      'alerts': 'अलर्ट',
      'more': 'अधिक',

      // Settings
      'settings': 'सेटिंग्स',
      'language': 'भाषा',
      'select_language': 'भाषा चुनें',
      'english': 'English',
      'hindi': 'हिंदी',
      'marathi': 'मराठी',
      'tamil': 'தமிழ்',
      'telugu': 'తెలుగు',

      // Alerts
      'critical': 'गंभीर',
      'warning': 'चेतावनी',
      'outbreak_alert': 'प्रकोप अलर्ट',
      'cases_reported': 'मामले दर्ज',
      'in_last_24_hours': 'पिछले 24 घंटों में',
      'no_active_alerts': 'कोई सक्रिय अलर्ट नहीं',
      'resolve': 'हल करें',
      'dispatch': 'भेजें',
      'escalate': 'बढ़ाएं',
      'cases_in_24h': '24 घंटे में मामले',
      'unknown_location': 'अज्ञात स्थान',

      // More Screen
      'officials_directory': 'अधिकारी निर्देशिका',
      'contact_health_officials': 'स्वास्थ्य अधिकारियों से संपर्क करें',
      'supply_chain': 'आपूर्ति श्रृंखला',
      'medical_supplies_tracking': 'चिकित्सा आपूर्ति ट्रैकिंग',
      'analytics': 'विश्लेषण',
      'health_data_insights': 'स्वास्थ्य डेटा अंतर्दृष्टि',
      'app_preferences': 'ऐप प्राथमिकताएं और भाषा',
      'help_support': 'सहायता और समर्थन',
      'get_assistance': 'सहायता प्राप्त करें',
      'sign_out_account': 'अपने खाते से साइन आउट करें',
      'coming_soon': 'जल्द आ रहा है',
      'feature_being_developed':
          'यह सुविधा विकसित की जा रही है और अगले अपडेट में उपलब्ध होगी।',
      'ok': 'ठीक है',
      'are_you_sure_logout':
          'क्या आप वाकई अपने खाते से साइन आउट करना चाहते हैं?',
    },
    'mr': {
      // Common
      'app_name': 'जलरक्षा',
      'welcome': 'स्वागत',
      'submit': 'सबमिट करा',
      'cancel': 'रद्द करा',
      'save': 'जतन करा',
      'delete': 'हटवा',
      'edit': 'संपादित करा',
      'search': 'शोधा',
      'loading': 'लोड होत आहे...',
      'error': 'त्रुटी',
      'success': 'यश',

      // Auth
      'login': 'लॉगिन',
      'signup': 'साइन अप',
      'logout': 'लॉगआउट',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'name': 'नाव',
      'phone': 'फोन नंबर',
      'forgot_password': 'पासवर्ड विसरलात?',

      // Dashboard
      'good_morning': 'शुभ सकाळ',
      'good_afternoon': 'शुभ दुपार',
      'good_evening': 'शुभ संध्याकाळ',
      'active_alerts': 'सक्रिय सूचना',
      'quick_report': 'द्रुत अहवाल',
      'recent_reports': 'अलीकडील अहवाल',
      'system_monitoring': 'प्रणाली निरीक्षण',
      'villages': 'गावे',
      'todays_reports': 'आजचे अहवाल',
      'villages_safe': 'सुरक्षित गावे',
      'response_rate': 'प्रतिसाद दर',
      'from_yesterday': 'कालपासून',
      'critical_count': 'गंभीर',
      'coverage': 'कव्हरेज',
      'avg_hours': 'सरासरी 2.3 तास',
      'error_loading': 'लोड करण्यात त्रुटी',

      // Reports
      'disease': 'रोग/लक्षण',
      'location': 'स्थान',
      'description': 'वर्णन',
      'caused_by': 'कारण',
      'submit_report': 'अहवाल सबमिट करा',
      'report_submitted': 'अहवाल यशस्वीरित्या सबमिट झाला!',
      'is_required': 'आवश्यक आहे',
      'please_specify_disease': 'कृपया रोग निर्दिष्ट करा',

      // Diseases
      'fever': 'ताप',
      'diarrhea': 'अतिसार',
      'vomiting': 'उलट्या',
      'skin_rash': 'त्वचेवर पुरळ',
      'cholera': 'कॉलरा',
      'typhoid': 'टायफॉइड',
      'jaundice': 'कावीळ',
      'other': 'इतर',

      // Navigation
      'home': 'होम',
      'map': 'नकाशा',
      'reports': 'अहवाल',
      'alerts': 'सूचना',
      'more': 'अधिक',

      // Settings
      'settings': 'सेटिंग्ज',
      'language': 'भाषा',
      'select_language': 'भाषा निवडा',
      'english': 'English',
      'hindi': 'हिंदी',
      'marathi': 'मराठी',
      'tamil': 'தமிழ்',
      'telugu': 'తెలుగు',

      // Alerts
      'critical': 'गंभीर',
      'warning': 'चेतावणी',
      'outbreak_alert': 'उद्रेक सूचना',
      'cases_reported': 'प्रकरणे नोंदवली',
      'in_last_24_hours': 'गेल्या 24 तासांत',
      'no_active_alerts': 'कोणतीही सक्रिय सूचना नाही',
      'resolve': 'निराकरण करा',
      'dispatch': 'पाठवा',
      'escalate': 'वाढवा',
      'cases_in_24h': '24 तासांत प्रकरणे',
      'unknown_location': 'अज्ञात स्थान',

      // More Screen
      'officials_directory': 'अधिकारी निर्देशिका',
      'contact_health_officials': 'आरोग्य अधिकाऱ्यांशी संपर्क साधा',
      'supply_chain': 'पुरवठा साखळी',
      'medical_supplies_tracking': 'वैद्यकीय पुरवठा ट्रॅकिंग',
      'analytics': 'विश्लेषण',
      'health_data_insights': 'आरोग्य डेटा अंतर्दृष्टी',
      'app_preferences': 'अॅप प्राधान्ये आणि भाषा',
      'help_support': 'मदत आणि समर्थन',
      'get_assistance': 'सहाय्य मिळवा',
      'sign_out_account': 'आपल्या खात्यातून साइन आउट करा',
      'coming_soon': 'लवकरच येत आहे',
      'feature_being_developed':
          'हे वैशिष्ट्य विकसित केले जात आहे आणि पुढील अपडेटमध्ये उपलब्ध होईल.',
      'ok': 'ठीक आहे',
      'are_you_sure_logout':
          'तुम्हाला खात्री आहे की तुम्ही तुमच्या खात्यातून साइन आउट करू इच्छिता?',
    },
    'ta': {
      // Common
      'app_name': 'ஜலரக்ஷா',
      'welcome': 'வரவேற்கிறோம்',
      'submit': 'சமர்ப்பிக்கவும்',
      'cancel': 'ரத்து செய்',
      'save': 'சேமி',
      'delete': 'நீக்கு',
      'edit': 'திருத்து',
      'search': 'தேடு',
      'loading': 'ஏற்றுகிறது...',
      'error': 'பிழை',
      'success': 'வெற்றி',

      // Auth
      'login': 'உள்நுழைய',
      'signup': 'பதிவு செய்ய',
      'logout': 'வெளியேறு',
      'email': 'மின்னஞ்சல்',
      'password': 'கடவுச்சொல்',
      'name': 'பெயர்',
      'phone': 'தொலைபேசி எண்',
      'forgot_password': 'கடவுச்சொல் மறந்துவிட்டதா?',

      // Dashboard
      'good_morning': 'காலை வணக்கம்',
      'good_afternoon': 'மதிய வணக்கம்',
      'good_evening': 'மாலை வணக்கம்',
      'active_alerts': 'செயலில் உள்ள எச்சரிக்கைகள்',
      'quick_report': 'விரைவு அறிக்கை',
      'recent_reports': 'சமீபத்திய அறிக்கைகள்',
      'system_monitoring': 'அமைப்பு கண்காணிப்பு',
      'villages': 'கிராமங்கள்',
      'todays_reports': 'இன்றைய அறிக்கைகள்',
      'villages_safe': 'பாதுகாப்பான கிராமங்கள்',
      'response_rate': 'பதில் விகிதம்',
      'from_yesterday': 'நேற்றிலிருந்து',
      'critical_count': 'முக்கியமான',
      'coverage': 'கவரேஜ்',
      'avg_hours': 'சராசரி 2.3 மணி',
      'error_loading': 'ஏற்றுவதில் பிழை',

      // Reports
      'disease': 'நோய்/அறிகுறி',
      'location': 'இடம்',
      'description': 'விளக்கம்',
      'caused_by': 'காரணம்',
      'submit_report': 'அறிக்கை சமர்ப்பிக்கவும்',
      'report_submitted': 'அறிக்கை வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது!',
      'is_required': 'தேவை',
      'please_specify_disease': 'தயவுசெய்து நோயைக் குறிப்பிடவும்',

      // Diseases
      'fever': 'காய்ச்சல்',
      'diarrhea': 'வயிற்றுப்போக்கு',
      'vomiting': 'வாந்தி',
      'skin_rash': 'தோல் வெடிப்பு',
      'cholera': 'காலரா',
      'typhoid': 'டைபாய்டு',
      'jaundice': 'மஞ்சள் காமாலை',
      'other': 'மற்றவை',

      // Navigation
      'home': 'முகப்பு',
      'map': 'வரைபடம்',
      'reports': 'அறிக்கைகள்',
      'alerts': 'எச்சரிக்கைகள்',
      'more': 'மேலும்',

      // Settings
      'settings': 'அமைப்புகள்',
      'language': 'மொழி',
      'select_language': 'மொழியைத் தேர்ந்தெடுக்கவும்',
      'english': 'English',
      'hindi': 'हिंदी',
      'marathi': 'मराठी',
      'tamil': 'தமிழ்',
      'telugu': 'తెలుగు',

      // Alerts
      'critical': 'முக்கியமான',
      'warning': 'எச்சரிக்கை',
      'outbreak_alert': 'வெடிப்பு எச்சரிக்கை',
      'cases_reported': 'வழக்குகள் பதிவு',
      'in_last_24_hours': 'கடந்த 24 மணி நேரத்தில்',
      'no_active_alerts': 'செயலில் உள்ள எச்சரிக்கைகள் இல்லை',
      'resolve': 'தீர்க்கவும்',
      'dispatch': 'அனுப்பவும்',
      'escalate': 'அதிகரிக்கவும்',
      'cases_in_24h': '24 மணி நேரத்தில் வழக்குகள்',
      'unknown_location': 'தெரியாத இடம்',

      // More Screen
      'officials_directory': 'அதிகாரிகள் அடைவு',
      'contact_health_officials': 'சுகாதார அதிகாரிகளை தொடர்பு கொள்ளுங்கள்',
      'supply_chain': 'விநியோக சங்கிலி',
      'medical_supplies_tracking': 'மருத்துவ பொருட்கள் கண்காணிப்பு',
      'analytics': 'பகுப்பாய்வு',
      'health_data_insights': 'சுகாதார தரவு நுண்ணறிவு',
      'app_preferences': 'பயன்பாட்டு விருப்பத்தேர்வுகள் மற்றும் மொழி',
      'help_support': 'உதவி மற்றும் ஆதரவு',
      'get_assistance': 'உதவி பெறுங்கள்',
      'sign_out_account': 'உங்கள் கணக்கிலிருந்து வெளியேறவும்',
      'coming_soon': 'விரைவில் வருகிறது',
      'feature_being_developed':
          'இந்த அம்சம் உருவாக்கப்பட்டு வருகிறது மற்றும் அடுத்த புதுப்பிப்பில் கிடைக்கும்.',
      'ok': 'சரி',
      'are_you_sure_logout':
          'நீங்கள் உங்கள் கணக்கிலிருந்து வெளியேற விரும்புகிறீர்களா?',
    },
    'te': {
      // Common
      'app_name': 'జలరక్ష',
      'welcome': 'స్వాగతం',
      'submit': 'సమర్పించండి',
      'cancel': 'రద్దు చేయండి',
      'save': 'సేవ్ చేయండి',
      'delete': 'తొలగించండి',
      'edit': 'సవరించండి',
      'search': 'వెతకండి',
      'loading': 'లోడ్ అవుతోంది...',
      'error': 'లోపం',
      'success': 'విజయం',

      // Auth
      'login': 'లాగిన్',
      'signup': 'సైన్ అప్',
      'logout': 'లాగ్అవుట్',
      'email': 'ఇమెయిల్',
      'password': 'పాస్‌వర్డ్',
      'name': 'పేరు',
      'phone': 'ఫోన్ నంబర్',
      'forgot_password': 'పాస్‌వర్డ్ మర్చిపోయారా?',

      // Dashboard
      'good_morning': 'శుభోదయం',
      'good_afternoon': 'శుభ మధ్యాహ్నం',
      'good_evening': 'శుభ సాయంత్రం',
      'active_alerts': 'క్రియాశీల హెచ్చరికలు',
      'quick_report': 'త్వరిత నివేదిక',
      'recent_reports': 'ఇటీవలి నివేదికలు',
      'system_monitoring': 'వ్యవస్థ పర్యవేక్షణ',
      'villages': 'గ్రామాలు',
      'todays_reports': 'నేటి నివేదికలు',
      'villages_safe': 'సురక్షిత గ్రామాలు',
      'response_rate': 'ప్రతిస్పందన రేటు',
      'from_yesterday': 'నిన్న నుండి',
      'critical_count': 'క్లిష్టమైన',
      'coverage': 'కవరేజ్',
      'avg_hours': 'సగటు 2.3 గంటలు',
      'error_loading': 'లోడ్ చేయడంలో లోపం',

      // Reports
      'disease': 'వ్యాధి/లక్షణం',
      'location': 'స్థానం',
      'description': 'వివరణ',
      'caused_by': 'కారణం',
      'submit_report': 'నివేదిక సమర్పించండి',
      'report_submitted': 'నివేదిక విజయవంతంగా సమర్పించబడింది!',
      'is_required': 'అవసరం',
      'please_specify_disease': 'దయచేసి వ్యాధిని పేర్కొనండి',

      // Diseases
      'fever': 'జ్వరం',
      'diarrhea': 'విరేచనాలు',
      'vomiting': 'వాంతులు',
      'skin_rash': 'చర్మ దద్దుర్లు',
      'cholera': 'కలరా',
      'typhoid': 'టైఫాయిడ్',
      'jaundice': 'కామెర్లు',
      'other': 'ఇతరములు',

      // Navigation
      'home': 'హోమ్',
      'map': 'మ్యాప్',
      'reports': 'నివేదికలు',
      'alerts': 'హెచ్చరికలు',
      'more': 'మరిన్ని',

      // Settings
      'settings': 'సెట్టింగ్‌లు',
      'language': 'భాష',
      'select_language': 'భాషను ఎంచుకోండి',
      'english': 'English',
      'hindi': 'हिंदी',
      'marathi': 'मराठी',
      'tamil': 'தமிழ்',
      'telugu': 'తెలుగు',

      // Alerts
      'critical': 'క్లిష్టమైన',
      'warning': 'హెచ్చరిక',
      'outbreak_alert': 'వ్యాప్తి హెచ్చరిక',
      'cases_reported': 'కేసులు నివేదించబడ్డాయి',
      'in_last_24_hours': 'గత 24 గంటల్లో',
      'no_active_alerts': 'క్రియాశీల హెచ్చరికలు లేవు',
      'resolve': 'పరిష్కరించండి',
      'dispatch': 'పంపండి',
      'escalate': 'పెంచండి',
      'cases_in_24h': '24 గంటల్లో కేసులు',
      'unknown_location': 'తెలియని స్థానం',

      // More Screen
      'officials_directory': 'అధికారుల డైరెక్టరీ',
      'contact_health_officials': 'ఆరోగ్య అధికారులను సంప్రదించండి',
      'supply_chain': 'సరఫరా గొలుసు',
      'medical_supplies_tracking': 'వైద్య సామాగ్రి ట్రాకింగ్',
      'analytics': 'విశ్లేషణలు',
      'health_data_insights': 'ఆరోగ్య డేటా అంతర్దృష్టులు',
      'app_preferences': 'యాప్ ప్రాధాన్యతలు మరియు భాష',
      'help_support': 'సహాయం మరియు మద్దతు',
      'get_assistance': 'సహాయం పొందండి',
      'sign_out_account': 'మీ ఖాతా నుండి సైన్ అవుట్ చేయండి',
      'coming_soon': 'త్వరలో వస్తోంది',
      'feature_being_developed':
          'ఈ ఫీచర్ అభివృద్ధి చేయబడుతోంది మరియు తదుపరి నవీకరణలో అందుబాటులో ఉంటుంది.',
      'ok': 'సరే',
      'are_you_sure_logout':
          'మీరు మీ ఖాతా నుండి సైన్ అవుట్ చేయాలనుకుంటున్నారా?',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Helper method for easy access
  String t(String key) => translate(key);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'mr', 'ta', 'te'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
