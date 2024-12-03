import 'package:e_commerce_app/constants/custom_colors.dart';
import 'package:flutter/material.dart';

class TitleContainerProfile extends StatelessWidget {
  const TitleContainerProfile({super.key,required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
          color: btnGreen, borderRadius: BorderRadius.circular(15)),
      child:  Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
