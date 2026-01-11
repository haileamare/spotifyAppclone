import 'package:clonespotify/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color? color;
  final double? height;   // nullable double

  const CustomButton({
    required this.onPressed,
    super.key,
    required this.title,
     this.color,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      
      onPressed:onPressed,
      style:ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ??80),
      
      ),
      child:Text(
        title,),
        
    );
  }
}