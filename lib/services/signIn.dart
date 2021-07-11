import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool _isSigningIn = false;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future login() async {
    isSigningIn = true;
    try {
      final user = await googleSignIn.signIn();

      if (user == null) {
        isSigningIn = false;
        return user;
      } else {
        final googleAuth = await user.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential firebaseUser =
            await FirebaseAuth.instance.signInWithCredential(credential);

        DocumentSnapshot docs = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.user!.uid)
            .get();

        if (!docs.exists) {
          String code;
          QuerySnapshot<Map<String, dynamic>> qSnap;
          do {
            code = getCode();
            qSnap = await FirebaseFirestore.instance
                .collection('users')
                .where('code', isEqualTo: code)
                .get();
          } while (qSnap.size != 0);

          FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser.user!.uid)
              .set({
            'name': firebaseUser.user!.displayName,
            'pic': firebaseUser.user!.photoURL,
            'code': code,
            'receive': [],
            'sent': []
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
    isSigningIn = false;
    notifyListeners();
  }

  String getCode() {
    String alpha = 'QWERTYUIOPLKJHGFDSAZXCVBNM';
    String nums = '0987654321';
    String code = '';
    int index;
    for (int i = 0; i < 5; i++) {
      index = Random().nextInt(2);
      code += index == 0
          ? alpha[Random().nextInt(alpha.length)]
          : nums[Random().nextInt(nums.length)];
    }
    return code;
  }

  void logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
