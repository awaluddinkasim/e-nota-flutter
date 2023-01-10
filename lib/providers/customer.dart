import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nota/services/dio.dart';

class Customer extends ChangeNotifier {
  bool isLoading = true;
  bool filtered = false;

  Iterable customers = [];
  Iterable filteredCustomers = [];

  void filterCustomer(String keyword) {
    filtered = true;
    filteredCustomers = customers.where((element) => element['nama']
        .toString()
        .toLowerCase()
        .contains(keyword.toLowerCase()));

    notifyListeners();
  }

  void resetFilter() {
    filtered = false;
    filteredCustomers = [];

    notifyListeners();
  }

  void getCustomers(token) async {
    _loading();
    Response response = await dio(token: token).get("customers");

    if (response.statusCode == 200) {
      customers = response.data['customers'];
    }
    isLoading = false;

    notifyListeners();
  }

  void _loading() {
    isLoading = true;
    notifyListeners();
  }
}
