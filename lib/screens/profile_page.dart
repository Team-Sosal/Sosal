import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sosal/screens/user.dart';

class Profile extends StatefulWidget {
  final UserData userData;
  Profile({Key? key, required this.userData}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    String name = widget.userData.name;
    return Container(
      child: Column(
        children: [
          Text(name),
          widget.userData.image,
        ],
      ),
    );
  }
}
