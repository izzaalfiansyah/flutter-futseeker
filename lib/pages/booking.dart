// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:futseeker/constant.dart';
import 'package:futseeker/models/booking.dart';
import 'package:futseeker/pages/booking/create.dart';
import 'package:futseeker/services/booking.dart';
import 'package:get/get.dart';

class BookingScreen extends StatefulWidget {
  BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<Booking> data = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var res = await BookingService.get();

    List<Booking> dataFilter = [];
    var tanggal = getDateNow();

    for (var item in res) {
      if (item.tanggal == tanggal) {
        dataFilter.add(item);
      }
    }
    setState(() {
      data = dataFilter.reversed.toList();
    });
  }

  handleVerification(Booking item) {
    Get.defaultDialog(
      title: '',
      titleStyle: TextStyle(fontSize: 0),
      middleText:
          'Anda yakin menyelesaikan booking atas nama "${item.pemesan}" pada tanggal "${item.tanggal} ${item.jam}"?',
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('BATAL')),
        TextButton(
          onPressed: () async {
            await BookingService.update(
              item.id,
              pemesan: item.pemesan,
              lapangan: {
                'id': item.lapangan.id,
                'nama': item.lapangan.nama,
                'harga': item.lapangan.harga,
              },
              status: 1,
              tanggal: item.tanggal,
              jam: item.jam,
              lamaJam: item.lamaJam,
            );
            Get.back();
            getData();

            notif('berhasil menyelesaikan data booking', color: Colors.blue.shade700);
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  handleDelete(Booking item) {
    Get.defaultDialog(
      title: '',
      titleStyle: TextStyle(fontSize: 0),
      middleText:
          'Anda yakin menghapus booking atas nama "${item.pemesan}" pada tanggal "${item.tanggal} ${item.jam}"?',
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('BATAL')),
        TextButton(
          onPressed: () async {
            await BookingService.destroy(item.id);
            Get.back();
            getData();

            notif('berhasil menghapus data booking', color: Colors.blue.shade700);
          },
          child: Text('HAPUS'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Booking'),
      ),
      body: data.isEmpty
          ? Center(
              child: Text("Data tidak tersedia"),
            )
          : ListView.builder(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 70,
              ),
              itemCount: data.length,
              itemBuilder: ((context, index) {
                var item = data[index];

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: shadowSm,
                  ),
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tanggal'),
                          Text(
                            "${item.tanggal} ${item.jam}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: cPrimary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Pemesan'),
                          Text(
                            item.pemesan,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lapangan'),
                          Text(
                            "${item.lapangan.nama} (${formatMoney(item.lapangan.harga)})",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lama Main'),
                          Text(
                            "${item.lamaJam} Jam",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Bayar'),
                          Text(
                            formatMoney(item.lapangan.harga * item.lamaJam),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Status'),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                            decoration: BoxDecoration(
                              color: item.status == 0 ? cPrimary : Colors.green.shade600,
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: shadowSm,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              item.status == 0 ? 'Menunggu' : 'Selesai',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Opsi'),
                          Row(
                            children: [
                              item.status == 0
                                  ? GestureDetector(
                                      onTap: () {
                                        handleVerification(item);
                                      },
                                      child: Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                        size: 22,
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  handleDelete(item);
                                },
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Get.to(
            () => BookingCreateScreen(),
            transition: Transition.downToUp,
            arguments: [data],
            duration: Duration(milliseconds: 400),
          );

          if (result != null) {
            getData();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
