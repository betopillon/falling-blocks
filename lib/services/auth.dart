import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      return user;
    } catch (e) {
      // TODO: Implement proper error logging/handling
      return null;
    }
  }

  //sign in with email & pass

  //register with email & pass

  //sign out
}
