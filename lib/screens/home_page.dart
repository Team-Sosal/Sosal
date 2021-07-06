import 'package:flutter/material.dart';
import 'package:sosal/screens/addMember.dart';
import 'package:sosal/screens/user.dart';
import 'package:sosal/screens/user_chat.dart';

class HomePage extends StatelessWidget {
  final UserData userData;
  HomePage({Key? key, required this.userData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AddTodoButton(
        userData: userData,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              "User $index",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text("Message"),
            leading: Icon(
              Icons.account_circle,
              size: 50,
            ),
            trailing: Text("05:17"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserChat(index: index)),
              );
            },
          );
        },
      ),
    );
  }
}
