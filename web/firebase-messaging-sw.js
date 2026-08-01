self.addEventListener('install', (event) => {
  console.log('[firebase-messaging-sw] install');
});

self.addEventListener('activate', (event) => {
  console.log('[firebase-messaging-sw] activate');
});

try {
  importScripts('https://www.gstatic.com/firebasejs/9.24.0/firebase-app.js');
  importScripts('https://www.gstatic.com/firebasejs/9.24.0/firebase-messaging.js');

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
} catch (error) {
  console.error('[firebase-messaging-sw] initialization failed', error);
}
