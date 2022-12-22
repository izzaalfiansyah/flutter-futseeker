// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:futseeker/constant.dart';
import 'package:futseeker/models/lapangan.dart';
import 'package:futseeker/services/lapangan.dart';
import 'package:get/get.dart';

class HomeLapangan extends StatefulWidget {
  const HomeLapangan({
    Key? key,
    required this.isAdmin,
  }) : super(key: key);

  final bool isAdmin;

  @override
  State<HomeLapangan> createState() => _HomeLapanganState();
}

class _HomeLapanganState extends State<HomeLapangan> {
  List<Lapangan> data = [];

  @override
  void initState() {
    super.initState();
    getLapangan();
  }

  getLapangan() async {
    List<Lapangan> res = await LapanganService.get();
    setState(() {
      data = res;
    });
  }

  TextEditingController nama = TextEditingController();
  TextEditingController harga = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  handleModal({String? id}) {
    Get.bottomSheet(
      BottomSheet(
        onClosing: () => Get.back(),
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${id != null ? "Edit" : "Tambah"} Lapangan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: nama,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Masukkan Nama Lapangan',
                      labelText: 'Nama',
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Nama harus diisi";
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: harga,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Masukkan Harga',
                      labelText: 'Harga',
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Harga harus diisi";
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => handleSubmit(id: id),
                    style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                    child: Text('SIMPAN'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  handleSubmit({String? id}) {
    if (formKey.currentState!.validate()) {
      try {
        if (id != null) {
          LapanganService.update(id, nama: nama.text, harga: int.parse(harga.text));
        } else {
          LapanganService.store(nama: nama.text, harga: int.parse(harga.text));
        }

        Get.back();
        getLapangan();

        notif(
          'data berhasil disimpan',
          color: Colors.blue.shade700,
        );
      } catch (e) {
        notif(e.toString());
      }
    }
  }

  handleDelete({String? id, required String nama}) {
    try {
      Get.defaultDialog(
        title: 'Hapus Lapangan',
        titleStyle: TextStyle(fontSize: 0),
        middleText: 'Anda yakin menghapus lapangan "$nama"?',
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('BATAL')),
          TextButton(
            onPressed: () async {
              await LapanganService.destroy(id);
              Get.back();
              getLapangan();

              notif('data berhasil dihapus', color: Colors.blue.shade700);
            },
            child: Text('HAPUS'),
          ),
        ],
      );
    } catch (e) {
      notif(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Data Lapangan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                widget.isAdmin
                    ? TextButton(
                        onPressed: () {
                          nama.text = '';
                          harga.text = '';
                          handleModal();
                        },
                        child: Text(
                          'Tambah',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : SizedBox(height: 40),
              ],
            ),
          ),
          data.isNotEmpty
              ? Column(
                  children: List.generate(data.length, (index) {
                    var item = data[index];

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
                                formatMoney(item.harga),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            children: widget.isAdmin
                                ? [
                                    GestureDetector(
                                      onTap: () {
                                        nama.text = item.nama;
                                        harga.text = item.harga.toString();
                                        handleModal(id: item.id);
                                      },
                                      child: Icon(
                                        Icons.edit_outlined,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        handleDelete(
                                          id: item.id,
                                          nama: item.nama,
                                        );
                                      },
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                  ]
                                : [],
                          ),
                        ],
                      ),
                    );
                  }),
                )
              : Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: shadowSm,
                  ),
                  child: Center(
                    child: Text('Data tidak tersedia'),
                  ),
                ),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}
