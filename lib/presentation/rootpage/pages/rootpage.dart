import 'dart:convert';

import 'package:clonespotify/core/services/push_notification_service.dart';
import 'package:clonespotify/presentation/service_locatorinjection.dart';
import 'package:flutter/material.dart';

class Rootpage extends StatefulWidget {
  const Rootpage({super.key});

  @override
  State<Rootpage> createState() => _RootpageState();
}

class _RootpageState extends State<Rootpage> {
  late final PushNotificationService pushService;
  NotificationPayload? _lastShownNotification;
  bool _payloadDialogShown = false;

  @override
  void initState() {
    super.initState();
    pushService = sl<PushNotificationService>();
    pushService.latestNotification.addListener(_handleLatestNotification);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForClickedPayload();
    });
  }

  @override
  void dispose() {
    pushService.latestNotification.removeListener(_handleLatestNotification);
    super.dispose();
  }

  void _handleLatestNotification() {
    final notification = pushService.latestNotification.value;
    if (notification == null || notification == _lastShownNotification) {
      return;
    }

    _lastShownNotification = notification;
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${notification.title}: ${notification.body}'),
        duration: const Duration(seconds: 5),
      ),
    );

    _showNotificationDialog(notification);
  }

  void _showNotificationDialog(NotificationPayload notification) {
    if (!mounted) return;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(notification.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.body),
                const SizedBox(height: 8),
                const Text('Payload:'),
                const SizedBox(height: 4),
                ...notification.data.entries.map(
                  (entry) => Text('${entry.key}: ${entry.value}'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _checkForClickedPayload() {
    final payloadQuery = Uri.base.queryParameters['payload'];
    if (payloadQuery == null || payloadQuery.isEmpty || _payloadDialogShown) {
      return;
    }

    try {
      final payloadJson = Uri.decodeComponent(payloadQuery);
      final payload = jsonDecode(payloadJson) as Map<String, dynamic>;
      _payloadDialogShown = true;
      _showPayloadDialog(payload);
    } catch (_) {
      // ignore malformed payload
    }
  }

  void _showPayloadDialog(Map<String, dynamic> payload) {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notification payload'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: payload.entries
                  .map((entry) => Text('${entry.key}: ${entry.value}'))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync_disabled),
            tooltip: 'Unregister device',
            onPressed: () async {
              try {
                await pushService.unregisterDevice();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Device unregistered successfully.')),
                  );
                }
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Unregister failed: $error')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ValueListenableBuilder<List<NotificationPayload>>(
          valueListenable: pushService.notifications,
          builder: (context, notifications, _) {
            if (notifications.isEmpty) {
              return const Center(
                child: Text('No push notifications received yet.'),
              );
            }

            return ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final payloadText = notification.data.entries
                    .map((entry) => '${entry.key}: ${entry.value}')
                    .join(', ');
                return ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(notification.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.body),
                      const SizedBox(height: 4),
                      Text(
                        payloadText,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Text(
                    notification.source.toUpperCase(),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
