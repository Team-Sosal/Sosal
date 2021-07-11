import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sosal/screens/user.dart';

class Notifications extends StatefulWidget {
  final UserData userData;
  final List<RequestedData> req;
  Notifications({Key? key, required this.userData, required this.req})
      : super(key: key);
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    delReq(RequestedData x) async {
      DocumentReference curr = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userData.uid);
      Map y = {'name': x.name, 'uid': x.uid, 'url': x.url};
      await curr.update({
        'receive': FieldValue.arrayRemove([y])
      });
      DocumentReference frnd =
          FirebaseFirestore.instance.collection('users').doc(x.uid);
      Map z = {
        'name': widget.userData.name,
        'uid': widget.userData.uid,
        'url': widget.userData.url
      };
      await frnd.update({
        'sent': FieldValue.arrayRemove([z])
      });
    }

    onAccept(RequestedData x) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userData.uid)
          .collection('friends')
          .doc(x.uid)
          .set({
        'name': x.name,
        'url': x.url,
        'msg': [],
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(x.uid)
          .collection('friends')
          .doc(widget.userData.uid)
          .set({
        'name': widget.userData.name,
        'url': widget.userData.url,
        'msg': []
      });
      await delReq(x);
    }

    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: widget.req.length,
        itemBuilder: (_, index) {
          return ListTile(
            leading: TextButton(
                onPressed: () async {
                  await onAccept(widget.req[index]);
                  setState(() {
                    widget.req.remove(widget.req[index]);
                  });
                },
                child: Text(
                  'Accpet',
                  style: TextStyle(color: Colors.green),
                )),
            title: Text(widget.req[index].name),
            trailing: TextButton(
                onPressed: () async {
                  await delReq(widget.req[index]);
                  setState(() {
                    widget.req.remove(widget.req[index]);
                  });
                },
                child: Text(
                  'reject',
                  style: TextStyle(color: Colors.red),
                )),
          );
        },
      ),
    );
  }
}
