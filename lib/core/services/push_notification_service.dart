import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationPayload {
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final DateTime receivedAt;
  final String source;

  NotificationPayload({
    required this.title,
    required this.body,
    required this.data,
    required this.receivedAt,
    required this.source,
  });
}

class PushNotificationService {
  static const String _baseUrl = 'https://localhost:63681';
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final ValueNotifier<List<NotificationPayload>> notifications =
      ValueNotifier<List<NotificationPayload>>([]);

  String? fcmToken;
  String? _lastRegisteredToken;

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  String get _deviceType => kIsWeb ? 'Web' : 'Android';

  Future<void> init() async {
    if (kIsWeb) {
      await _initializeWebMessaging();
    } else {
      await _initializeMobileMessaging();
    }
  }

  Future<void> _initializeMobileMessaging() async {
    await _initializeLocalNotifications();
    await _requestPermission();

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _initializeMessagingListeners(showLocalNotification: true);
  }

  Future<void> _initializeWebMessaging() async {
    await _requestPermission();

    await _initializeMessagingListeners(showLocalNotification: false);
  }

  Future<void> _initializeMessagingListeners({required bool showLocalNotification}) async {
    fcmToken = await _messaging.getToken();
    if (fcmToken != null) {
      await _registerCurrentToken();
    }

    _messaging.onTokenRefresh.listen((newToken) async {
      final oldToken = _lastRegisteredToken ?? fcmToken;
      if (oldToken != null && oldToken != newToken) {
        await _unregisterToken(oldToken);
      }

      fcmToken = newToken;
      await _registerCurrentToken();
    });

    FirebaseMessaging.onMessage.listen((message) async {
      _addNotification(message, source: 'foreground');
      if (showLocalNotification) {
        await _showLocalNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _addNotification(message, source: 'opened_app');
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _addNotification(initialMessage, source: 'initial_message');
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      throw Exception('FCM permission denied');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    final androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosSettings = DarwinInitializationSettings();
    final initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        // No-op; notification taps are handled by FirebaseMessaging.onMessageOpenedApp.
      },
    );

    final channel = AndroidNotificationChannel(
      'payment_updates',
      'Payment Updates',
      description: 'Payment notification channel',
      importance: Importance.high,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) {
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      'payment_updates',
      'Payment Updates',
      channelDescription: 'Payment notification channel',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    final iosDetails = DarwinNotificationDetails();
    final platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotificationsPlugin.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: platformDetails,
      payload: jsonEncode(message.data),
    );
  }

  void _addNotification(RemoteMessage message, {required String source}) {
    notifications.value = [
      ...notifications.value,
      NotificationPayload(
        title: message.notification?.title ?? 'No title',
        body: message.notification?.body ?? 'No body',
        data: message.data,
        receivedAt: DateTime.now(),
        source: source,
      ),
    ];
  }

  Future<void> _registerCurrentToken() async {
    if (fcmToken == null) {
      return;
    }

    final customerId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    await registerDevice(
      customerId: customerId,
      deviceType: _deviceType,
    );

    _lastRegisteredToken = fcmToken;
  }

  Future<void> _unregisterToken(String tokenToRemove) async {
    final uri = Uri.parse('$_baseUrl/api/v1.0/AIScore/unregister');
    final response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fcmToken': tokenToRemove}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Device unregister failed: ${response.statusCode} ${response.body}');
    }

    if (_lastRegisteredToken == tokenToRemove) {
      _lastRegisteredToken = null;
    }
  }

  Future<void> registerDevice({
    required String customerId,
    String deviceType = 'Web',
  }) async {
    if (fcmToken == null) {
      throw Exception('FCM token not available yet.');
    }

    final uri = Uri.parse('$_baseUrl/api/v1.0/AIScore/register');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'customerId': customerId,
        'fcmToken': fcmToken,
        'deviceType': deviceType,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Device registration failed: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> unregisterDevice() async {
    if (fcmToken == null) {
      throw Exception('FCM token not available yet.');
    }

    final uri = Uri.parse('$_baseUrl/api/v1.0/AIScore/unregister');
    final response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fcmToken': fcmToken}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Device unregister failed: ${response.statusCode} ${response.body}');
    }
  }
}
