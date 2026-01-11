import 'package:clonespotify/common/helpers/is_dark_mode.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget{
  const CustomAppBar({super.key,
   this.hideBackButton=false,
   this.title,
   this.action,
  this.backgroundColor});
  final bool hideBackButton;
  final Widget? title;
  final Widget?action;
  final Color? backgroundColor;
  @override 
  Widget build(BuildContext context){
    return AppBar(
      backgroundColor:Colors.transparent,
      centerTitle:true,
      elevation: 0,
      actions:[action??Container()],
      leading:hideBackButton?Container()
      :IconButton(
        onPressed:(){
          Navigator.pop(context);
        },
        icon:Container(
          height:50,
          width:50,
          decoration:BoxDecoration(
            shape:BoxShape.circle,
            color:context.isDarkMode
            ?Colors.white.withValues(alpha:200)
            :Colors.white.withValues(alpha:200)
          ),
          child:Icon(
            Icons.arrow_back_ios,
            color:context.isDarkMode
            ?Colors.black
            :Colors.black,
          ),
        ),
      ),
    );
  }
}