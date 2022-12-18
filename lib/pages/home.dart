// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:futseeker/constant.dart';
import 'package:futseeker/models/lapangan.dart';
import 'package:futseeker/pages/booking.dart';
import 'package:futseeker/services/lapangan.dart';
import 'package:get/get.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Futseeker'),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.account_circle_outlined,
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
                    Padding(
                      padding: EdgeInsets.only(left: 24, bottom: 8),
                      child: Text(
                        'Tersedia jam ini',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: List.generate(
                          lapangan.length,
                          (index) {
                            var item = lapangan[index];

                            return Container(
                              margin: EdgeInsets.only(
                                left: 5,
                                right: 5,
                                bottom: 20,
                              ),
                              decoration: BoxDecoration(
                                color: cPrimary,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: shadowBase,
                              ),
                              height: 130,
                              width: Get.width * .75,
                              child: Center(
                                child: Text(
                                  item.nama,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
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
                                  boxShadow: shadowBase,
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
                      Get.to(() => BookingScreen(), transition: Transition.rightToLeft);
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.table_chart,
                          color: Colors.white,
                          size: 20,
                        ),
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
