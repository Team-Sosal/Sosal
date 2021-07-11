import 'package:flutter/cupertino.dart';

class UserData {
  String name = '', code = '', url = '', uid = '';
  Image image = Image.asset('default');

  UserData(String nm, String cd, String ul, String ui) {
    name = nm;
    code = cd;
    url = ul;
    image = Image.network(url);
    uid = ui;
  }
}

class RequestedData {
  String name, uid, url;
  RequestedData({required this.name, required this.uid, required this.url});
}

class Friend {
  String name, url, uid;
  Friend({required this.name, required this.url, required this.uid});
}
