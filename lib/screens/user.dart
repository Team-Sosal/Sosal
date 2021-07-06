import 'package:flutter/cupertino.dart';

class UserData {
  String name = '', code = '', url = '';
  Image image = Image.asset('default');
  UserData(String nm, String cd, String url) {
    name = nm;
    code = cd;
    image = Image.network(url);
  }
}
