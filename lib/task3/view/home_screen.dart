import 'package:daily_tasks/task3/view/component/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';

import '../modal/users_modal.dart';
import '../provider/users_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _toastShownOnline = false; // Flag for online toast
  bool _toastShownOffline = false; // Flag for offline toast

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context);
    final userProviderFalse =
        Provider.of<UsersProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        title: const Text(
          'User Manager',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.contains(ConnectivityResult.mobile) ||
              snapshot.data!.contains(ConnectivityResult.wifi)) {
            if (!_toastShownOnline) {
              Fluttertoast.showToast(
                msg: "Data has been restored in database",
                backgroundColor: Colors.green,
              );
              _toastShownOnline = true;
              _toastShownOffline = false; // Reset offline flag
            }
            return FutureBuilder(
              future: userProvider.fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: userProvider.usersModal.length,
                    itemBuilder: (context, index) {
                      UsersModal users = userProvider.usersModal[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(users.avatar),
                          ),
                          title: Text(
                            users.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                users.email,
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "Role: ${users.role.name}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "Created: ${users.creationAt}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                "Updated: ${users.updatedAt}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          } else {
            if (!_toastShownOffline) {
              Fluttertoast.showToast(
                msg: "You're currently offline! Showing offline data!",
                backgroundColor: Colors.red,
              );
              _toastShownOffline = true;
              _toastShownOnline = false; // Reset online flag
            }
            return FutureBuilder(
              future: userProvider.readDataFromDb(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else if (snapshot.hasData) {
                  List<DatabaseUsers> usersModal = userProvider.databaseData
                      .map((e) => DatabaseUsers.fromMap(e))
                      .toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: usersModal.length,
                    itemBuilder: (context, index) {
                      DatabaseUsers users = usersModal[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(users.avatar),
                          ),
                          title: Text(
                            users.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                users.email,
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "Role: ${users.role}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "Created: ${users.creationAt}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                "Updated: ${users.updatedAt}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  var txtName = TextEditingController();
                                  var txtEmail = TextEditingController();
                                  var txtRole = TextEditingController();
                                  DateTime updatedDate = DateTime.now();
                                  txtName.text = users.name;
                                  txtEmail.text = users.email;
                                  txtRole.text = users.role;
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Update data'),
                                      actions: [
                                        CustomTextField(
                                          hintText: "Name",
                                          controller: txtName,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        CustomTextField(
                                          hintText: "Email",
                                          controller: txtEmail,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        CustomTextField(
                                          hintText: "Role",
                                          controller: txtRole,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Consumer<UsersProvider>(
                                              builder:
                                                  (context, value, child) =>
                                                      TextButton(
                                                onPressed: () async {
                                                  users.email = txtEmail.text;
                                                  users.name = txtName.text;
                                                  users.role = txtRole.text;
                                                  users.updatedAt =
                                                      "${updatedDate.day}/${updatedDate.month}/${updatedDate.year}  ${updatedDate.hour}:${updatedDate.minute}:${updatedDate.second}";
                                                  await value
                                                      .updateDbData(users);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'OK',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await userProviderFalse
                                      .deleteDataInDb(users.id);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
