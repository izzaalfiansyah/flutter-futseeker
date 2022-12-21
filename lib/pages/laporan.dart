// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:futseeker/constant.dart';
import 'package:futseeker/services/booking.dart';

class LaporanScreen extends StatefulWidget {
  LaporanScreen({Key? key}) : super(key: key);

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  List<dynamic> laporan = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var res = await BookingService.get();
    var data = {};

    for (var item in res) {
      if (data[item.tanggal] == null) {
        data[item.tanggal] = item.lapangan.harga * item.lamaJam;
      } else {
        data[item.tanggal] += item.lapangan.harga * item.lamaJam;
      }
    }

    var dataList = [];
    data.forEach((key, value) {
      dataList.add({
        'tanggal': key,
        'pendapatan': value,
      });
    });

    setState(() {
      laporan = dataList.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Harian'),
      ),
      body: laporan.isEmpty
          ? Center(
              child: Text('Data tidak tersedia'),
            )
          : ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: laporan.length,
              itemBuilder: (context, index) {
                var item = laporan[index];

                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              width: 5,
                              height: 110,
                              decoration: BoxDecoration(
                                color: cPrimary,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: shadowSm,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: shadowSm,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(item['tanggal']),
                                SizedBox(height: 20),
                                Text(
                                  formatMoney(item['pendapatan']),
                                  style: TextStyle(
                                    color: cPrimary,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                );
              },
            ),
    );
  }
}
