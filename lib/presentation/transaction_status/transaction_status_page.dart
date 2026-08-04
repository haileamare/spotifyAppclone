import 'package:clonespotify/core/services/push_notification_service.dart';
import 'package:flutter/material.dart';

class TransactionStatusPage extends StatelessWidget {
  final NotificationPayload notification;

  const TransactionStatusPage({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final payloadEntries = notification.data.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              notification.body,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const Text(
              'Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: payloadEntries.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final entry = payloadEntries[index];
                  return ListTile(
                    title: Text(entry.key),
                    subtitle: Text(entry.value.toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
