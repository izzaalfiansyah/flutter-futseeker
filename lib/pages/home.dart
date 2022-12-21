// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:futseeker/constant.dart';
import 'package:futseeker/models/user.dart';
import 'package:futseeker/pages/booking.dart';
import 'package:futseeker/pages/home/banner.dart';
import 'package:futseeker/pages/home/lapangan.dart';
import 'package:futseeker/pages/laporan.dart';
import 'package:futseeker/pages/login.dart';
import 'package:futseeker/pages/akun.dart';
import 'package:futseeker/pages/pengguna.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user = User('id', 'username', 'password', 'nama', 'telepon', 'alamat', false);

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    User auth = await authUser();
    setState(() {
      user = auth;
    });
  }

  handleLogout() {
    Get.defaultDialog(
      title: '',
      titleStyle: TextStyle(fontSize: 0),
      middleText: 'Anda yakin akan keluar? Sesi anda akan terhapus!',
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('BATAL'),
        ),
        TextButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();

            Get.offAll(
              () => LoginScreen(),
              transition: Transition.downToUp,
              duration: Duration(milliseconds: 800),
            );
          },
          child: Text('KELUAR'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Futseeker'),
        actions: [
          GestureDetector(
            onTap: handleLogout,
            child: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 14),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  children: [
                    HomeBanner(),
                    HomeLapangan(isAdmin: user.isAdmin),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: Container(
              decoration: BoxDecoration(
                color: cPrimary,
                boxShadow: shadowBase,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: user.isAdmin
                    ? [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => BookingScreen(), transition: Transition.rightToLeft);
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.book,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Booking',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => AkunScreen(), transition: Transition.rightToLeft);
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Akun',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => PenggunaScreen(), transition: Transition.rightToLeft);
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.supervised_user_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Pengguna',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => LaporanScreen(), transition: Transition.rightToLeft);
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.table_chart,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Laporan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                    : [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => BookingScreen(), transition: Transition.rightToLeft);
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.book,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Booking',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => AkunScreen(), transition: Transition.rightToLeft);
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Akun',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
