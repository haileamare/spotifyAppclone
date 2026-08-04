import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'web_notification_helper.dart';
import 'package:clonespotify/presentation/service_locatorinjection.dart';
import 'package:clonespotify/presentation/navigation/navigation_service.dart';
import 'package:clonespotify/presentation/transaction_status/transaction_status_page.dart';

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
  static const String _customBackendHost = String.fromEnvironment('BACKEND_HOST');
  static const int _backendPort = 63681;

  static List<String> get _baseUrls {
    if (_customBackendHost.isNotEmpty) {
      return ['http://$_customBackendHost:$_backendPort'];
    }

    if (kIsWeb) {
      return ['http://localhost:$_backendPort'];
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return [
          //'http://10.0.2.2:$_backendPort',
    //      'http://10.0.3.2:$_backendPort',
          'http://127.0.0.1:$_backendPort',
        ];
      case TargetPlatform.iOS:
        return ['http://127.0.0.1:$_backendPort'];
      default:
        return ['http://localhost:$_backendPort'];
    }
  }

  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final ValueNotifier<List<NotificationPayload>> notifications =
      ValueNotifier<List<NotificationPayload>>([]);
  final ValueNotifier<NotificationPayload?> latestNotification =
      ValueNotifier<NotificationPayload?>(null);

  String? fcmToken;
  String? _lastRegisteredToken;

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  String get _deviceType {
    if (kIsWeb) return 'Web';

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.macOS:
        return 'macOS';
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.linux:
        return 'Linux';
      case TargetPlatform.fuchsia:
        return 'Fuchsia';
    }
  }

  Future<void> init() async {
    if (kIsWeb) {
      await _initializeWebMessaging();
    } else {
      await _initializeMobileMessaging();
    }
  }
void Function(NotificationPayload payload)? onForegroundNotificationReceived;
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
    final hasPermission = await _requestPermission();
    debugPrint('PushNotificationService: web notification permission granted: $hasPermission');
    if (!hasPermission) {
      debugPrint('PushNotificationService: web notification permission denied');
      return;
    }

    await _initializeMessagingListeners(showLocalNotification: false);
  }

  Future<void> _initializeMessagingListeners({required bool showLocalNotification}) async {
    fcmToken = await _messaging.getToken();
    debugPrint('PushNotificationService: current FCM token: $fcmToken');

    if (fcmToken != null) {
      await _registerCurrentToken();
    }

    _messaging.onTokenRefresh.listen((newToken) async {
      final oldToken = _lastRegisteredToken ?? fcmToken;
      if (oldToken != null && oldToken != newToken) {
        await _unregisterToken(oldToken);
      }

      fcmToken = newToken;
      debugPrint('PushNotificationService: token refreshed: $newToken');
      await _registerCurrentToken();
    });

    FirebaseMessaging.onMessage.listen((message) async {
      debugPrint('PushNotificationService: received foreground message: ${message.messageId}');
      debugPrint('PushNotificationService: message.notification=${message.notification}');
      debugPrint('PushNotificationService: message.data=${message.data}');
      _addNotification(message, source: 'foreground');

      if (latestNotification.value != null) {
        debugPrint('PushNotificationService: calling foreground notification handler for title=${latestNotification.value!.title} body=${latestNotification.value!.body}');
        onForegroundNotificationReceived?.call(latestNotification.value!);
      }
      if (kIsWeb) {
        final title = message.notification?.title ?? message.data['title'] ?? 'New notification';
        final body = message.notification?.body ?? message.data['body'] ?? 'You have received a new message.';
        
        debugPrint('PushNotificationService: showing web notification title=$title body=$body');
        showWebNotification(title, body);
      } else if (showLocalNotification) {
        await _showLocalNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('PushNotificationService: message opened from app: ${message.messageId}');
      _addNotification(message, source: 'opened_app');
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _addNotification(initialMessage, source: 'initial_message');
    }
  }

  Future<bool> _requestPermission() async {
    if (kIsWeb) {
      final granted = await requestWebNotificationPermission();
      if (!granted) {
        throw Exception('Web notification permission denied');
      }
      return true;
    }

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

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
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
        try {
          final payloadStr = response.payload ?? '';
          Map<String, dynamic> data = {};
          if (payloadStr.isNotEmpty) {
            data = jsonDecode(payloadStr) as Map<String, dynamic>;
          }

          final notificationPayload = NotificationPayload(
            title: data['title'] ?? 'Notification',
            body: data['body'] ?? '',
            data: data,
            receivedAt: DateTime.now(),
            source: 'local_tap',
          );

          // Navigate to transaction status page using NavigationService
          final nav = sl<NavigationService>();
          nav.pushWidget(TransactionStatusPage(notification: notificationPayload));
        } catch (e, st) {
          debugPrint('Failed handling notification tap: $e');
          debugPrint('$st');
        }
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
    final payload = NotificationPayload(
      title: message.notification?.title ?? 'No title',
      body: message.notification?.body ?? 'No body',
      data: message.data,
      receivedAt: DateTime.now(),
      source: source,
    );
    notifications.value = [
      ...notifications.value,
      payload,
    ];
    latestNotification.value = payload;
  }

  Future<void> _registerCurrentToken() async {
    if (fcmToken == null) {
      return;
    }
    debugPrint('PushNotificationService: registering FCM token: $fcmToken');
    final int customerId = 1407; // TODO: replace with a real numeric customer ID
    try {
      await registerDevice(
        customerId: customerId,
        deviceType: _deviceType,
      );
      _lastRegisteredToken = fcmToken;
    } catch (error, stackTrace) {
      debugPrint('PushNotificationService: failed to register FCM token: $error');
      debugPrint('$stackTrace');
    }
  }

  Future<http.Response> _sendRequest(
      String method, String path, Map<String, dynamic> body) async {
    for (final baseUrl in _baseUrls) {
      final uri = Uri.parse('$baseUrl$path');
      try {
        final response = await (method == 'POST'
            ? http.post(
                uri,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(body),
              )
            : http.delete(
                uri,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(body),
              ));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }

        debugPrint('PushNotificationService: request failed for $uri: ${response.statusCode} ${response.body}');
      } catch (error) {
        debugPrint('PushNotificationService: request error for $uri: $error');
      }
    }

    throw Exception('All backend endpoints failed: ${_baseUrls.join(', ')}');
  }

  Future<void> _unregisterToken(String tokenToRemove) async {
    final response = await _sendRequest(
      'DELETE',
      '/api/v1.0/AIScore/unregister',
      {'fcmToken': tokenToRemove},
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
    required int customerId,
    String deviceType = 'Web',
  }) async {
    if (fcmToken == null) {
      throw Exception('FCM token not available yet.');
    }

    final response = await _sendRequest(
      'POST',
      '/api/v1.0/AIScore/register',
      {
        'customerId': customerId,
        'fcmToken': fcmToken,
        'deviceType': deviceType,
      },
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

    final response = await _sendRequest(
      'DELETE',
      '/api/v1.0/AIScore/unregister',
      {'fcmToken': fcmToken},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Device unregister failed: ${response.statusCode} ${response.body}');
    }
  }
}
