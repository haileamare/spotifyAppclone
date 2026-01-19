import 'package:clonespotify/data/models/createuserreq.dart';
import 'package:clonespotify/data/sources/auth/auth_firebase_service.dart';
import 'package:clonespotify/domain/repositories/auth/authrepository.dart';
import 'package:clonespotify/presentation/service_locatorinjection.dart';
import 'package:dartz/dartz.dart';

class AuthResoritoryimpl implements AuthRepository{
  
  @override
  Future<Either> signUp(CreateUserReq? req) async{
    var result=await sl<AuthFirebaseService>().signUp(req!);
    return result;
  }
  
  @override
  Future<Either<dynamic, dynamic>> signIn(CreateUserReq createUserReq) {
    // TODO: implement signIn
    throw UnimplementedError();
  }
}