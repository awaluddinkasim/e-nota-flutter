import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nota/services/dio.dart';

class Nota extends ChangeNotifier {
  bool isLoading = true;
  bool filtered = false;

  Iterable daftarNota = [];
  Iterable filteredNota = [];

  void getNota(token) async {
    _loading();
    Response response = await dio(token: token).get("nota");

    if (response.statusCode == 200) {
      daftarNota = response.data['nota'];
    }
    isLoading = false;

    notifyListeners();
  }

  void filterNota(String keyword) {
    filtered = true;
    filteredNota = daftarNota.where((element) => element['nomor']
        .toString()
        .toLowerCase()
        .contains(keyword.toLowerCase()));

    notifyListeners();
  }

  void resetFilter() {
    filtered = false;
    filteredNota = [];

    notifyListeners();
  }

  void _loading() {
    isLoading = true;
    notifyListeners();
  }
}
