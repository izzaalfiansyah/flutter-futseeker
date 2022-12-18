import 'dart:convert';

import 'package:futseeker/constant.dart';
import 'package:futseeker/models/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<List<User>> get() async {
    var res = await http.get(baseUrl('/user'));
    var data = json.decode(res.body);

    List<User> user = [];

    data.forEach((id, item) {
      user.add(User(
        id,
        item['username'],
        item['password'],
        item['nama'],
        item['telepon'],
        item['alamat'],
        item['isAdmin'],
      ));
    });

    return user;
  }

  static store({
    required username,
    required password,
    required nama,
    required telepon,
    required alamat,
    required isAdmin,
  }) async {
    var req = json.encode({
      'username': username,
      'password': password,
      'nama': nama,
      'telepon': telepon,
      'alamat': alamat,
      'isAdmin': isAdmin,
    });
    var res = await http.post(baseUrl('/user'), body: req);

    if (res.statusCode == 200) {
      return true;
    } else {
      throw "Gagal menambahkan data";
    }
  }

  static update(
    id, {
    required username,
    required password,
    required nama,
    required telepon,
    required alamat,
    required isAdmin,
  }) async {
    var req = json.encode({
      'username': username,
      'password': password,
      'nama': nama,
      'telepon': telepon,
      'alamat': alamat,
      'isAdmin': isAdmin,
    });
    var res = await http.put(baseUrl('/user/$id'), body: req);

    if (res.statusCode == 200) {
      return true;
    } else {
      throw "Gagal mengedit data";
    }
  }

  static destroy(id) async {
    var res = await http.delete(baseUrl('/user/$id'));

    if (res.statusCode == 200) {
      return true;
    } else {
      throw "Gagal menghapus data";
    }
  }
}
