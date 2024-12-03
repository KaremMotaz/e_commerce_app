import 'package:e_commerce_app/constants/custom_colors.dart';
import 'package:e_commerce_app/pages/reset_password_page.dart';
import 'package:e_commerce_app/pages/sign_up_page.dart';
import 'package:e_commerce_app/provider/google_signin.dart';
import 'package:e_commerce_app/widgets/custom_elevated_button.dart';
import 'package:e_commerce_app/widgets/custom_row_text.dart';
import 'package:e_commerce_app/widgets/custom_snakbar.dart';
import 'package:e_commerce_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final passwordController = TextEditingController();

  final emailController = TextEditingController();

  bool isObscureText = true;
  bool isloading = false;

  login() async {
    try {
      setState(() {
        isloading = true;
      });
      // ignore: unused_local_variable
      final UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (!mounted) return;
      showSnackBar(context, "Done...");
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, "Wrong password provided for that user.");
      } else {
        showSnackBar(context, "Error : ${e.code}");
      }
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Sign In',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: backgroundColorPage,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
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
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  onChanged: (password) {},
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return "Password cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  myController: passwordController,
                  obscureText: isObscureText,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscureText = !isObscureText;
                      });
                    },
                    icon: isObscureText
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                  hintText: "Enter Your Password : ",
                  keyboardType: TextInputType.text,
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
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                  onPressed: () async {
                    await login();
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ),
                ),
                CustomRowText(
                  text1: "Don't have an account ? ",
                  text2: "Sign Up",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 17,
                ),
                const SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        thickness: 0.6,
                        color: Colors.black,
                      )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "OR",
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.6,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                GestureDetector(
                  onTap: () {
                    googleSignInProvider.googleLogin();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 200, 67, 79),
                        width: 1,
                      ),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/google.svg",
                      colorFilter: const ColorFilter.mode(
                          Color.fromARGB(255, 200, 67, 79), BlendMode.srcIn),
                      height: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
