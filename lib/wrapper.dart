import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosal/screens/home.dart';
import 'package:sosal/screens/user.dart';
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
              return Usr();
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
      ),
    );
  }
}

class Usr extends StatelessWidget {
  const Usr({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future<UserData> getUser() async {
      var a = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      String name = a.get('name');
      String code = a.get('code');
      String url = a.get('pic');
      return UserData(name, code, url);
    }

    return FutureBuilder<UserData>(
      future: getUser(),
      builder: (context, AsyncSnapshot<UserData> snap) {
        if (snap.hasData) {
          return Login(userData: snap.data!);
        }
        return Center(
          child: CircularProgressIndicator(
            color: Colors.amber,
          ),
        );
      },
    );
  }
}
