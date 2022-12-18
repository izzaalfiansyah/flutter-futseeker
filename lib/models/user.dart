class User {
  final String id;
  final String username;
  final String password;
  final String nama;
  final String telepon;
  final String alamat;
  final bool? isAdmin;

  User(
    this.id,
    this.username,
    this.password,
    this.nama,
    this.telepon,
    this.alamat,
    this.isAdmin,
  );

  factory User.fromJSON({
    id,
    username,
    password,
    nama,
    telepon,
    alamat,
    isAdmin,
  }) {
    return User(
      id,
      username,
      password,
      nama,
      telepon,
      alamat,
      isAdmin,
    );
  }

  static toJSON(User user) {
    return {
      'id': user.id,
      'username': user.username,
      'password': user.password,
      'nama': user.nama,
      'telepon': user.telepon,
      'alamat': user.alamat,
      'isAdmin': user.isAdmin,
    };
  }
}
