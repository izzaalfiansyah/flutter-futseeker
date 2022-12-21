import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:futseeker/models/user.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

var cPrimary = Colors.red;
var shadowBase = [
  BoxShadow(
    color: Colors.black.withOpacity(.2),
    offset: const Offset(0, 2),
    blurRadius: 2,
  ),
];
var shadowSm = [
  BoxShadow(
    color: Colors.black.withOpacity(.2),
    offset: const Offset(0, 1),
    blurRadius: 1,
  )
];

Uri baseUrl(path) {
  return Uri.parse("https://futseeker-default-rtdb.asia-southeast1.firebasedatabase.app$path.json");
}

notif(message, {Color color = Colors.black87}) {
  return Get.showSnackbar(
    GetSnackBar(
      message: message,
      duration: const Duration(milliseconds: 1500),
      backgroundColor: color,
    ),
  );
}

Future<User> authUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getString('auth')!.isEmpty) {
    Get.offAll('login');
    return User('', '', '', '', '', '', false);
  }

  dynamic auth = json.decode(prefs.getString('auth').toString());
  return User.fromJSON(
    id: auth['id'],
    nama: auth['nama'],
    telepon: auth['telepon'],
    alamat: auth['alamat'],
    password: auth['password'],
    username: auth['username'],
    isAdmin: auth['isAdmin'] ?? false,
  );
}

String getDateNow() {
  DateTime now = DateTime.now();
  String tanggal = "${now.year}-${now.month}-${now.day}";
  return tanggal;
}

String formatMoney(int number) {
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  return currencyFormatter.format(number);
}
