import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/constants/custom_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditInfoFromFirebase extends StatefulWidget {
  const EditInfoFromFirebase({
    super.key,
    required this.data,
    required this.text,
    required this.keyInfo,
    required this.controller,
  });
  final Map data;
  final String text;
  final String keyInfo;
  final TextEditingController controller;
  @override
  State<EditInfoFromFirebase> createState() => _EditInfoFromFirebaseState();
}

class _EditInfoFromFirebaseState extends State<EditInfoFromFirebase> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final credential = FirebaseAuth.instance.currentUser;

    const int maxCharacters = 16;
    String email = widget.data[widget.keyInfo];
    String displayedEmail =
        email.length > maxCharacters ? '${email.substring(0, maxCharacters)}...' : email;
        
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${widget.text} : $displayedEmail",
          style: const TextStyle(
            fontSize: 20,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                users
                    .doc(credential!.uid)
                    .update({widget.keyInfo: FieldValue.delete()});
                setState(() {
                  widget.data[widget.keyInfo] = null;
                });
              },
              icon: const Icon(
                Icons.delete,
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(22),
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              controller: widget.controller,
                              maxLength: 30,
                              decoration: InputDecoration(
                                hintText: "${widget.data[widget.keyInfo]}",
                                hintStyle: const TextStyle(color: Colors.grey),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: btnGreen)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: btnGreen)),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    users.doc(credential!.uid).update({
                                      widget.keyInfo: widget.controller.text
                                    });
                                    setState(() {
                                      widget.data[widget.keyInfo] =
                                          widget.controller.text;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(
                                        fontSize: 22, color: btnGreen),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.red[700]),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.edit,
                color: btnGreen,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
