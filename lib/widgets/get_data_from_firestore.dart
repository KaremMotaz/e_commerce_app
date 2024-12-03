import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/widgets/edit_info_from_firebase.dart';
import 'package:flutter/material.dart';

class GetDataFromFirestore extends StatefulWidget {
  final String documentId;

  const GetDataFromFirestore({super.key, required this.documentId});

  @override
  State<GetDataFromFirestore> createState() => _GetDataFromFirestoreState();
}

class _GetDataFromFirestoreState extends State<GetDataFromFirestore> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  final ageController = TextEditingController();
  final jobTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditInfoFromFirebase(
                data: data,
                text: "Email",
                keyInfo: "Email",
                controller: emailController,
              ),
              EditInfoFromFirebase(
                data: data,
                text: "Password",
                keyInfo: "Password",
                controller: passwordController,
              ),
              EditInfoFromFirebase(
                data: data,
                text: "User Name",
                keyInfo: "UserName",
                controller: userNameController,
              ),
              EditInfoFromFirebase(
                data: data,
                text: "Age",
                keyInfo: "Age",
                controller: ageController,
              ),
              EditInfoFromFirebase(
                data: data,
                text: "Jop Title",
                keyInfo: "JopTitle",
                controller: jobTitleController,
              ),
            ],
          );
        }
        return const Text("loading");
      },
    );
  }
}
