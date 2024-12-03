// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/constants/custom_colors.dart';
import 'package:e_commerce_app/widgets/custom_snakbar.dart';
import 'package:e_commerce_app/widgets/custom_user_image.dart';
import 'package:e_commerce_app/widgets/get_data_from_firestore.dart';
import 'package:e_commerce_app/widgets/title_container_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final credential = FirebaseAuth.instance.currentUser;
  CollectionReference usersInFireStore =
      FirebaseFirestore.instance.collection('users');
  SupabaseClient supabase = Supabase.instance.client;
  File? imgPath;
  String? url;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    uploadImagetoSupabase() async {
      if (imgPath != null) {
        setState(() {
          isLoading = true;
        });
        // Upload image to supabase storage
        await supabase.storage.from("image").upload(url!, imgPath!).then(
            (value) => showSnackBar(context, "Image uploaded successfully!"));
        // Get image from supabase storage
        String urlFromSupabase =
            supabase.storage.from("image").getPublicUrl("$url");
        usersInFireStore.doc(credential?.uid).update(
          {
            'imgLink': urlFromSupabase,
          },
        ).catchError((error) {
          showSnackBar(context, "Failed to add user: $error");
        });
      }
      setState(() {
        isLoading = false;
      });
    }

    Future showModel() {
      uploadImageToScreen(context, {required ImageSource source}) async {
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
                    onPressed: () async {
                      await uploadImageToScreen(
                          source: ImageSource.camera, context);
                      Navigator.pop(context);
                      await uploadImagetoSupabase();
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
                    onPressed: () async {
                      await uploadImageToScreen(
                          source: ImageSource.gallery, context);
                      Navigator.pop(context);
                      await uploadImagetoSupabase();
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

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            label: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      backgroundColor: backgroundColorPage,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 30),
          child: Column(
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
                        ? const GetUserImage()
                        : ClipOval(
                            child: Image.file(
                              imgPath!,
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                    Positioned(
                      bottom: -15,
                      left: 108,
                      child: IconButton(
                        onPressed: () async {
                          await showModel();
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 22,
                          color: btnGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              // Circular Progress Indicator
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(color: btnGreen,),
                ),
              const SizedBox(
                height: 12,
              ),
              const TitleContainerProfile(title: "Info From Firebase Auth"),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email : ${credential!.email}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Created Date : ${DateFormat("MMMM d, y").format(credential!.metadata.creationTime!)}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Last Signed In : ${DateFormat("MMMM d, y").format(credential!.metadata.lastSignInTime!)}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          // Get the current user
                          final user = FirebaseAuth.instance.currentUser;

                          if (user == null) {
                            return;
                          }

                          // Reauthenticate the user
                          await user.delete();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Delete user",
                          style: TextStyle(
                            color: btnPink,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const TitleContainerProfile(
                  title: "Info From Firebase Firestore"),
              GetDataFromFirestore(
                documentId: credential!.uid,
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      users.doc(credential!.uid).delete();
                    });
                  },
                  child: const Text(
                    "Delete data",
                    style: TextStyle(
                      color: btnPink,
                      fontSize: 22,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
