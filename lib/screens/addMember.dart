import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sosal/screens/user.dart';
import 'pageRoute/heroDialogRoute.dart';

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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: 'addFriend',
          child: Material(
            color: Colors.amber,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.userData.code),
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
