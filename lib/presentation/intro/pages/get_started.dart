import 'package:clonespotify/common/widgets/common_button.dart';
import 'package:clonespotify/core/configs/assets/app_images.dart';
import 'package:clonespotify/core/configs/assets/app_vectors.dart';
import 'package:clonespotify/core/configs/theme/app_colors.dart';
import 'package:clonespotify/presentation/choosemode/pages/choose_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GetStarted extends StatelessWidget{
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:Stack(
        children:[
          Container(
            padding:EdgeInsets.all(10),
            decoration:BoxDecoration(
              image: DecorationImage(
                image:AssetImage(AppImages.introBG),
                fit:BoxFit.fill
              )
            )
          ),
          Container(
            color: Color.fromARGB(100,0,0,0),
          ),
          Container(
           padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: SvgPicture.asset(
                    AppVectors.logo,
                    
                  ),
                ),
                Spacer(),
                Text("Enjoy listining to music",textAlign:TextAlign.center,
                style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold,fontSize:20)),
                SizedBox(height:15),
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",textAlign:TextAlign.center,
                style:TextStyle(color:Colors.white70,fontSize: 12)),
                SizedBox(height:20),
                CustomButton(
                title: "Get Started",
                onPressed: (){
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:(context) =>const ChooseModePage()
                  )
                  );
                },
                height:80,
                ),
                SizedBox(height:20)
              ],
            ),
          )
        ]
      )
    );
  }
}