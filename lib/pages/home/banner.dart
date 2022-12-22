// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:futseeker/constant.dart';
import 'package:futseeker/models/booking.dart';
import 'package:futseeker/models/lapangan.dart';
import 'package:futseeker/pages/home/ketersediaan.dart';
import 'package:futseeker/services/booking.dart';
import 'package:futseeker/services/lapangan.dart';
import 'package:get/get.dart';

class HomeBanner extends StatefulWidget {
  HomeBanner({Key? key}) : super(key: key);

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  List<Lapangan> data = [];

  @override
  void initState() {
    super.initState();
    getLapangan();
  }

  getLapangan() async {
    List<Lapangan> res = await LapanganService.get();
    List<Booking> booking = await BookingService.get();

    var filteredData = [...res];
    var tanggal = getDateNow();

    DateTime dates = DateTime.now();
    int jam = dates.hour;

    for (var item in res) {
      for (var book in booking) {
        for (var i = 0; i < book.lamaJam; i++) {
          if (tanggal == book.tanggal &&
              item.nama == book.lapangan.nama &&
              jam == (int.parse(book.jam.split(':')[0]) + i)) {
            try {
              filteredData.remove(item);
            } catch (e) {
              //
            }
          }
        }
      }
    }

    setState(() {
      data = filteredData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 24, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tersedia Jam ini',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(
                    () => KeterSediaanScreen(),
                    transition: Transition.downToUp,
                    duration: Duration(milliseconds: 400),
                  );
                },
                child: Text(
                  'Selengkapnya',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        data.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: List.generate(
                    data.length,
                    (index) {
                      var item = data[index];

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
                        height: 150,
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
              )
            : Container(
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: shadowBase,
                ),
                height: 150,
                width: Get.width,
                child: Center(
                  child: Text('Tidak tersedia'),
                ),
              ),
      ],
    );
  }
}
