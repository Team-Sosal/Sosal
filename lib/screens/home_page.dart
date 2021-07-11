import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sosal/screens/addMember.dart';
import 'package:sosal/screens/user.dart';
import 'package:sosal/screens/user_chat.dart';

class HomePage extends StatefulWidget {
  final UserData userData;
  HomePage({Key? key, required this.userData}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Friend> _friends = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: AddTodoButton(
          userData: widget.userData,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userData.uid)
              .collection('friends')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
            if (snap.hasData) {
              _friends = [];
              for (var i in snap.data!.docs) {
                _friends.add(
                    Friend(name: i.get('name'), url: i.get('url'), uid: i.id));
              }
              return _friends.length == 0
                  ? Center(
                      child: Text('Share and chat'),
                    )
                  : ListView.builder(
                      itemCount: _friends.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            _friends[index].name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text("Message"),
                          leading: CircleAvatar(
                            child: Image.network(_friends[index].url),
                          ),
                          trailing: Text("05:17"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserChat(
                                        frnd: _friends[index],
                                        userData: widget.userData,
                                      )),
                            );
                          },
                        );
                      },
                    );
            }
            return Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            );
          },
        ));
  }
}
