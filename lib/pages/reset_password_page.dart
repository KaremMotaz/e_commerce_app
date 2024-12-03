import 'package:e_commerce_app/constants/custom_colors.dart';
import 'package:e_commerce_app/pages/sign_in_page.dart';
import 'package:e_commerce_app/widgets/custom_elevated_button.dart';
import 'package:e_commerce_app/widgets/custom_snakbar.dart';
import 'package:e_commerce_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;

  resetPassword() async {
    isloading = true;
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      if (!mounted) return;
      showSnackBar(context, "Done, please check your email");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInPage(),
        ),
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;
      showSnackBar(context, e.code);
    }
    isloading = false;
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: backgroundColorPage,
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter your email to reset your password.",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  onChanged: (email) {},
                  validator: (email) {
                    return email.contains(
                      RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"),
                    )
                        ? null
                        : "Enter a valid email";
                  },
                  myController: emailController,
                  obscureText: false,
                  suffixIcon: const Icon(
                    Icons.email,
                  ),
                  hintText: "Enter Your Email : ",
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              CustomElevatedButton(
                btnColor: btnGreen,
                customWidget: isloading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Reset password",
                        style: TextStyle(color: Colors.white, fontSize: 19),
                      ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    resetPassword();
                  } else {
                    showSnackBar(context, "Error");
                  }
                  // Navigator.pushReplacementNamed(context, '/HomePage');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
