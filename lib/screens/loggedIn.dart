import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sosal/screens/home_page.dart';
import 'package:sosal/screens/profile_page.dart';
import 'package:sosal/screens/search_page.dart';
import 'package:sosal/screens/user.dart';
import '../services/signIn.dart';
import 'notifications.dart';

class Login extends StatefulWidget {
  final UserData userData;
  Login({Key? key, required this.userData}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final user = FirebaseAuth.instance.currentUser;
  int _currentIndex = 0;
  int _reqCount = 0;
  List<RequestedData> _reqData = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userData.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            List documents = snapshot.data!.get('receive');
            _reqCount = documents.length;
            _reqData = [];
            for (var i in documents) {
              _reqData.add(
                  RequestedData(name: i['name'], uid: i['uid'], url: i['url']));
            }
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('SOSAL'),
              actions: [
                Stack(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Notifications(
                                      userData: widget.userData,
                                      req: _reqData,
                                    )));
                      },
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: _reqCount != 0
                          ? Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 10,
                                minHeight: 10,
                              ),
                              child: Text(
                                '$_reqCount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Container(),
                    )
                  ],
                ),
                TextButton(
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
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
        });
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
