import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nota/services/dio.dart';
import 'package:random_string/random_string.dart';

class Gabah extends ChangeNotifier {
  List jenisGabah = [];

  List daftarGabah = [];
  double totalHarga = 0;
  int totalJumlah = 0;
  int hargaPerKilo = 0;

  void getData(token) async {
    Response response = await dio(token: token).get("gabah");

    if (response.statusCode == 200) {
      jenisGabah = response.data['jenisGabah'];
    }

    notifyListeners();
  }

  void tambahGabah(gabah) {
    daftarGabah.add({
      "kode": randomAlphaNumeric(5),
      "jumlah": 0,
      "berat": 0,
      "harga": 0,
    });

    notifyListeners();
  }

  void hargaChanged(harga) {
    hargaPerKilo = int.parse(harga.toString());

    notifyListeners();
  }

  void jumlahChanged(kode, value) {
    daftarGabah.firstWhere((element) => element["kode"] == kode)["jumlah"] =
        value;

    notifyListeners();
  }

  void beratChanged(kode, value) {
    daftarGabah.firstWhere((element) => element["kode"] == kode)["berat"] =
        value;
    daftarGabah.firstWhere((element) => element["kode"] == kode)["harga"] =
        int.parse(value.toString()) * hargaPerKilo;
    _hitungTotal();
  }

  void hapusGabah(gabah) {
    daftarGabah.removeWhere((element) => element["kode"] == gabah["kode"]);
    _hitungTotal();
  }

  void _hitungTotal() {
    int jumlah = 0;
    double hasil = 0;

    for (var gabah in daftarGabah) {
      jumlah += int.parse(gabah["jumlah"].toString());
      hasil += double.parse(gabah["berat"].toString()) * hargaPerKilo;
    }

    totalJumlah = jumlah;
    totalHarga = hasil;
    notifyListeners();
  }

  void reset() {
    totalHarga = 0;
    totalJumlah = 0;
    daftarGabah = [];

    notifyListeners();
  }
}
