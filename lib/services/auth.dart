import 'package:firebase_auth/firebase_auth.dart';
import 'package:overlay_support/overlay_support.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign in email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
  //sign in google

  //sign in microsoft

  //register with email & password
  Future createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        toast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        toast('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
    }
  }
  
  //send reset email
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
  
  //sign out
  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('you have been signed out');
    } catch (e) {
      print(e.toString());
    }
  }
}
