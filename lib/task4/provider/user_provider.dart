import 'package:daily_tasks/task4/modal/user_modal.dart';
import 'package:daily_tasks/task4/services/auth_services.dart';
import 'package:daily_tasks/task4/services/firestore_services.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {

  List usersData = [];

  Future<void> signUpUserUsingEmailAndPassword(
    UserModal user,
    String password,
  ) async {
    await AuthService.authService.signUpUserWithEmailAndPassword(
      user.email,
      password,
    );
    await FirestoreServices.firestoreServices.addUserToFirestore(user);
  }

  Future<void> signOutUser() async {
    await AuthService.authService.logout();
  }

  Future<void> signInUsingEmailAndPassword(
      String email, String password) async {
    await AuthService.authService.signInUserUsingEmailAndPassword(
      email,
      password,
    );
  }

  Future<void> signInWithGoogle() async {
    await AuthService.authService.signInWithGoogle();
  }
}
