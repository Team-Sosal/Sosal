import 'package:flutter/material.dart';
import 'package:sosal/screens/user_chat.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
    );
  }
}
