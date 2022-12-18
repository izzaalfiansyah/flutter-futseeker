import 'dart:convert';

import 'package:futseeker/constant.dart';
import 'package:futseeker/models/lapangan.dart';
import 'package:http/http.dart' as http;

class LapanganService {
  static Future<List<Lapangan>> get() async {
    var res = await http.get(baseUrl('/lapangan'));
    var data = json.decode(res.body);

    List<Lapangan> lapangan = [];

    data.forEach((id, item) {
      lapangan.add(Lapangan(id, item['nama'], item['harga']));
    });

    return lapangan;
  }

  static store({required nama, required harga}) async {
    var req = json.encode({'nama': nama, 'harga': harga});
    var res = await http.post(baseUrl('/lapangan'), body: req);

    if (res.statusCode == 200) {
      return true;
    } else {
      throw "Gagal menambahkan data";
    }
  }

  static update(id, {required nama, required harga}) async {
    var req = json.encode({'nama': nama, 'harga': harga});
    var res = await http.patch(baseUrl('/lapangan/$id'), body: req);

    if (res.statusCode == 200) {
      return true;
    } else {
      throw "Gagal mengedit data";
    }
  }

  static destroy(id) async {
    var res = await http.delete(baseUrl('/lapangan/$id'));

    if (res.statusCode == 200) {
      return true;
    } else {
      throw "Gagal menghapus data";
    }
  }
}
