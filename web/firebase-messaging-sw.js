self.addEventListener('install', (event) => {
  console.log('[firebase-messaging-sw] install');
});

self.addEventListener('activate', (event) => {
  console.log('[firebase-messaging-sw] activate');
});

self.addEventListener('error', (event) => {
  console.error('[firebase-messaging-sw] error', event);
});

self.addEventListener('unhandledrejection', (event) => {
  console.error('[firebase-messaging-sw] unhandledrejection', event.reason);
});

try {
  importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js');
  importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js');

  firebase.initializeApp({
    apiKey: 'AIzaSyBES5bagY1P6uLMbdE9s2zwkv8w13NICCg',
    authDomain: 'spotifycloneha.firebaseapp.com',
    projectId: 'spotifycloneha',
    storageBucket: 'spotifycloneha.firebasestorage.app',
    messagingSenderId: '1079921888354',
    appId: '1:1079921888354:web:93fab7e927bb09ee6b553b',
  });

  const messaging = firebase.messaging();
  console.log('[firebase-messaging-sw] firebase.messaging initialized');

  messaging.onBackgroundMessage(function(payload) {
    console.log('[firebase-messaging-sw] Received background message ', payload);

    const notificationTitle = payload.notification?.title || payload.data?.title || 'Background Notification';
    const notificationOptions = {
      body: payload.notification?.body || payload.data?.body || 'You have a new message.',
      icon: '/icons/Icon-192.png',
      data: payload.data || {},
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
  });

  self.addEventListener('notificationclick', function(event) {
    console.log('[firebase-messaging-sw] notification click', event);
    event.notification.close();
    const payloadData = event.notification.data || {};
    const payloadString = encodeURIComponent(JSON.stringify(payloadData));
    const targetUrl = '/?payload=' + payloadString;

    event.waitUntil(
      clients.matchAll({ type: 'window', includeUncontrolled: true }).then(function(clientList) {
        if (clientList.length > 0) {
          const client = clientList[0];
          client.focus();
          return client.navigate(targetUrl).catch(function() {
            return clients.openWindow(targetUrl);
          });
        }
        return clients.openWindow(targetUrl);
      })
    );
  });
} catch (error) {
  console.error('[firebase-messaging-sw] initialization failed', error);
}
