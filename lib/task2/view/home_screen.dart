import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../modal/user_modal.dart';
import 'detail_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = [];
  User? currentUser;

  @override
  void initState() {
    super.initState();
    loadAllUsers();
  }

  Future<void> loadAllUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentUserData = prefs.getString('userData');
    List<String>? savedUsersData = prefs.getStringList('allUsers');

    if (savedUsersData != null) {
      setState(() {
        users = savedUsersData
            .map((userJson) => User.fromJson(jsonDecode(userJson)))
            .toList();
      });
    }

    if (currentUserData != null) {
      setState(() {
        currentUser = User.fromJson(jsonDecode(currentUserData));
        if (!users.any((user) => user.id == currentUser!.id)) {
          users.add(currentUser!);
          saveAllUsers();
        }
      });
    }
  }

  Future<void> saveAllUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> userJsonList =
        users.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList('allUsers', userJsonList);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        leading: const Icon(Icons.account_circle_sharp),
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                User user = users[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user.image),
                    ),
                    title: Text(
                      "${user.firstName} ${user.lastName}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      user.email,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailScreen(user: user),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
