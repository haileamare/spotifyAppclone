import 'package:clonespotify/common/helpers/is_dark_mode.dart';
import 'package:clonespotify/common/widgets/appbar/customappbar.dart';
import 'package:clonespotify/common/widgets/button/common_button.dart';
import 'package:clonespotify/core/configs/assets/app_vectors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInPage extends StatelessWidget{
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(
        preferredSize:Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          false,
          title:SizedBox(
              height:90,
              width:90,
            child: SvgPicture.asset(
              AppVectors.logo,
              fit:BoxFit.contain
              ),
          ),
        ),
      ),
      body:Padding(
          padding: const EdgeInsets.symmetric(vertical:0,horizontal:20 ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                SizedBox(height:10),
                _RegisterText(context),
                SizedBox(height:15),
                RichText(
                  text:TextSpan(
                    children:[
                      TextSpan(
                        text:"If you need any support?"
                      ),
                      TextSpan(
                        text:"Click here",
                        style:TextStyle(
                          color:Colors.lightGreen[700]
                        ),
                        recognizer:TapGestureRecognizer()
                        ..onTap=() async {
                          final uri= Uri.parse("www.google.com");
                          
                        }

                      ),
                    ]
                  ),
                ),
                SizedBox(height:40),
                _FullNameTextField(),
                SizedBox(height:30),
                _EmailTextField(),
                SizedBox(height:30),
                _PasswordTextField(),
                SizedBox(height:20),
                CustomButton(
                    title:"Create Account",
                    height:70,
                    onPressed:(){
                      // Handle sign up logic here
                    },
                  ),
                SizedBox(height:30),
                Divider(),
                SizedBox(height:20),

                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  children:[
                    SizedBox(width:30),
                    Icon(FontAwesomeIcons.google,size:30),
                    Icon(FontAwesomeIcons.apple, size:35),
                    SizedBox(width:30)
                  ]
                ),
                SizedBox(height:30),
                RichText(
                  text:TextSpan(
                    children:[
                      TextSpan(text:"Do You Have Already An Account?",
                      style:TextStyle(
                        
                      )),
                      TextSpan(
                        text:"Click here",
                        style:TextStyle(
                          color:Colors.lightBlue[700]
                        ),
                        recognizer:TapGestureRecognizer()
                        ..onTap= () async {

                        }
                      ),
                    ]
                  ),
                ),
              ]
            ),
          ),
        ),
      
    );
  }

Widget _RegisterText(BuildContext context){
  return Text(
    "Register",
    textAlign: TextAlign.center,
    style:TextStyle(
      fontSize:25,
      fontWeight:FontWeight.bold,
      color:context.isDarkMode?Colors.white:Colors.black87,
    ),
  );
}

Widget _FullNameTextField(){
  return TextField(
    decoration:InputDecoration(
    contentPadding:EdgeInsets.all(30),
    hintText:"Full Name",
    border:OutlineInputBorder(
      borderRadius:BorderRadius.all(Radius.circular(20)),
      
    ),
    ),
  );
}
Widget _EmailTextField(){
  return TextField(
    decoration:InputDecoration(
    contentPadding:EdgeInsets.all(30),
    hintText:"Enter Email",
    border:OutlineInputBorder(
      borderRadius:BorderRadius.all(Radius.circular(20)),
      
    ),
    ),
  );
}
Widget _PasswordTextField(){
  return TextField(
    decoration:InputDecoration(
    contentPadding:EdgeInsets.all(30),
    hintText:"Password",
    border:OutlineInputBorder(
      borderRadius:BorderRadius.all(Radius.circular(20)),
      
    ),
    ),
  );
}
}