// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:futseeker/constant.dart';
import 'package:futseeker/models/lapangan.dart';
import 'package:get/get.dart';

class HomeBanner extends StatelessWidget {
  HomeBanner({Key? key, required this.data}) : super(key: key);

  final List<Lapangan> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
