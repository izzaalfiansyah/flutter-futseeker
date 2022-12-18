import 'dart:convert';

import 'package:futseeker/constant.dart';
import 'package:futseeker/models/user.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<User> login({required username, required password}) async {
    var data = await http.get(baseUrl('/user'));
    var res = json.decode(data.body);

    List<User> filteredUser = [];

    res.forEach((id, item) {
      if (item['username'] == username) {
        filteredUser.add(User(
          id,
          item['username'],
          item['password'],
          item['nama'],
          item['telepon'],
          item['isAdmin'],
        ));
      }
    });

    if (filteredUser.isEmpty) {
      return throw "username tidak ditemukan";
    } else {
      for (var item in filteredUser) {
        if (item.password == password) {
          return item;
        }
      }

      return throw "password salah";
    }
  }
}
