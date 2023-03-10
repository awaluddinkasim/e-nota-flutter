import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nota/providers/auth.dart';
import 'package:nota/providers/customer.dart';
import 'package:nota/screens/archive.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class TabArchiveScreen extends StatefulWidget {
  const TabArchiveScreen({super.key});

  @override
  State<TabArchiveScreen> createState() => _TabArchiveScreenState();
}

class _TabArchiveScreenState extends State<TabArchiveScreen> {
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Iterable customers = !Provider.of<Customer>(context).archiveFiltered
        ? Provider.of<Customer>(context).customers
        : Provider.of<Customer>(context).filteredArchiveCustomers;
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
    Provider.of<Customer>(context, listen: false).resetArchiveFilter();
    Provider.of<Customer>(context, listen: false).getCustomers(token);
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
                screen: ArchiveScreen(
                  id: "${data['id']}",
                  nama: "${data['nama']}",
                ),
                withNavBar: true,
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
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Arsip nota",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 13,
              ),
              TextField(
                controller: _search,
                onChanged: (value) {
                  // print(value);
                  if (value == "") {
                    customerProvider.resetArchiveFilter();
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
                        customerProvider.filterArchiveCustomer(_search.text);
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
