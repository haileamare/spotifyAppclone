import 'package:clonespotify/core/configs/usecases/auth/usecase.dart';
import 'package:clonespotify/data/models/signinreq.dart';
import 'package:clonespotify/domain/repositories/auth/authrepository.dart';
import 'package:clonespotify/presentation/service_locatorinjection.dart';
import 'package:dartz/dartz.dart';

class Signinusecase extends UseCases<Either,Signinreq>{
  Future<Either> call(Signinreq req){
     return sl<AuthRepository>().signIn(req);
  }
}