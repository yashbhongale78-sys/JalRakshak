// lib/data/services/notification_service.dart
// Handles Firebase Cloud Messaging setup and local notifications.

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../core/constants/app_constants.dart';

/// Background message handler — must be top-level function.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages here
  print('Background FCM message: ${message.notification?.title}');
}

/// Service for Firebase Cloud Messaging and local push notifications.
class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize FCM and local notification channels.
  Future<void> initialize() async {
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request notification permissions (iOS + Android 13+)
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _setupLocalNotifications();
      await _setupFCMListeners();

      // Get and print FCM token for testing
      await getToken();
    }
  }

  /// Setup local notification channel for Android.
  Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(initSettings);

    // Create high-priority alert channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'outbreak_alerts',
      'Outbreak Alerts',
      description: 'Critical disease outbreak notifications',
      importance: Importance.max,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Listen for foreground FCM messages.
  Future<void> _setupFCMListeners() async {
    // Foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showLocalNotification(
          title: message.notification!.title ?? 'Health Alert',
          body: message.notification!.body ?? '',
          id: message.hashCode,
        );
      }
    });
  }

  /// Display a local notification.
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    required int id,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'outbreak_alerts',
      'Outbreak Alerts',
      channelDescription: 'Critical disease outbreak notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF1565C0),
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(id, title, body, details);
  }

  /// Subscribe to a FCM topic (e.g., outbreak alerts for villagers).
  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
  }

  /// Unsubscribe from a FCM topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
  }

  /// Get device FCM token (for targeted notifications).
  Future<String?> getToken() async {
    final token = await _fcm.getToken();
    // Print token for testing - remove in production
    print('FCM Token: $token');
    return token;
  }

  /// Subscribe user to role-appropriate topics.
  Future<void> subscribeByRole(String role) async {
    // All users get outbreak alerts
    await subscribeToTopic(AppConstants.fcmTopicAlerts);

    // Role-specific topics
    switch (role) {
      case AppConstants.roleVillager:
        await subscribeToTopic(AppConstants.fcmTopicVillagers);
        break;
      case AppConstants.roleHealthWorker:
        await subscribeToTopic(AppConstants.fcmTopicHealthWorkers);
        break;
    }
  }

  /// Send a local notification for a new alert
  Future<void> sendAlertNotification({
    required String disease,
    required String location,
    required int caseCount,
    required bool isCritical,
  }) async {
    final title = isCritical
        ? '🚨 CRITICAL: $disease Outbreak'
        : '⚠️ WARNING: $disease Alert';
    final body = '$caseCount cases reported in $location in the last 24 hours';

    await _showLocalNotification(
      title: title,
      body: body,
      id: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
