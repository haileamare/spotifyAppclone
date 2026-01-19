import 'package:clonespotify/data/models/createuserreq.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class AuthFirebaseService {
  Future<Either> signUp(CreateUserReq req);
  Future<Either> signIn();
}

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  @override
  Future<Either> signUp(CreateUserReq req) async {
    try {
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: req.email,
        password: req.password,
      );

      
      return Right(result);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Left('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return Left('The account already exists for that email.');
      } else {
        return Left(e.message);
      }
    }
  }

  @override
  Future<Either> signIn() async {
    throw UnimplementedError();
  }
}
