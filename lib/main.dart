import 'package:e_commerce_app/constants/custom_colors.dart';
import 'package:e_commerce_app/pages/sign_in_page.dart';
import 'package:e_commerce_app/pages/verify_email_page.dart';
import 'package:e_commerce_app/provider/cart_model.dart';
import 'package:e_commerce_app/provider/google_signin.dart';
import 'package:e_commerce_app/widgets/custom_snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Supabase.initialize(
    url: "https://mpnukfsljfmzbtdrdesl.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1wbnVrZnNsamZtemJ0ZHJkZXNsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMwMzQ4NTEsImV4cCI6MjA0ODYxMDg1MX0.rwRwJQXA1Xh3IAqnHzRAh1sgB_fHEKcWyNHKztB5gTM",
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return CartModel();
        }),
        ChangeNotifierProvider(create: (context) {
          return GoogleSignInProvider();
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: appbarGreen),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Colors.white,
              );
            } else if (snapshot.hasData) {
              return const VerifyEmailPage();
            } else if (snapshot.hasError) {
              return showSnackBar(context, "Something went wrong");
            } else {
              return const SignInPage();
            }
          },
        ),
      ),
    );
  }
}
