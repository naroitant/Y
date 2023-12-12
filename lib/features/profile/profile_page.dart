import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:y/features/profile/widgets/text_box.dart';
import 'package:y/features/profile/widgets/text_box_editable.dart';
import 'package:y/features/widgets/display_error_message.dart';

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
  String imageUrl = '';

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    context.go('/auth');
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
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Edit $field',
          style: const TextStyle(color: Colors.white),
        ),
        content: TextFormField(
          initialValue: text,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter new $field',
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            text = value;
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
            onPressed: () => Navigator.of(context).pop(text),
          ),
        ]
      ),
    );

    // Update user data in Cloud Firestore.
    if (text.trim().isNotEmpty) {
      // Only update if there is something in the text field.
      await usersCollection.doc(currentUser.email).update({field: text});
    }
  }

  Future<void> editPicture(String url) async {
    // Update user data in Cloud Firestore.
    if (url.trim().isNotEmpty) {
      // Only update if there is something in the text field.
      await usersCollection.doc(currentUser.email).update({'imageURL': url});
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
            color: Colors.black,
          ),
        ],
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

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black.withOpacity(0.6), width: 2),
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

                      if (file == null) return;
                      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

                      // Get a reference to the storage root.
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages = referenceRoot.child('profile_pictures');

                      // Create a reference for the image which is to be uploaded.
                      Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

                      try {
                        // Store the file.
                        await referenceImageToUpload.putFile(File(file.path));
                        // Get the download URL on success.
                        imageUrl = await referenceImageToUpload.getDownloadURL();
                      } catch (error) {
                        if (imageUrl.isEmpty) {
                          displayErrorMessage('Please select an image.', context);
                        }
                      }
                    },
                    icon: Image.network(imageUrl, height: 150),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  userData['username'],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    editPicture(imageUrl);
                  },
                  child: const Text("Submit")
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
