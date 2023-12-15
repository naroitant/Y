import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
    // Begin the interactive sign-in process.
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the authentication details from the user.
    final GoogleSignInAuthentication? googleAuth =
        await googleUser!.authentication;

    // Create a new credential for the user.
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Sign in.
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
