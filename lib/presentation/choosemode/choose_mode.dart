import 'package:flutter/material.dart';

class ChooseMode extends StatefulWidget{
const ChooseMode({super.key});
@override
State<StatefulWidget> createState(){
  return _ChooseModeState();
}
}
class _ChooseModeState extends State<ChooseMode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/choose_mode_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withValues(alpha: 180),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(),
            child: Column(),
          ),
        ],
      ),
    );
  }
}