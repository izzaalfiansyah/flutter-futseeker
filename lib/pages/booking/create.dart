// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:futseeker/constant.dart';
import 'package:futseeker/models/booking.dart';
import 'package:futseeker/models/lapangan.dart';
import 'package:futseeker/services/booking.dart';
import 'package:futseeker/services/lapangan.dart';
import 'package:get/get.dart';

class BookingCreateScreen extends StatefulWidget {
  BookingCreateScreen({Key? key}) : super(key: key);

  @override
  State<BookingCreateScreen> createState() => _BookingCreateScreenState();
}

class _BookingCreateScreenState extends State<BookingCreateScreen> {
  List<Lapangan> dataLapangan = [];
  List<String> dataJam = [];
  List<String> filteredJam = [];
  List<dynamic> usedJam = [];

  TextEditingController pemesan = TextEditingController();
  TextEditingController lamaJam = TextEditingController();
  dynamic lapangan;
  String? jam;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List arguments = Get.arguments;

  @override
  void initState() {
    super.initState();
    getComponent();
    getJam();
  }

  getJam() {
    List<String> data = [];
    DateTime dates = DateTime.now();
    int jam = dates.hour;

    for (var i = 0; i < 18; i++) {
      if (i + 6 >= jam) {
        data.add('${i + 6}:00');
      }
    }

    setState(() {
      dataJam = data;
    });
  }

  getComponent() async {
    var res = await LapanganService.get();
    setState(() {
      dataLapangan = res;
    });
  }

  handleJam() {
    List<Booking> booking = arguments[0];

    var tanggal = getDateNow();
    var data = [...dataJam];
    var hasData = [];

    for (var item in booking) {
      if (item.lapangan.nama == lapangan['nama'] && item.tanggal == tanggal) {
        for (var i = 0; i < dataJam.length; i++) {
          var jam = dataJam[i];
          if (item.jam == jam) {
            for (var x = 0; x < item.lamaJam; x++) {
              try {
                hasData.add(int.parse(data[i].split(':')[0]));
                data.removeAt(i);
              } catch (e) {
                //
              }
            }
          }
        }
      }
    }

    setState(() {
      usedJam = hasData;
      filteredJam = data;
    });
  }

  handleSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        String tanggal = getDateNow();

        await BookingService.store(
          pemesan: pemesan.text,
          lapangan: lapangan,
          status: 0,
          tanggal: tanggal,
          jam: jam,
          lamaJam: int.parse(lamaJam.text),
        );

        Get.back(result: true);

        notif(
          'data berhasil disimpan',
          color: Colors.blue.shade700,
        );
      } catch (e) {
        notif(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Baru')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: shadowSm,
          ),
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                TextFormField(
                  controller: pemesan,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Masukkan Nama Pemesan',
                    labelText: 'Pemesan',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Pemesan harus diisi";
                    }

                    return null;
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Pilih Lapangan',
                    labelText: 'Lapangan',
                  ),
                  items: List.generate(dataLapangan.length, (index) {
                    var item = dataLapangan[index];

                    return DropdownMenuItem(
                      value: json.encode({
                        'id': item.id,
                        'nama': item.nama,
                        'harga': item.harga,
                      }),
                      child: Text("${item.nama} (${formatMoney(item.harga)})"),
                    );
                  }),
                  onChanged: (val) {
                    setState(() {
                      lapangan = json.decode(val.toString());
                    });
                    handleJam();
                  },
                  validator: (val) {
                    if (val == null) {
                      return "Lapangan harus dipilih";
                    }

                    return null;
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Pilih Jam',
                    labelText: 'Jam',
                    helperText: 'tidak ada berarti sedang digunakan',
                  ),
                  items: List.generate(filteredJam.length, (index) {
                    var item = filteredJam[index];
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }),
                  onChanged: (val) {
                    setState(() {
                      jam = val.toString();
                    });
                  },
                  validator: (val) {
                    if (val == null) {
                      return "Jam harus dipilih";
                    }

                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: lamaJam,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Masukkan Lama Main',
                    labelText: 'Lama Main',
                    suffixText: 'Jam',
                  ),
                  enabled: jam != null,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    formKey.currentState!.validate();
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Lama main harus diisi";
                    }

                    int numberJam = int.parse(jam!.split(':')[0]);

                    if ((int.parse(val) + numberJam) > 24) {
                      return "Lama main melebihi batas waktu";
                    }

                    for (var i = 0; i < int.parse(val); i++) {
                      int jamValue = numberJam + int.parse(val);
                      for (var item in usedJam) {
                        if (numberJam < item) {
                          if (jamValue > item) {
                            return "Lama main melewati jam $item yang telah digunakan";
                          }
                        }
                      }
                    }

                    return null;
                  },
                ),
                SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    handleSubmit();
                  },
                  style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                  child: Text('SIMPAN'),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
