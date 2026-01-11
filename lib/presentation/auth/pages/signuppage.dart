import 'package:clonespotify/common/helpers/is_dark_mode.dart';
import 'package:clonespotify/common/widgets/appbar/customappbar.dart';
import 'package:clonespotify/common/widgets/button/common_button.dart';
import 'package:clonespotify/core/configs/assets/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUpPage extends StatelessWidget{
  const SignUpPage({super.key});

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:8,horizontal:20 ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                SizedBox(height:30),
                _RegisterText(context),
                SizedBox(height:40),
                _FullNameTextField(),
                SizedBox(height:30),
                _EmailTextField(),
                SizedBox(height:30),
                _PasswordTextField(),
                SizedBox(height:20),
                CustomButton(
                    title:"Sign Up",
                    height:70,
                    onPressed:(){
                      // Handle sign up logic here
                    },
                  ),
                SizedBox(height:30),
                Divider(),
                SizedBox(height:20),

                Row(
                  children:[
                    Icon(Icons.facebook),
                    Icon(Icons.abc),
                  ]
                ),
              ]
            ),
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