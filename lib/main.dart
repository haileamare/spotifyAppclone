import 'package:clonespotify/core/configs/theme/app_theme.dart';
import 'package:clonespotify/firebase_options.dart';
import 'package:clonespotify/presentation/choosemode/bloc/themecubit.dart';
import 'package:clonespotify/presentation/splash/pages/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // New way: Use HydratedStorage.build() without arguments 
  // and provide the directory directly to the storage property.
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getApplicationDocumentsDirectory()).path),
  );

  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers:[
        BlocProvider(
          create:(context)=>ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit,ThemeMode>(
        builder: (BuildContext context,ThemeMode themeMode) {
            return MaterialApp(
            title: 'Flutter Demo',
            theme:AppTheme.lightTheme,
            themeMode:themeMode,
            darkTheme: AppTheme.dartTheme,
            home:SplashPage()
          );
        }
      ),
    );
  }
}

