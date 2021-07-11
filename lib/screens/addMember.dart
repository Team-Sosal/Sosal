import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sosal/screens/user.dart';
import 'pageRoute/heroDialogRoute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTodoButton extends StatefulWidget {
  final UserData userData;
  AddTodoButton({required this.userData});
  @override
  _AddTodoButtonState createState() => _AddTodoButtonState();
}

class _AddTodoButtonState extends State<AddTodoButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return _AddTodoPopupCard(
              userData: widget.userData,
            );
          }));
        },
        child: Hero(
          tag: 'addFriend',
          child: Material(
            color: Colors.amber,
            elevation: 2,
            shape: CircleBorder(side: BorderSide.none),
            child: const Icon(
              Icons.add_rounded,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddTodoPopupCard extends StatefulWidget {
  final UserData userData;
  _AddTodoPopupCard({required this.userData});
  @override
  __AddTodoPopupCardState createState() => __AddTodoPopupCardState();
}

class __AddTodoPopupCardState extends State<_AddTodoPopupCard> {
  String sentMsg = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    String enteredCode = '';
    TextEditingController tec = TextEditingController();

    Future<bool> isFriend(RequestedData x) async {
      DocumentSnapshot y = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userData.uid)
          .collection('friends')
          .doc(x.uid)
          .get();
      return y.exists;
    }

    sendingReq() async {
      var check = await FirebaseFirestore.instance
          .collection('users')
          .where('code', isEqualTo: enteredCode)
          .get();
      if (check.size == 1) {
        var sender = FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userData.uid);
//        DocumentSnapshot senderData = await sender.get();
        var receiver = FirebaseFirestore.instance
            .collection('users')
            .doc(check.docs.first.id);
        DocumentSnapshot recevierData = await receiver.get();
//        List senderSentList = await senderData.get('sent');
        List receiverReceivedList = await recevierData.get('receive');
        String recevierName = await recevierData.get('name');
        String receivedUrl = await recevierData.get('pic');
        String receiverUid = recevierData.id;
        bool isFound = receiverReceivedList
            .any((element) => element['uid'] == receiverUid);
        if (await isFriend(RequestedData(
            name: recevierName, uid: receiverUid, url: receivedUrl))) {
          setState(() {
            tec.clear();
            enteredCode = '';
            sentMsg = 'Are you kidding me!!, both are friends';
            _isLoading = false;
          });
        } else if (isFound == false) {
          Map y = {
            'name': recevierName,
            'uid': receiverUid,
            'url': receivedUrl
          };
          Map x = {
            'name': widget.userData.name,
            'uid': widget.userData.uid,
            'url': widget.userData.url
          };
          await receiver.update({
            'receive': FieldValue.arrayUnion([x])
          });
          await sender.update({
            'sent': FieldValue.arrayUnion([y])
          });
          setState(() {
            tec.clear();
            enteredCode = '';
            sentMsg = 'REQUEST SENT TO ' + recevierName;
            _isLoading = false;
          });
        } else {
          setState(() {
            tec.clear();
            enteredCode = '';
            sentMsg = 'Already sent!!!, please wait';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          tec.clear();
          enteredCode = '';
          sentMsg = 'NOT FOUND';
          _isLoading = false;
        });
      }
    }

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Hero(
                tag: 'addFriend',
                child: Material(
                  color: Colors.blueGrey,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(widget.userData.code),
                          EditableText(
                            controller: tec,
                            focusNode: FocusNode(),
                            style: TextStyle(color: Colors.black),
                            cursorColor: Colors.redAccent,
                            backgroundCursorColor: Colors.grey,
                            onChanged: (text) {
                              enteredCode = text;
                            },
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (widget.userData.code == enteredCode) {
                                  setState(() {
                                    tec.clear();
                                    enteredCode = '';
                                    sentMsg =
                                        'Why alone \nshare it with your friends and start texting :)';
                                  });
                                } else {
                                  setState(() {
                                    _isLoading = true;
                                    sendingReq();
                                  });
                                }
                              },
                              child: Text('Add as Friend')),
                          Text(
                            sentMsg,
                            style: TextStyle(
                                color: sentMsg == 'NOT FOUND'
                                    ? Colors.red
                                    : Colors.green),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
