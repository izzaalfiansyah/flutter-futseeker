// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:futseeker/constant.dart';
import 'package:futseeker/models/user.dart';
import 'package:futseeker/services/user.dart';
import 'package:get/get.dart';

class PenggunaScreen extends StatefulWidget {
  PenggunaScreen({Key? key}) : super(key: key);

  @override
  State<PenggunaScreen> createState() => _PenggunaScreenState();
}

class _PenggunaScreenState extends State<PenggunaScreen> {
  List<User> data = [];
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController telepon = TextEditingController();
  TextEditingController alamat = TextEditingController();
  bool isAdmin = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var res = await UserService.get();
    setState(() {
      data = res.reversed.toList();
    });
  }

  handleSubmit({String? id}) {
    if (formKey.currentState!.validate()) {
      try {
        if (id != null) {
          UserService.update(id,
              username: username.text,
              password: password.text,
              nama: nama.text,
              telepon: telepon.text,
              alamat: alamat.text,
              isAdmin: isAdmin);
        } else {
          UserService.store(
              username: username.text,
              password: password.text,
              nama: nama.text,
              telepon: telepon.text,
              alamat: alamat.text,
              isAdmin: isAdmin);
        }

        Get.back();
        getData();

        notif(
          'data berhasil disimpan',
          color: Colors.blue.shade700,
        );
      } catch (e) {
        notif(e.toString());
      }
    }
  }

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
                children: [
                  Text(
                    '${id != null ? "Edit" : "Tambah"} Pengguna',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: nama,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Masukkan Nama',
                      labelText: 'Nama',
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Nama harus diisi";
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: telepon,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Masukkan Nomor Telepon',
                      labelText: 'Nomor Telepon',
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Nomor telepon harus diisi";
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    maxLines: 3,
                    controller: alamat,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Masukkan Alamat',
                      labelText: 'Alamat',
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Alamat harus diisi";
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Masukkan Username',
                      labelText: 'Username',
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Username harus diisi";
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Masukkan Password',
                      labelText: 'Password',
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Password harus diisi";
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      handleSubmit(id: id);
                    },
                    style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                    child: Text('SIMPAN'),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  handleDelete(User item) {
    try {
      Get.defaultDialog(
        title: 'Hapus Pengguna',
        titleStyle: TextStyle(fontSize: 0),
        middleText: 'Anda yakin menghapus "${item.nama}"?',
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('BATAL')),
          TextButton(
            onPressed: () async {
              await UserService.destroy(item.id);
              Get.back();
              getData();

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Pengguna'),
      ),
      body: data.isEmpty
          ? Center(
              child: Text('Data tidak tersedia.'),
            )
          : ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: data.length,
              itemBuilder: (context, index) {
                var item = data[index];
                return Container(
                  margin: EdgeInsets.only(bottom: index + 1 == data.length ? 70 : 10),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: shadowSm,
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Username'),
                          Text(
                            item.username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Nama'),
                          Text(
                            item.nama,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Telepon'),
                          Text(
                            item.telepon,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Alamat'),
                          Text(
                            item.alamat,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Opsi'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  username.text = item.username;
                                  password.text = item.password;
                                  nama.text = item.nama;
                                  telepon.text = item.telepon;
                                  alamat.text = item.alamat;
                                  setState(() {
                                    isAdmin = item.isAdmin;
                                  });

                                  handleModal(id: item.id);
                                },
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  handleDelete(item);
                                },
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          username.text = '';
          password.text = '';
          nama.text = '';
          alamat.text = '';
          telepon.text = '';
          handleModal();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
