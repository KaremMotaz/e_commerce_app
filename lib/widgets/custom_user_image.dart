import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetUserImage extends StatefulWidget {

  const GetUserImage({super.key});

  @override
  State<GetUserImage> createState() => _GetUserImageState();
}

class _GetUserImageState extends State<GetUserImage> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
      final credential = FirebaseAuth.instance.currentUser;


    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(credential?.uid).get(),
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
          return CircleAvatar(
            radius: 70,
            backgroundImage: NetworkImage(data['imgLink']),
          );
        }
        return const Text("loading");
      },
    );
  }
}
