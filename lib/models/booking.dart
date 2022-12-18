import 'package:futseeker/models/lapangan.dart';

class Booking {
  final String id;
  final String pemesan;
  final Lapangan lapangan;
  final int lamaJam;
  final String tanggal;
  final String jam;
  final int status;

  Booking(
    this.id,
    this.pemesan,
    this.lapangan,
    this.lamaJam,
    this.tanggal,
    this.jam,
    this.status,
  );

  factory Booking.fromJSON({
    id,
    pemesan,
    lapangan,
    lamaJam,
    tanggal,
    jam,
    status,
  }) {
    return Booking(
      id,
      pemesan,
      lapangan,
      lamaJam,
      tanggal,
      jam,
      status,
    );
  }
}
