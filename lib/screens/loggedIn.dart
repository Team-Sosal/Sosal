import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sosal/screens/home_page.dart';
import 'package:sosal/screens/profile_page.dart';
import 'package:sosal/screens/search_page.dart';
import 'package:sosal/screens/user.dart';
import '../services/signIn.dart';

class Login extends StatefulWidget {
  final UserData userData;
  Login({Key? key, required this.userData}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final user = FirebaseAuth.instance.currentUser;
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOSAL'),
        actions: [
          TextButton(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      bottomNavigationBar: buildBottomNav(),
      body: _currentIndex == 0
          ? HomePage(
              userData: widget.userData,
            )
          : _currentIndex == 1
              ? Search()
              : Profile(
                  userData: widget.userData,
                ),
    );
  }

  BottomNavigationBar buildBottomNav() {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
              backgroundColor: Colors.green)
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        });
  }
}
