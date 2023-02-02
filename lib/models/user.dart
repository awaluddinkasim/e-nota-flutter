class User {
  String? username;
  String? nama;
  String? ttd;
  Map? toko;

  User.fromJson(json)
      : username = json['username'],
        nama = json['nama'],
        ttd = json['ttd'],
        toko = json['toko'];
}
