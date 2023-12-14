import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final currentUser = FirebaseAuth.instance.currentUser!;
final usersCollection = FirebaseFirestore.instance.collection('Users');

class StoreData {
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference ref = FirebaseStorage.instance.ref().child(childName).child(uniqueFileName);

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<void> saveData({
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    if (username.isNotEmpty && file.isNotEmpty) {
      String imageUrl = await uploadImageToStorage('profile_pictures', file);

      await usersCollection.doc(currentUser.email).update({
        'username' : username,
        'bio' : bio,
        'imageUrl' : imageUrl,
      });
    }
  }
}
