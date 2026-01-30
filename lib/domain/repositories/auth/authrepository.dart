import 'package:clonespotify/data/models/createuserreq.dart';
import 'package:clonespotify/data/models/signinreq.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository{
  Future<Either> signUp(CreateUserReq req);
  Future<Either> signIn(Signinreq req);
}