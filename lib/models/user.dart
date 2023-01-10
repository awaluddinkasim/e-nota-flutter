class User {
  String? username;
  String? nama;
  String? ttd;

  User.fromJson(json)
      : username = json['username'],
        nama = json['nama'],
        ttd = json['ttd'];
}
