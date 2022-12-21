// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:futseeker/constant.dart';
import 'package:futseeker/models/user.dart';
import 'package:futseeker/services/user.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AkunScreen extends StatefulWidget {
  AkunScreen({Key? key}) : super(key: key);

  @override
  State<AkunScreen> createState() => _AkunScreenState();
}

class _AkunScreenState extends State<AkunScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController telepon = TextEditingController();
  TextEditingController alamat = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String id = '';
  bool? isAdmin;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    User auth = await authUser();

    setState(() {
      id = auth.id;
      isAdmin = auth.isAdmin;
    });

    username.text = auth.username;
    password.text = auth.password;
    nama.text = auth.nama;
    telepon.text = auth.telepon;
    alamat.text = auth.alamat;
  }

  handleSubmit() async {
    if (formKey.currentState!.validate()) {
      try {
        UserService.update(
          id,
          username: username.text,
          password: password.text,
          nama: nama.text,
          telepon: telepon.text,
          alamat: alamat.text,
          isAdmin: isAdmin,
        );
        notif('akun berhasil diedit', color: Colors.blue.shade700);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'auth',
          json.encode({
            'id': id,
            'username': username.text,
            'password': password.text,
            'nama': nama.text,
            'telepon': telepon.text,
            'alamat': alamat.text,
            'isAdmin': isAdmin,
          }),
        );
      } catch (e) {
        notif(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akun'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              boxShadow: shadowBase,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  TextFormField(
                    controller: nama,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Nama',
                      labelText: 'Nama',
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Nama harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: telepon,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Telepon',
                      labelText: 'Telepon',
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Telepon harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: alamat,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Alamat',
                      labelText: 'Alamat',
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Alamat harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Username',
                      labelText: 'Username',
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Username harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Password',
                      labelText: 'Password',
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Password harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: handleSubmit,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(Get.width, 50),
                    ),
                    child: Text('SIMPAN'),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
