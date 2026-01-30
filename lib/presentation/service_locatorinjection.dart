import 'package:clonespotify/core/configs/usecases/auth/usecase.dart';
import 'package:clonespotify/data/models/createuserreq.dart';
import 'package:clonespotify/data/models/signinreq.dart';
import 'package:clonespotify/data/repository/auth/authrepository.dart';
import 'package:clonespotify/data/sources/auth/auth_firebase_service.dart';
import 'package:clonespotify/domain/repositories/auth/authrepository.dart';
import 'package:clonespotify/domain/usecases/auth/signinusecase.dart';
import 'package:clonespotify/domain/usecases/auth/signupusecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

final sl=new GetIt.asNewInstance();

void setupServiceLocatorInjection(){
  sl.registerSingleton<AuthRepository>(AuthResoritoryimpl());
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<UseCases<Either,CreateUserReq>>(Signupusecase(),instanceName:"signup");
  sl.registerSingleton<UseCases<Either,Signinreq>>(Signinusecase(),instanceName:"signin");
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