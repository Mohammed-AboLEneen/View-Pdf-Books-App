import 'package:google_sign_in/google_sign_in.dart';

Future<void> googleSignOut() async {
  await GoogleSignIn().signOut();
}
