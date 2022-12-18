// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:futseeker/models/booking.dart';
import 'package:futseeker/services/booking.dart';

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
    setState(() {
      data = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Booking'),
      ),
      body: Center(
        child: Text("Data tidak tersedia"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getData();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
