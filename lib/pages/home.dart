// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:futseeker/constant.dart';
import 'package:futseeker/models/lapangan.dart';
import 'package:futseeker/pages/booking.dart';
import 'package:futseeker/pages/home/banner.dart';
import 'package:futseeker/pages/login.dart';
import 'package:futseeker/pages/profil.dart';
import 'package:futseeker/services/lapangan.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Lapangan> lapangan = [];

  @override
  void initState() {
    super.initState();
    getLapangan();
  }

  getLapangan() async {
    List<Lapangan> data = await LapanganService.get();
    setState(() {
      lapangan = data;
    });
  }

  handleLogout() {
    Get.defaultDialog(
      title: 'Logout',
      content: Text('Anda yakin akan keluar? Sesi anda akan terhapus!'),
      titlePadding: EdgeInsets.all(20),
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
                    vertical: 20,
                  ),
                  children: [
                    HomeBanner(data: lapangan),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 4,
                            ),
                            child: Text(
                              'Data Lapangan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Column(
                            children: List.generate(lapangan.length, (index) {
                              var item = lapangan[index];

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: shadowSm,
                                  color: Colors.white,
                                ),
                                width: Get.width,
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.nama,
                                          style: TextStyle(
                                            color: cPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "RP ${item.harga}",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     GestureDetector(
                                    //       child: Icon(
                                    //         Icons.edit_outlined,
                                    //         color: Colors.blue,
                                    //         size: 18,
                                    //       ),
                                    //     ),
                                    //     SizedBox(width: 8),
                                    //     GestureDetector(
                                    //       child: Icon(
                                    //         Icons.delete_outline,
                                    //         color: Colors.red,
                                    //         size: 18,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 80),
                        ],
                      ),
                    ),
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
                children: [
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
                      Get.to(() => ProfilScreen(), transition: Transition.rightToLeft);
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
                          'Profil',
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
                      Get.to(() => BookingScreen(), transition: Transition.rightToLeft);
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
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
