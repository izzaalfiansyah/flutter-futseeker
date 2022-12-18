import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      duration: const Duration(seconds: 3),
      backgroundColor: color,
    ),
  );
}
