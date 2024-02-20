import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<OAuthCredential> googleAuth() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn(
    scopes: [
      'email',
    ],
  ).signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  OAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Create a new credential
  return credential;
}
