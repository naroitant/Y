import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:y/features/profile/widgets/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users');

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // Edit field.
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
          // Cancel button.
          TextButton(
            child:
              const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            onPressed: () => Navigator.pop(context),
          ),
          // Save button.
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

    // Update in Firestore.
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
            icon: const Icon(Icons.logout)
          ),
        ],
        title: const Text(
          'Your Profile',
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

                // Profile picture.
                const Icon(
                  Icons.person,
                  size: 72,
                ),

                const SizedBox(height: 50),

                // User email.
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(height: 50),

                // Profile details.
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                // User name.
                MyTextBox(
                  sectionName: 'username',
                  text: userData['username'],
                  onPressed: () => editField('username', userData['username']),
                ),

                // User bio.
                MyTextBox(
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
