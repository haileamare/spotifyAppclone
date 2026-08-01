import 'package:clonespotify/core/services/push_notification_service.dart';
import 'package:clonespotify/presentation/service_locatorinjection.dart';
import 'package:flutter/material.dart';

class Rootpage extends StatelessWidget {
  const Rootpage({super.key});

  @override
  Widget build(BuildContext context) {
    final pushService = sl<PushNotificationService>();

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
                return ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(notification.title),
                  subtitle: Text(notification.body),
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
