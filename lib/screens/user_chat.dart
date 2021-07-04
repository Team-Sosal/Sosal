import 'package:flutter/material.dart';

class UserChat extends StatelessWidget {
  final int index;

  const UserChat({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("User $index chat"),
      ),
    );
  }
}
