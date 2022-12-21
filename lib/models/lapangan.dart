class Lapangan {
  final String id;
  final String nama;
  final int harga;

  Lapangan(this.id, this.nama, this.harga);

  factory Lapangan.fromJSON({
    id,
    nama,
    harga,
  }) {
    return Lapangan(id, nama, harga);
  }

  static toJSON(Lapangan item) {
    return {
      'id': item.id,
      'nama': item.nama,
      'harga': item.harga,
    };
  }
}
