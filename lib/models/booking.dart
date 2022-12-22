import 'package:futseeker/models/lapangan.dart';

class Booking {
  final String id;
  final String pemesan;
  final Lapangan lapangan;
  final int lamaJam;
  final String tanggal;
  final String jam;
  final int status;
  final String operator;

  Booking(
    this.id,
    this.pemesan,
    this.lapangan,
    this.lamaJam,
    this.tanggal,
    this.jam,
    this.status,
    this.operator,
  );

  factory Booking.fromJSON({
    id,
    pemesan,
    lapangan,
    lamaJam,
    tanggal,
    jam,
    status,
    operator,
  }) {
    return Booking(
      id,
      pemesan,
      lapangan,
      lamaJam,
      tanggal,
      jam,
      status,
      operator,
    );
  }

  static toJSON(Booking data) {
    return {
      'id': data.id,
      'pemesan': data.pemesan,
      'lamaJam': data.lamaJam,
      'jam': data.jam,
      'tanggal': data.tanggal,
      'status': data.status,
      'lapangan': {
        'id': data.lapangan.id,
        'nama': data.lapangan.nama,
        'harga': data.lapangan.harga,
      },
      'operator': data.operator,
    };
  }
}
