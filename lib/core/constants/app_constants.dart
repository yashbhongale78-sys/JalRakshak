// lib/core/constants/app_constants.dart
// Central repository for all app-wide constant values

/// Application-wide constants used throughout the Water-Borne Detection app.
class AppConstants {
  AppConstants._(); // prevent instantiation

  // ─── App Info ───────────────────────────────────────────────
  static const String appName = 'JalSuraksha'; // "Water Protection" in Hindi
  static const String appTagline = 'Protecting Rural Communities';
  static const String appVersion = '1.0.0';

  // ─── Firestore Collection Names ─────────────────────────────
  static const String usersCollection = 'users';
  static const String symptomReportsCollection = 'symptom_reports';
  static const String waterReportsCollection = 'water_reports';
  static const String alertsCollection = 'alerts';
  static const String clinicsCollection = 'clinics';

  // ─── Hive Box Names (Offline Storage) ───────────────────────
  static const String hiveBoxSymptomReports = 'offline_symptom_reports';
  static const String hiveBoxWaterReports = 'offline_water_reports';
  static const String hiveBoxSettings = 'app_settings';

  // ─── Hive Type IDs ───────────────────────────────────────────
  static const int hiveSymptomReportTypeId = 0;
  static const int hiveWaterReportTypeId = 1;

  // ─── User Roles ──────────────────────────────────────────────
  static const String roleVillager = 'villager';
  static const String roleHealthWorker = 'health_worker';
  static const String roleGovernment = 'government';

  // ─── Alert Severity Levels ───────────────────────────────────
  static const String severityLow = 'low';
  static const String severityMedium = 'medium';
  static const String severityHigh = 'high';
  static const String severityCritical = 'critical';

  // ─── Symptom Types ───────────────────────────────────────────
  static const List<String> symptomTypes = [
    'Diarrhea',
    'Vomiting',
    'Fever',
    'Stomach Pain',
    'Weakness / Fatigue',
    'Nausea',
    'Dehydration',
    'Skin Rash',
    'Jaundice',
    'Other',
  ];

  // ─── Water Contamination Types ───────────────────────────────
  static const List<String> waterIssueTypes = [
    'Dirty / Muddy Water',
    'Bad Smell from Water',
    'Dead Animals Near Water Source',
    'Broken Water Pipe',
    'Oil / Chemical Spill',
    'Flooding Near Source',
    'Unusual Color',
    'Other',
  ];

  // ─── Northeast India States ──────────────────────────────────
  static const List<String> northeastStates = [
    'Assam',
    'Meghalaya',
    'Manipur',
    'Nagaland',
    'Mizoram',
    'Tripura',
    'Arunachal Pradesh',
    'Sikkim',
  ];

  // ─── All Indian States ──────────────────────────────────────
  static const List<String> indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    // Union Territories
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Jammu and Kashmir',
    'Ladakh',
    'Lakshadweep',
    'Puducherry',
  ];

  // ─── Prevention Tips ────────────────────────────────────────
  static const List<Map<String, String>> preventionTips = [
    {
      'title': 'Boil Drinking Water',
      'description': 'Always boil water for at least 1 minute before drinking. '
          'Let it cool in a clean, covered container.',
      'icon': '🔥',
    },
    {
      'title': 'Wash Hands Regularly',
      'description': 'Wash hands with soap and clean water before eating, '
          'after using toilet, and after handling animals.',
      'icon': '🤲',
    },
    {
      'title': 'Store Water Safely',
      'description': 'Store drinking water in clean, covered containers. '
          'Never use same vessel for fetching and storing.',
      'icon': '🪣',
    },
    {
      'title': 'Use Toilet / Latrine',
      'description': 'Always use a toilet or latrine. '
          'Open defecation near water sources spreads disease.',
      'icon': '🚽',
    },
    {
      'title': 'Keep Surroundings Clean',
      'description': 'Remove garbage and stagnant water near your home '
          'to prevent mosquito and fly breeding.',
      'icon': '🧹',
    },
    {
      'title': 'Cook Food Properly',
      'description': 'Cook food thoroughly and eat fresh meals. '
          'Avoid raw or undercooked food, especially fish.',
      'icon': '🍳',
    },
    {
      'title': 'Use ORS for Diarrhea',
      'description':
          'If someone has diarrhea, give Oral Rehydration Solution (ORS). '
              'Mix 1 packet in 1 liter of boiled water.',
      'icon': '💊',
    },
    {
      'title': 'Report Illness Early',
      'description':
          'Report any illness in your village immediately using this app. '
              'Early detection saves lives.',
      'icon': '📱',
    },
  ];

  // ─── Dummy Clinic Data (Northeast India) ─────────────────────
  static const List<Map<String, dynamic>> dummyClinics = [
    {
      'name': 'Gauhati Medical College',
      'address': 'Bhangagarh, Guwahati, Assam',
      'phone': '0361-2529457',
      'lat': 26.1897,
      'lng': 91.7462,
      'type': 'Government Hospital',
    },
    {
      'name': 'NEIGRIHMS',
      'address': 'Mawdiangdiang, Shillong, Meghalaya',
      'phone': '0364-2538011',
      'lat': 25.5760,
      'lng': 91.8933,
      'type': 'Government Hospital',
    },
    {
      'name': 'RIMS Imphal',
      'address': 'Lamphelpat, Imphal, Manipur',
      'phone': '0385-2416700',
      'lat': 24.8170,
      'lng': 93.9368,
      'type': 'Government Hospital',
    },
    {
      'name': 'Dimapur District Hospital',
      'address': 'Dimapur, Nagaland',
      'phone': '03862-226625',
      'lat': 25.9047,
      'lng': 93.7264,
      'type': 'District Hospital',
    },
    {
      'name': 'Agartala Government Medical College',
      'address': 'Kunjaban, Agartala, Tripura',
      'phone': '0381-2324873',
      'lat': 23.8315,
      'lng': 91.2868,
      'type': 'Government Hospital',
    },
  ];

  // ─── FCM Topic Names ─────────────────────────────────────────
  static const String fcmTopicAlerts = 'outbreak_alerts';
  static const String fcmTopicVillagers = 'villagers';
  static const String fcmTopicHealthWorkers = 'health_workers';

  // ─── Shared Pref Keys ────────────────────────────────────────
  static const String prefOnboardingDone = 'onboarding_complete';
  static const String prefUserRole = 'user_role';
}
