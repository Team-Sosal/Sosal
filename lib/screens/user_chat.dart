import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:sosal/screens/user.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class UserChat extends StatefulWidget {
  final Friend frnd;
  final UserData userData;
  UserChat({Key? key, required this.frnd, required this.userData})
      : super(key: key);

  @override
  _UserChatState createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  List<types.TextMessage> _msg = [];
  void _addMsg(types.PartialText txt) async {
    DocumentReference usr = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userData.uid)
        .collection('friends')
        .doc(widget.frnd.uid);
    DocumentReference frnd = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.frnd.uid)
        .collection('friends')
        .doc(widget.userData.uid);
    Map msg = {'uid': widget.userData.uid, 'txt': txt.text};
    await usr.update({
      'msg': FieldValue.arrayUnion([msg])
    });
    await frnd.update({
      'msg': FieldValue.arrayUnion([msg])
    });
  }

  @override
  Widget build(BuildContext context) {
    foo(DocumentSnapshot x) async {
      List messages = await x.get('msg');
      setState(() {
        _msg = [];
        for (var i in messages) {
          _msg.insert(
              0,
              types.TextMessage(
                  author: i['uid'] == widget.userData.uid
                      ? types.User(
                          id: widget.userData.uid,
                          firstName: widget.userData.name,
                          imageUrl: widget.userData.url)
                      : types.User(
                          id: widget.frnd.uid,
                          firstName: widget.frnd.name,
                          imageUrl: widget.frnd.url),
                  id: i['uid'],
                  text: i['txt']));
        }
      });
    }

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userData.uid)
            .collection('friends')
            .doc(widget.frnd.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            foo(snapshot.data!);
            return Chat(
                showUserAvatars: true,
                showUserNames: true,
                messages: _msg,
                onSendPressed: _addMsg,
                user: types.User(id: widget.userData.uid));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
