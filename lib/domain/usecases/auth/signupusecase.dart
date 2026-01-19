import 'package:clonespotify/core/configs/usecases/auth/signupusecase.dart';
import 'package:clonespotify/data/models/createuserreq.dart';
import 'package:clonespotify/domain/repositories/auth/authrepository.dart';
import 'package:clonespotify/presentation/service_locatorinjection.dart';
import 'package:dartz/dartz.dart';

class Signupusecase implements UseCases<Either,CreateUserReq>{
  @override
  Future<Either> call(CreateUserReq? params)  {
    return  sl<AuthRepository>().signIn(params!);
  }
}