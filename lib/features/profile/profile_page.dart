import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:y/features/profile/widgets/text_box.dart';
import 'package:y/features/profile/widgets/text_box_editable.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'profile_pictures/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
  }

  Future<void> editField(String field, String text) async {
    String newValue = text;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Edit $field',
          style: const TextStyle(color: Colors.white),
        ),
        content: TextFormField(
          initialValue: newValue,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter new $field',
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            child:
              const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child:
              const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ]
      ),
    );

    // Update user data in Cloud Firestore.
    if (newValue.trim().isNotEmpty) {
      // Only update if there is something in the text field.
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
        title: const Text(
          'Profile Info',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 50),

                IconButton(
                  onPressed: signUserOut,
                  icon: const Icon(Icons.person),
                  color: Colors.white,
                  iconSize: 144,
                ),

                const SizedBox(height: 50),

                TextBox(
                  sectionName: 'email',
                  text: currentUser.email!,
                  onPressed: () => editField('email', userData['email']),
                ),

                TextBoxEditable(
                  sectionName: 'username',
                  text: userData['username'],
                  onPressed: () => editField('username', userData['username']),
                ),

                TextBoxEditable(
                  sectionName: 'bio',
                  text: userData['bio'],
                  onPressed: () => editField('bio', userData['bio']),
                ),
              ]
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      )
    );
  }
}
