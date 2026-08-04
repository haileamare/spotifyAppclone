import 'dart:html';

const String _defaultNotificationIcon = '/icons/Icon-192.png';

Future<bool> requestWebNotificationPermission() async {
  if (Notification.permission == 'granted') {
    return true;
  }

  final permission = await Notification.requestPermission();
  return permission == 'granted';
}

void showWebNotification(String title, String body) {
  if (Notification.permission != 'granted') {
    print('showWebNotification: permission not granted: ${Notification.permission}');
    return;
  }

  try {
    print('showWebNotification: title=$title body=$body');
    Notification(title,
        body: body,
        icon: _defaultNotificationIcon);
  } catch (error) {
    print('showWebNotification: failed to display notification, falling back to alert: $error');
    window.alert('$title\n\n$body');
  }
}
