import 'package:daily_tasks/task3/helper/database_helper.dart';
import 'package:daily_tasks/task3/helper/users_api_helper.dart';
import 'package:daily_tasks/task3/modal/users_modal.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UsersProvider with ChangeNotifier {
  var apiHelper = UsersApiHelper();
  List<UsersModal> usersModal = [];
  List databaseData = [];

  Future<List<UsersModal>> fetchData() async {
    List data = await apiHelper.fetchApiData();
    usersModal = data.map((e) => UsersModal.fromJson(e)).toList();
    for (int i = 0; i < usersModal.length; i++) {
      UsersModal userModal = usersModal[i];
      bool exists = await DatabaseHelper.databaseHelper.userExits(userModal.id);

      if (exists) {
        DatabaseUsers databaseUsers = DatabaseUsers.fromMap({
          'id': userModal.id,
          'name': userModal.name,
          'role': userModal.role.name,
          'email': userModal.email,
          'avatar': userModal.avatar,
          'creationAt':
              "${userModal.creationAt.day}/${userModal.creationAt.month}/${userModal.creationAt.year}  ${userModal.creationAt.hour}:${userModal.creationAt.minute}:${userModal.creationAt.second}",
          'updatedAt':
              "${userModal.updatedAt.day}/${userModal.updatedAt.month}/${userModal.updatedAt.year}  ${userModal.updatedAt.hour}:${userModal.updatedAt.minute}:${userModal.creationAt.second}",
        });
        await DatabaseHelper.databaseHelper.updateData(databaseUsers);
      } else {
        await DatabaseHelper.databaseHelper.insertUser(userModal);
      }
    }
    return usersModal;
  }

  Future<void> initDb() async {
    await DatabaseHelper.databaseHelper.initDatabase();
  }

  Future<void> addDataInDb(UsersModal user) async {
    await DatabaseHelper.databaseHelper.insertUser(user);
    notifyListeners();
  }

  Future<List<Map<String, Object?>>> readDataFromDb() async {
    return databaseData = await DatabaseHelper.databaseHelper.getUsers();
  }

  Future<void> updateDbData(DatabaseUsers user) async {
    await DatabaseHelper.databaseHelper.updateData(user);
    notifyListeners();
  }

  Future<void> deleteDataInDb(int id) async {
    await DatabaseHelper.databaseHelper.deleteUser(id);
    readDataFromDb();
    notifyListeners();
  }

  Future<void> deleteAllDataInDb() async {
    await DatabaseHelper.databaseHelper.deleteAllUsers();
    notifyListeners();
  }

  UsersProvider() {
    fetchData();
    initDb();
  }
}
