import 'package:clonespotify/core/configs/theme/app_theme.dart';
import 'package:clonespotify/core/services/push_notification_service.dart';
import 'package:clonespotify/firebase_options.dart';
import 'package:clonespotify/presentation/choosemode/bloc/themecubit.dart';
import 'package:clonespotify/presentation/service_locatorinjection.dart';
import 'package:clonespotify/presentation/splash/pages/splash.dart';
import 'package:clonespotify/presentation/transaction_status/transaction_status_page.dart';
import 'package:clonespotify/presentation/navigation/navigation_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getApplicationDocumentsDirectory()).path),
  );
  
  setupServiceLocatorInjection();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  final pushService = sl<PushNotificationService>();
  await pushService.init();

  runApp(const MyApp());
}

// Convert MyApp to a StatefulWidget to handle global listeners
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    final pushService = sl<PushNotificationService>();

    // Listen directly to latestNotification ValueNotifier
    pushService.latestNotification.addListener(_handleForegroundNotification);
  }

  void _handleForegroundNotification() {
    final payload = sl<PushNotificationService>().latestNotification.value;
    // Only display SnackBar for foreground notifications
    if (payload == null || payload.source != 'foreground') return;

    // Ensure we run UI code after the current frame so the
    // ScaffoldMessenger is attached to the widget tree.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        final messenger = _scaffoldMessengerKey.currentState;
        messenger?.hideCurrentSnackBar();
        messenger?.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payload.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(payload.body),
              ],
            ),
            action: SnackBarAction(
              label: 'View',
              onPressed: () {
                sl<NavigationService>().pushWidget(TransactionStatusPage(notification: payload));
              },
            ),
          ),
        );
      } catch (e, st) {
        debugPrint('Failed to show snackbar: $e');
        debugPrint('$st');
      }
    });
  }

  @override
  void dispose() {
    sl<PushNotificationService>().latestNotification.removeListener(_handleForegroundNotification);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (BuildContext context, ThemeMode themeMode) {
          return MaterialApp(
            scaffoldMessengerKey: _scaffoldMessengerKey,
            navigatorKey: sl<NavigationService>().navigatorKey,
            title: 'Flutter Demo',
            theme: AppTheme.lightTheme,
            themeMode: themeMode,
            darkTheme: AppTheme.dartTheme,
            home: SplashPage(),
          );
        },
      ),
    );
  }
}