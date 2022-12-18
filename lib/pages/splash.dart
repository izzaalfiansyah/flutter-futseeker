// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:futseeker/constant.dart';
import 'package:futseeker/pages/home.dart';
import 'package:futseeker/pages/login.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    check();
  }

  check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('auth');

    Timer(Duration(seconds: 2), () {
      Get.offAll(
        () => auth == null ? LoginScreen() : HomeScreen(),
        transition: Transition.topLevel,
        duration: Duration(milliseconds: 800),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   colors: [
              //     cPrimary,
              //     cPrimary.shade300,
              //   ],
              //   tileMode: TileMode.clamp,
              // ),
              color: cPrimary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.sports_soccer_outlined,
                  size: 90,
                  color: Colors.white,
                ),
                SizedBox(height: 5),
                Text(
                  'FUTSEEKER',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
