import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key,
      required this.customWidget,
      required this.onPressed,
      required this.btnColor});
  final Widget customWidget;
  final VoidCallback onPressed;
  final Color btnColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(btnColor),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(12)),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
      child: customWidget,
    );
  }
}
