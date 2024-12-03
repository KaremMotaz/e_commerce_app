import 'package:flutter/material.dart';

class CustomRowText extends StatelessWidget {
  const CustomRowText(
      {super.key,
      required this.text1,
      required this.text2,
      required this.onPressed});
  final String text1;
  final String text2;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text1),
        TextButton(
          onPressed: onPressed,
          style: const ButtonStyle(
              padding:
                  WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 0))),
          child: Text(
            text2,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue
            ),
          ),
        ),
      ],
    );
  }
}
