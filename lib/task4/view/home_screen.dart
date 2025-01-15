import 'package:daily_tasks/task4/modal/user_modal.dart';
import 'package:daily_tasks/task4/provider/user_provider.dart';
import 'package:daily_tasks/task4/services/firestore_services.dart';
import 'package:daily_tasks/task4/view/auth_gate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var providerFalse = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          IconButton(
            onPressed: () async {
              await providerFalse.signOutUser();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AuthGate(),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirestoreServices.firestoreServices.getUserFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.docs;
            List<UserModal> userData = [];

            for (var i in data) {
              userData.add(
                UserModal.fromMap(i.data()),
              );
            }
            return ListView.builder(
              itemCount: userData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userData[index].profile),
                  ),
                  title: Text((FirebaseAuth.instance.currentUser!.email ==
                          userData[index].email)
                      ? "${userData[index].name} (You)"
                      : userData[index].name),
                  subtitle: Text(userData[index].email),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
