import 'package:daily_tasks/task4/modal/user_modal.dart';
import 'package:daily_tasks/task4/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();

  static AuthService authService = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> signUpUserWithEmailAndPassword(
      String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInUserUsingEmailAndPassword(
      String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(authCredential);

        if (userCredential.user != null) {
          UserModal user = UserModal(
            name: userCredential.user!.displayName!,
            email: userCredential.user!.email!,
            profile: userCredential.user!.photoURL!,
          );
          print(
              "--------------------------------------------$user---------------------------------");
          await FirestoreServices.firestoreServices.addUserToFirestore(user);
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("-------------------------$e----------------------");
    } catch (e) {
      debugPrint("----------------------$e---------------------");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
