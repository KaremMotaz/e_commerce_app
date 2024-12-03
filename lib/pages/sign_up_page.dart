// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:e_commerce_app/pages/verify_email_page.dart';
import 'package:path/path.dart' show basename;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/constants/custom_colors.dart';
import 'package:e_commerce_app/pages/sign_in_page.dart';
import 'package:e_commerce_app/widgets/custom_elevated_button.dart';
import 'package:e_commerce_app/widgets/custom_regexp.dart';
import 'package:e_commerce_app/widgets/custom_row_text.dart';
import 'package:e_commerce_app/widgets/custom_snakbar.dart';
import 'package:e_commerce_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  final ageController = TextEditingController();
  final jobTitleController = TextEditingController();

  SupabaseClient supabase = Supabase.instance.client;
  File? imgPath;
  String? url;

  bool isloading = false;
  bool isObscureText = true;
  bool isPassWord6char = false;
  bool isPassWordHas1number = false;
  bool isPassWordHasUppercase = false;
  bool isPassWordHasLowercase = false;
  bool isPassWordHasSpecialChar = false;

  register() async {
    try {
      setState(() {
        isloading = true;
      });
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Upload image to supabase storage
      await supabase.storage
          .from("image")
          .upload(url!, imgPath!)
          .then((value) => showSnackBar(context, "Done"));
      // Get image from supabase storage
      String urlFromSupabase = supabase.storage.from("image").getPublicUrl("$url");

      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      users
          .doc(credential.user!.uid)
          .set(
            {
              'imgLink': urlFromSupabase,
              'Email': emailController.text,
              'Password': passwordController.text,
              'UserName': userNameController.text,
              'Age': ageController.text,
              'JopTitle': jobTitleController.text,
            },
          )
          .then((value) => showSnackBar(context, "User Added"))
          .catchError(
            (error) => showSnackBar(context, "Failed to add user: $error"),
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, "The account already exists for that email.");
      } else {
        showSnackBar(context, "Error");
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isloading = false;
    });
  }

  onPasswordChanged(String password) {
    isPassWord6char = false;
    isPassWordHas1number = false;
    isPassWordHasUppercase = false;
    isPassWordHasLowercase = false;
    isPassWordHasSpecialChar = false;
    setState(() {
      if (password.contains(RegExp(r'.{6,}'))) {
        isPassWord6char = true;
      }
      if (password.contains(RegExp(r'[0-9]'))) {
        isPassWordHas1number = true;
      }
      if (password.contains(RegExp(r'[A-Z]'))) {
        isPassWordHasUppercase = true;
      }
      if (password.contains(RegExp(r'[a-z]'))) {
        isPassWordHasLowercase = true;
      }
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        isPassWordHasSpecialChar = true;
      }
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    jobTitleController.dispose();
    ageController.dispose();
    super.dispose();
  }

  uploadImageToScreen({required ImageSource source}) async {
    final pickedImg = await ImagePicker().pickImage(
      source: source,
    );
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          url = basename(pickedImg.path);
          int random = Random().nextInt(999);
          url = "$random$url";
        });
      } else {
        showSnackBar(context, "NO img selected");
      }
    } catch (e) {
      showSnackBar(context, "Error => $e");
    }
  }

  showModel() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return IntrinsicHeight(
          child: Container(
            padding: const EdgeInsets.only(left: 5, top: 10, bottom: 10),
            color: Colors.white,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    uploadImageToScreen(source: ImageSource.camera);
                    Navigator.pop(context);
                  },
                  label: const Text(
                    "From Camera",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  icon: const Icon(
                    Icons.camera,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    uploadImageToScreen(source: ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  label: const Text(
                    "From Gallery",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  icon: const Icon(
                    Icons.image,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: backgroundColorPage,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[500],
                    ),
                    child: Stack(
                      children: [
                        imgPath == null
                            ? CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                radius: 70,
                                backgroundImage: const AssetImage(
                                    "assets/images/avatar.png"),
                              )
                            : ClipOval(
                                child: Image.file(
                                  imgPath!,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        Positioned(
                          bottom: -10,
                          left: 104,
                          child: IconButton(
                            onPressed: () {
                              showModel();
                            },
                            icon: const Icon(Icons.add_a_photo),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 33,
                  ),
                  CustomTextField(
                    onChanged: (username) {},
                    validator: (username) {
                      return username.contains(
                        RegExp(r'[a-z]'),
                      )
                          ? null
                          : "Enter a valid name";
                    },
                    myController: userNameController,
                    obscureText: false,
                    suffixIcon: const Icon(Icons.person),
                    hintText: "Enter Your Name : ",
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    onChanged: (age) {},
                    validator: (age) {
                      return age.contains(
                        RegExp(r'[0-9]'),
                      )
                          ? null
                          : "Enter a valid age";
                    },
                    myController: ageController,
                    obscureText: false,
                    suffixIcon: const Icon(Icons.numbers),
                    hintText: "Enter Your Age : ",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    onChanged: (jobTitle) {},
                    validator: (jobTitle) {
                      return jobTitle.contains(
                        RegExp(r'[a-z]'),
                      )
                          ? null
                          : "Enter a valid job title";
                    },
                    myController: jobTitleController,
                    obscureText: false,
                    suffixIcon: const Icon(Icons.work),
                    hintText: "Enter Your job title : ",
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                    height: 20,
                  ),
                  CustomTextField(
                    onChanged: (password) {
                      onPasswordChanged(password);
                    },
                    validator: (value) {
                      return value != null && value.length < 6
                          ? "Enter a password greater than or equal 6 character"
                          : null;
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
                    height: 20,
                  ),
                  CustomRegexp(
                    text: "At least 6 character",
                    isDone: isPassWord6char,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomRegexp(
                    text: "At least 1 nummber",
                    isDone: isPassWordHas1number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomRegexp(
                    text: "Has uppercase",
                    isDone: isPassWordHasUppercase,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomRegexp(
                    text: "Has lowercase",
                    isDone: isPassWordHasLowercase,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomRegexp(
                    text: "Has special characters",
                    isDone: isPassWordHasSpecialChar,
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
                            "Register",
                            style: TextStyle(color: Colors.white, fontSize: 19),
                          ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          imgPath != null &&
                          url != null) {
                        await register();
                        if (!mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VerifyEmailPage(),
                          ),
                        );
                      } else {
                        showSnackBar(context, "Error");
                      }
                      // Navigator.pushReplacementNamed(context, '/HomePage');
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomRowText(
                    text1: "Already have an account ?",
                    text2: "Sign In",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
