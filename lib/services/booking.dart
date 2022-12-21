import 'dart:convert';

import 'package:futseeker/constant.dart';
import 'package:futseeker/models/booking.dart';
import 'package:futseeker/models/lapangan.dart';
import 'package:http/http.dart' as http;

class BookingService {
  static Future<List<Booking>> get() async {
    var res = await http.get(baseUrl('/booking'));
    var data = json.decode(res.body);

    List<Booking> booking = [];

    data.forEach((id, item) {
      booking.add(Booking(
        id,
        item['pemesan'],
        Lapangan(
          '',
          item['lapangan']['nama'],
          item['lapangan']['harga'],
        ),
        item['lamaJam'],
        item['tanggal'],
        item['jam'],
        item['status'],
      ));
    });

    return booking;
  }

  static store({
    required pemesan,
    required lapangan,
    required status,
    required tanggal,
    required jam,
    required lamaJam,
  }) async {
    var req = json.encode({
      'pemesan': pemesan,
      'lapangan': lapangan,
      'status': status,
      'tanggal': tanggal,
      'jam': jam,
      'lamaJam': lamaJam,
    });
    var res = await http.post(baseUrl('/booking'), body: req);

    if (res.statusCode == 200) {
      return true;
    } else {
      throw "Gagal menambahkan data";
    }
  }

  static update(
    id, {
    required pemesan,
    required lapangan,
    required status,
    required tanggal,
    required jam,
    required lamaJam,
  }) async {
    var req = json.encode({
      'pemesan': pemesan,
      'lapangan': lapangan,
      'status': status,
      'tanggal': tanggal,
      'jam': jam,
      'lamaJam': lamaJam,
    });
    var res = await http.put(baseUrl('/booking/$id'), body: req);

    if (res.statusCode == 200) {
      return true;
    } else {
      throw "Gagal mengedit data";
    }
  }

  static destroy(id) async {
    var res = await http.delete(baseUrl('/booking/$id'));

    if (res.statusCode == 200) {
      return true;
    } else {
      throw "Gagal menghapus data";
    }
  }
}
