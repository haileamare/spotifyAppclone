
import 'package:clonespotify/common/helpers/is_dark_mode.dart';
import 'package:clonespotify/common/widgets/appbar/customappbar.dart';
import 'package:clonespotify/common/widgets/button/common_button.dart';
import 'package:clonespotify/core/configs/assets/app_images.dart';
import 'package:clonespotify/core/configs/assets/app_vectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SigninorSignupPage extends StatelessWidget{
  const SigninorSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          CustomAppBar(),
          Align(
            alignment:Alignment.topRight,
            child:SvgPicture.asset(
              AppVectors.topPattern,
            ),
          ),
          Align(
            alignment:Alignment.bottomRight,
            child:SvgPicture.asset(
              AppVectors.bottomPattern
            ),
          ),
          Align(
            alignment:Alignment.bottomLeft,
            child:Image.asset(
              AppImages.authBG,
              fit:BoxFit.none
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:35,right:30),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children:[
                Align(
                  alignment:Alignment.center,
                  child:SvgPicture.asset(
                    AppVectors.logo,
                  ),
                ),
                SizedBox(height:30),
                Text(
                  "Sign In Or Sign Up Page",
                  style:TextStyle(
                    fontSize:25,
                    fontWeight:FontWeight.bold,
                    color:context.isDarkMode?Colors.white:Colors.black,
                  ),
                ),
                SizedBox(height:15),
                Text(
                  "Spotify is a Propertiary Swedish audio streaming and media service provider",
                  textAlign:TextAlign.center,
                  style:TextStyle(
                    color:context.isDarkMode?Colors.white70:Colors.black87,
                    fontSize:16            )
                ),
                SizedBox(height:40),
                Row(
                  children: [
                    Expanded(
                      flex:1,
                      child:CustomButton(
                        title:"Register",
                        height:70,
                        onPressed:(){}
                      )
                    ),
                    SizedBox(width:20),
                    Expanded(
                      flex:1,
                      child: TextButton(
                        onPressed:(){},
                        child:Text(
                          "Sign In",
                          style:TextStyle(
                            color:context.isDarkMode?Colors.white:Colors.black
                          ),
                          )
                      ),
                    ),
                  ],
                ),
              ]
            ),
          )
        ],
      )
    );
  }
}