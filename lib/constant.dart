import 'package:flutter/material.dart';
import 'package:get/get.dart';

var cPrimary = Colors.red;
var shadowBase = [
  BoxShadow(
    color: Colors.black.withOpacity(.2),
    offset: const Offset(0, 2),
    blurRadius: 4,
  ),
];

Uri baseUrl(path) {
  return Uri.parse("https://futseeker-default-rtdb.asia-southeast1.firebasedatabase.app$path.json");
}

notif(message) {
  return Get.showSnackbar(
    GetSnackBar(
      message: message,
      duration: const Duration(seconds: 3),
    ),
  );
}
