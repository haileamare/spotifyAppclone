import 'package:clonespotify/common/widgets/button/customeButtom.dart';
import 'package:clonespotify/core/configs/theme/app_colors.dart';
import 'package:clonespotify/presentation/choosemode/choose_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/intro_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withValues(alpha: 0.15)),
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'vectors/spotify_logo.svg',
                  width: 70,
                  height: 70,
                ),
                Spacer(),
                Text(
                  "Enjoy Listening to music",
                  style: TextStyle(
                    color: AppColors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'satoshi',
                  ),
                ),
                SizedBox(height: 20),
                const Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  style: TextStyle(color: AppColors.grey,
                  fontFamily: 'satoshi',
                  fontSize:15),
                  softWrap: true,
                ),
                SizedBox(height:15),
                CustomButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder:(context)=>
                      ChooseMode())
                    );
                  },
                  title: "Get Started",
                  height: 90,
                ),
                SizedBox(height:20)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
