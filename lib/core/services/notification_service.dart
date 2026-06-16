import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
}

class NotificationService {
  static FirebaseMessaging? _messaging;
  static final Logger _logger = Logger();

  static FirebaseMessaging _getInstance() {
    if (kIsWeb) {
      throw UnsupportedError('Firebase Messaging is not supported on web');
    }
    return _messaging ??= FirebaseMessaging.instance;
  }

  static Future<void> initialize() async {
    if (kIsWeb) {
      _logger.w('Firebase Messaging not available on web');
      return;
    }

    try {
      final messaging = _getInstance();

      // Request permission
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _logger.i('Notification permission granted');
      }

      // Set up background handler
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _logger.i('Foreground message: ${message.notification?.title}');
        // Show local notification here
      });

      // Handle notification tap when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _logger.i('Message opened app: ${message.data}');
        // Navigate based on message.data
      });

      // Get token
      final token = await messaging.getToken();
      _logger.i('FCM Token: $token');
    } catch (e, st) {
      _logger.e(
        'Failed to initialize notifications: $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  static Future<String?> getToken() async {
    if (kIsWeb) return null;
    try {
      return await _getInstance().getToken();
    } catch (e) {
      _logger.e('Failed to get FCM token: $e');
      return null;
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    if (kIsWeb) return;
    try {
      await _getInstance().subscribeToTopic(topic);
    } catch (e) {
      _logger.e('Failed to subscribe to topic: $e');
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    if (kIsWeb) return;
    try {
      await _getInstance().unsubscribeFromTopic(topic);
    } catch (e) {
      _logger.e('Failed to unsubscribe from topic: $e');
    }
  }
}
