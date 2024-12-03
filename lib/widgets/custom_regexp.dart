// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomRegexp extends StatelessWidget {
  const CustomRegexp({super.key, required this.text, required this.isDone});
  final String text;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isDone? Colors.green : Colors.white,
            shape: BoxShape.circle,
            border:isDone? Border.all(color: Colors.green) : Border.all(color: Colors.grey),
          ),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 15,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(text),
        )
      ],
    );
  }
}
