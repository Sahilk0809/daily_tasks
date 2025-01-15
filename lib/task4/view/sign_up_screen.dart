import 'package:daily_tasks/task4/modal/user_modal.dart';
import 'package:daily_tasks/task4/provider/user_provider.dart';
import 'package:daily_tasks/task4/view/auth_gate.dart';
import 'package:daily_tasks/task4/view/component/custom_textfield.dart';
import 'package:daily_tasks/task4/view/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              hintText: "Name",
              controller: nameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: "Email",
              controller: emailController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: "Password",
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Consumer<UserProvider>(
              builder: (context, provider, child) => ElevatedButton(
                onPressed: () async {
                  UserModal user = UserModal(
                    name: nameController.text,
                    email: emailController.text,
                    profile:
                        "https://static.vecteezy.com/system/resources/thumbnails/028/794/707/small_2x/cartoon-cute-school-boy-photo.jpg",
                  );
                  await provider.signUpUserUsingEmailAndPassword(
                    user,
                    passwordController.text,
                  );

                  if (FirebaseAuth.instance.currentUser != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const AuthGate(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("Failed to create account! Try again later!"),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Navigate to Sign-In
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
                  ),
                );
              },
              child: const Text(
                'Already have an account? Sign In',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
