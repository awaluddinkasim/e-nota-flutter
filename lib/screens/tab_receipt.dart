import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nota/providers/auth.dart';
import 'package:nota/providers/customer.dart';
import 'package:nota/providers/gabah.dart';
import 'package:nota/screens/calculate.dart';
import 'package:nota/services/dio.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class TabReceiptScreen extends StatefulWidget {
  const TabReceiptScreen({super.key});

  @override
  State<TabReceiptScreen> createState() => _TabReceiptScreenState();
}

class _TabReceiptScreenState extends State<TabReceiptScreen> {
  final _formKey = GlobalKey<FormState>();

  final _search = TextEditingController();

  final _nama = TextEditingController();
  final _hp = TextEditingController();
  final _alamat = TextEditingController();

  void tambahPelanggan() async {
    final token = Provider.of<Auth>(context, listen: false).token;
    final customer = Provider.of<Customer>(context, listen: false);

    Map data = {
      "nama": _nama.text,
      "no_hp": _hp.text,
      "alamat": _alamat.text,
    };

    Response response = await dio(token: token).post("customer", data: data);

    if (response.statusCode == 200) {
      customer.getCustomers(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    Iterable customers = !Provider.of<Customer>(context).filtered
        ? Provider.of<Customer>(context).customers
        : Provider.of<Customer>(context).filteredCustomers;
    return LoaderOverlay(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: SafeArea(
          top: false,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              _header(context),
              _body(customers, context),
            ],
          ),
        ),
      ),
    );
  }

  Padding _body(Iterable<dynamic> customers, BuildContext context) {
    final isLoading = Provider.of<Customer>(context).isLoading;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (customers.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      "Tidak ada data ditemukan",
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  for (var customer in customers) _customer(context, customer),
              ],
            ),
    );
  }

  Future<void> _refresh() async {
    final token = Provider.of<Auth>(context, listen: false).token;
    Provider.of<Customer>(context, listen: false).getCustomers(token);
    Provider.of<Gabah>(context, listen: false).getData(token);
  }

  Padding _customer(BuildContext context, Map data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: CalculateScreen(
                  customer: data,
                ),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "${data['nama']}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text("${data['no_hp']}"),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Transform _header(BuildContext context) {
    final customerProvider = Provider.of<Customer>(context, listen: false);

    return Transform(
      transform: Matrix4.translationValues(0, -50, 0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 60, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Buat Nota",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        useRootNavigator: true,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Tambah Pelanggan",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: _nama,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 0,
                                          horizontal: 20,
                                        ),
                                        hintText: "Nama Lengkap",
                                        prefixIcon: Icon(Icons.abc),
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Harap diisi";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: _hp,
                                      keyboardType: TextInputType.phone,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 0,
                                          horizontal: 20,
                                        ),
                                        hintText: "No. HP",
                                        prefixIcon: Icon(Icons.smartphone),
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Harap diisi";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: _alamat,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 0,
                                          horizontal: 20,
                                        ),
                                        hintText: "Alamat",
                                        prefixIcon: Icon(Icons.location_on),
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Harap diisi";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context.loaderOverlay.show();
                                          tambahPelanggan();
                                          Navigator.pop(context);
                                          context.loaderOverlay.hide();
                                        }
                                      },
                                      child: const Text("Tambah"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.person_add,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _search,
                onChanged: (value) {
                  // print(value);
                  if (value == "") {
                    customerProvider.resetFilter();
                  }
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 20,
                  ),
                  hintText: "Cari nama pelanggan...",
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_search.text != "") {
                        customerProvider.filterCustomer(_search.text);
                      }
                    },
                    icon: const Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
