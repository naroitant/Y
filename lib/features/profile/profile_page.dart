import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:y/features/profile/widgets/text_box_editable.dart';
import 'package:y/features/profile/widgets/text_box.dart';
import 'package:y/features/profile/widgets/upload_data.dart';
import 'package:y/features/profile/widgets/username_text_box.dart';
import 'package:y/features/profile/widgets/pick_image.dart';
import 'package:y/features/widgets/display_error_message.dart';
import 'package:y/features/widgets/display_loading_circle.dart';
import 'package:y/features/widgets/display_snack_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users');

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final alphabetic = RegExp(r'^[a-zA-Z]+$');
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    // Redirect to the login page.
    context.go('/auth');
  }

  void saveProfileWithPicture() async {
    String username = usernameController.text;
    String bio = bioController.text;

    displayLoadingCircle(context);

    if (username.trim().isNotEmpty) {
      // Check if the username contains alphabetic symbols only.
      if (alphabetic.hasMatch(usernameController.text)) {
        await StoreData().saveData(
          username: username,
          bio: bio,
          file: _image!,
        );

        // Pop the loading circle.
        Navigator.of(context, rootNavigator: true).pop(context);

        displaySnackBar(
          AppLocalizations.of(context)!.yourChangesHaveBeenSaved,
          context,
        );
      } else {
        // Pop the loading circle.
        Navigator.of(context, rootNavigator: true).pop(context);

        displayErrorMessage(
          AppLocalizations.of(context)!.usernameMustIncludeAlphabeticSymbolsOnly,
          context,
        );
      }
    } else {
      // Pop the loading circle.
      Navigator.of(context, rootNavigator: true).pop(context);

      displayErrorMessage(
        AppLocalizations.of(context)!.usernameIsNotFilled,
        context,
      );
    }

    // Pop the loading circle.
    Navigator.of(context, rootNavigator: true).pop(context);

    displaySnackBar(
      AppLocalizations.of(context)!.yourChangesHaveBeenSaved,
      context,
    );
  }

  Future saveProfile() async {
    String username = usernameController.text;
    String bio = bioController.text;

    displayLoadingCircle(context);

    // Only update if there is something in the username field.
    if (username.trim().isNotEmpty) {
      // Check if the username contains alphabetic symbols only.
      if (alphabetic.hasMatch(usernameController.text)) {
        await usersCollection.doc(currentUser.email).update({
          'username' : username,
          'bio' : bio,
        });
        // Pop the loading circle.
        Navigator.of(context, rootNavigator: true).pop(context);

        displaySnackBar(
          AppLocalizations.of(context)!.yourChangesHaveBeenSaved,
          context,
        );
      } else {
        // Pop the loading circle.
        Navigator.of(context, rootNavigator: true).pop(context);

        displayErrorMessage(
          AppLocalizations.of(context)!.usernameMustIncludeAlphabeticSymbolsOnly,
          context,
        );
      }
    } else {
      // Pop the loading circle.
      Navigator.of(context, rootNavigator: true).pop(context);

      displayErrorMessage(
        AppLocalizations.of(context)!.usernameIsNotFilled,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            usernameController.text = userData['username'];
            emailController.text = currentUser.email!;
            bioController.text = userData['bio'];
              return Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 36),
                    
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.6),
                                  width: 1.5,
                                ),
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: _image != null
                                  ? CircleAvatar(
                                radius: 80,
                                backgroundImage: MemoryImage(_image!),
                              )
                                  : CircleAvatar(
                                radius: 80,
                                backgroundImage: NetworkImage(userData['imageUrl']),
                              ),
                            ),
                            Positioned(
                              bottom: -5,
                              left: 95,
                              child: MaterialButton(
                                onPressed: selectImage,
                                color: Colors.white,
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(5),
                                shape: const CircleBorder(),
                                child: const Icon(
                                  Icons.add_a_photo,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ]
                        ),
                    
                        UsernameTextBox(controller: usernameController),
                    
                        const SizedBox(height: 12),
                    
                        Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                    
                        const SizedBox(height: 12),
                    
                        TextBox(
                          controller: emailController,
                          sectionName: AppLocalizations.of(context)!.email,
                        ),
                    
                        const SizedBox(height: 8),
                    
                        TextBoxEditable(
                          controller: bioController,
                          sectionName: AppLocalizations.of(context)!.bio,
                        ),
                    
                        const SizedBox(height: 16),
                    
                        Container(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: _image != null
                              ? saveProfileWithPicture
                              : saveProfile,
                            child: Text(
                              AppLocalizations.of(context)!.save,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${AppLocalizations.of(context)!.error} ${snapshot.error}'),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    );
  }
}
