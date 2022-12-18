// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, prefer_const_constructors, invalid_use_of_visible_for_testing_member

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:futseeker/constant.dart';
import 'package:futseeker/models/user.dart';
import 'package:futseeker/pages/home.dart';
import 'package:futseeker/services/auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool showPassword = false;

  handleLogin() async {
    if (formKey.currentState!.validate()) {
      try {
        var res = await AuthService.login(
          username: username.text,
          password: password.text,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth', json.encode(User.toJSON(res)));

        Get.offAll(
          () => HomeScreen(),
          transition: Transition.upToDown,
          duration: Duration(milliseconds: 800),
        );
      } catch (e) {
        notif(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: -200,
            left: -120,
            child: Transform.rotate(
              angle: -.5,
              child: Container(
                width: Get.width * 2,
                height: Get.height * .5,
                decoration: BoxDecoration(
                  color: cPrimary,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70),
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Masukkan data anda untuk \nmemulai sesi!',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: Get.height * .5,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Masukkan Username',
                          labelText: 'Username',
                        ),
                        controller: username,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'username harus diisi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Masukkan Password',
                          labelText: 'Password',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            child: Icon(
                              showPassword ? Icons.remove_red_eye_outlined : Icons.lock_outlined,
                            ),
                          ),
                        ),
                        obscureText: !showPassword,
                        controller: password,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'password harus diisi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 80),
                      ElevatedButton(
                        onPressed: handleLogin,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
