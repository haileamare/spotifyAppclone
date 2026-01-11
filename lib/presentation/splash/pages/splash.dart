import 'package:clonespotify/core/configs/assets/app_vectors.dart';
import 'package:clonespotify/presentation/intro/pages/get_started.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends  StatefulWidget{
 SplashPage({super.key});

 @override
 State<SplashPage> createState()=>_SplashPageState();
}
class _SplashPageState extends State<SplashPage>{


@override 
void initState(){
  super.initState();
 navigateToIntro(context);
}
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:Center(
        child:SvgPicture.asset(
          AppVectors.logo
        ),
      )
    );
  }

  Future<void> navigateToIntro(BuildContext context) async {
    await Future.delayed(const Duration(seconds:3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:(context)=> GetStarted()
      )
    );
  }
}