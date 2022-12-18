class User {
  final String id;
  final String username;
  final String password;
  final String nama;
  final String telepon;
  final bool? isAdmin;

  User(this.id, this.username, this.password, this.nama, this.telepon, this.isAdmin);

  factory User.fromJSON({
    id,
    username,
    password,
    nama,
    telepon,
    isAdmin,
  }) {
    return User(
      id,
      username,
      password,
      nama,
      telepon,
      isAdmin,
    );
  }
}
