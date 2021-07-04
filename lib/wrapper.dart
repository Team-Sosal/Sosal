import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosal/screens/home.dart';
import 'services/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/loggedIn.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final provider = Provider.of<GoogleSignInProvider>(context);
          if (snapshot.hasData) {
            return Login();
          } else if (provider.isSigningIn) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            );
          } else {
            return Homepage();
          }
        },
      ),
    ),);
  }
}
