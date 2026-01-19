import 'package:clonespotify/data/models/createuserreq.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository{
  Future<Either> signUp(CreateUserReq req);
  Future<Either> signIn(CreateUserReq createUserReq);
}