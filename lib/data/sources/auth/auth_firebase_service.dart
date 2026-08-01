import 'package:clonespotify/data/models/createuserreq.dart';
import 'package:clonespotify/data/models/signinreq.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class AuthFirebaseService {
  Future<Either> signUp(CreateUserReq req);
  Future<Either> signIn(Signinreq req);
}

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  @override
  Future<Either> signUp(CreateUserReq req) async {
    print(req.email);
    try {
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: req.email,
        password: req.password,
      );

      return Right(result);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print("The passwor provided is too weark");
        return Left('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print("the account already exists for that email");
        return Left('The account already exists for that email.');
      } else {
        return Left(e.message);
      }
    }
  }

  @override
  Future<Either> signIn(Signinreq req) async {
     try {
      var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: req.email,
        password: req.password,
      );

      return Right(result);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print("The passwor provided is too weark");
        return Left('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print("the account already exists for that email");
        return Left('The account already exists for that email.');
      } else {
        return Left(e.message);
      }
    }
  }
  
  
}
