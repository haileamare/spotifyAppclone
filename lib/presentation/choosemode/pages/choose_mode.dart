import 'dart:ui';

import 'package:clonespotify/common/widgets/common_button.dart';
import 'package:clonespotify/core/configs/assets/app_vectors.dart';
import 'package:clonespotify/core/configs/theme/app_colors.dart';
import 'package:clonespotify/core/configs/theme/app_theme.dart';
import 'package:clonespotify/presentation/choosemode/bloc/themecubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ChooseModePage extends StatelessWidget {
  const ChooseModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/choose_mode_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withValues(alpha: 180)),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: SvgPicture.asset(AppVectors.logo)),
                Spacer(),
                Container(
                  child: Column(
                    children: [
                      Text(
                        "Choose Mode",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap:(){
                                  context.read<ThemeCubit>().UpdateTheme(ThemeMode.dark);
                                },
                                child: ClipOval(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 10,
                                      sigmaY: 10,
                                    ),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.darkGrey.withAlpha(30),
                                      ),
                                      child: SvgPicture.asset(AppVectors.moon,fit:BoxFit.none),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "Dark Mode",
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 40),
                          Column(
                            children: [
                              GestureDetector(
                                onTap:(){
                                  context.read<ThemeCubit>().UpdateTheme(ThemeMode.light);
                                },
                                child: ClipOval(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 10,
                                      sigmaY: 10,
                                    ),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.darkGrey.withValues(
                                          alpha: 30,
                                        ),
                                      ),
                                      child: SvgPicture.asset(AppVectors.sun,fit:BoxFit.none,),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "Light Mode",
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                CustomButton(onPressed: () {}, title: "Continue", height: 70),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
