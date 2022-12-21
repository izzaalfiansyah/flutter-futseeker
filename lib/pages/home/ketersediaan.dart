// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:futseeker/constant.dart';
import 'package:futseeker/models/lapangan.dart';
import 'package:futseeker/services/booking.dart';
import 'package:futseeker/services/lapangan.dart';
import 'package:get/get.dart';

class KeterSediaanScreen extends StatefulWidget {
  KeterSediaanScreen({Key? key}) : super(key: key);

  @override
  State<KeterSediaanScreen> createState() => _KeterSediaanScreenState();
}

class _KeterSediaanScreenState extends State<KeterSediaanScreen> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var res = await LapanganService.get();
    var booking = await BookingService.get();

    DateTime dates = DateTime.now();
    int jam = dates.hour;
    String tanggal = getDateNow();

    var filteredData = [];
    for (var item in res) {
      var lapangan = Lapangan.toJSON(item);
      lapangan['jam'] = [];
      for (var i = 0; i < 18; i++) {
        if (i + 6 >= jam) {
          var add = true;
          for (var book in booking) {
            if (item.nama == book.lapangan.nama &&
                book.tanggal == tanggal &&
                (int.parse(book.jam.split(':')[0]) == i + 6)) {
              add = false;
            }
          }

          if (add) {
            lapangan['jam'].add("${i + 6}:00");
          }
        }
      }
      filteredData.add(lapangan);
    }

    setState(() {
      data = filteredData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ketersediaan Lapangan'),
      ),
      body: data.isEmpty
          ? Center(
              child: Text('Data tidak tersedia'),
            )
          : ListView.builder(
              itemCount: data.length,
              padding: EdgeInsets.all(20),
              itemBuilder: (context, index) {
                var item = data[index];

                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 14),
                      width: Get.width,
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: shadowSm,
                          color: cPrimary),
                      child: Text(
                        item['nama'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 7,
                        crossAxisSpacing: 7,
                      ),
                      itemCount: item['jam'].length,
                      itemBuilder: (ctx, i) {
                        var jam = item['jam'][i];
                        return Container(
                          decoration: BoxDecoration(
                            boxShadow: shadowSm,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(jam),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                );
              },
            ),
    );
  }
}
