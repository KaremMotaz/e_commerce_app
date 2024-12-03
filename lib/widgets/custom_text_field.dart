import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.obscureText,
    required this.hintText,
    required this.keyboardType,
    required this.myController,
    required this.validator,
    required this.suffixIcon,
    required this.onChanged,
  });
  final bool obscureText;
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController myController;
  final FormFieldValidator validator;
  final Widget suffixIcon;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: myController,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        // To delete borders
        enabledBorder: OutlineInputBorder(
          borderSide: Divider.createBorderSide(context),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        fillColor: Colors.grey[200],
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
    );
  }
}
