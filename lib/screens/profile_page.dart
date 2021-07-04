import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    String name = user!.displayName.toString();
    final img = user!.photoURL;
    return Container(
      child: Column(
        children: [
          Text(name),
          Image.network(img!),
        ],
      ),
    );
  }
}
