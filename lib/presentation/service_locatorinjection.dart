import 'package:clonespotify/core/services/push_notification_service.dart';
import 'package:clonespotify/data/repository/auth/authrepository.dart';
import 'package:clonespotify/data/sources/auth/auth_firebase_service.dart';
import 'package:clonespotify/domain/repositories/auth/authrepository.dart';
import 'package:clonespotify/domain/usecases/auth/signupusecase.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.asNewInstance();

void setupServiceLocatorInjection(){
  sl.registerSingleton<AuthRepository>(AuthResoritoryimpl());
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<Signupusecase>(Signupusecase(), instanceName: "signup");
  sl.registerLazySingleton<PushNotificationService>(() => PushNotificationService());
  sl.registerSingleton<TextEditingController>(TextEditingController(),
  instanceName: 'name',
  dispose: (controller)=>controller.dispose());
    sl.registerSingleton<TextEditingController>(TextEditingController(),
  instanceName: 'email',
  dispose: (controller)=>controller.dispose());
    sl.registerSingleton<TextEditingController>(TextEditingController(),
  instanceName: 'password',
  dispose: (controller)=>controller.dispose());
}