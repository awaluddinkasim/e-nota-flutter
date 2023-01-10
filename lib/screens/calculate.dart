import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nota/providers/gabah.dart';
import 'package:nota/providers/nota.dart';
import 'package:nota/screens/nota_detail.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class CalculateScreen extends StatefulWidget {
  final Map customer;
  const CalculateScreen({super.key, required this.customer});

  @override
  State<CalculateScreen> createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  String? selected;

  final formatter = NumberFormat();

  double hpkg = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<Gabah>(context, listen: false).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final jenisGabah = Provider.of<Gabah>(context).jenisGabah;
    final daftarGabah = Provider.of<Gabah>(context).daftarGabah;

    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Timbang gabah"),
          actions: [
            IconButton(
              onPressed: () {
                if (selected != null) {
                  _tambah(jenisGabah);
                }
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                children: [
                  _header(jenisGabah),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(daftarGabah.length, (index) {
                      return _gabahItem(daftarGabah[index], index);
                    }),
                  ),
                  const SizedBox(
                    height: 120,
                  ),
                ],
              ),
              _detailNota(jenisGabah),
            ],
          ),
        ),
      ),
    );
  }

  Container _header(List<dynamic> jenisGabah) {
    final gabahProvider = Provider.of<Gabah>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Jenis Gabah",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          DropdownButtonFormField(
            items: jenisGabah.map((e) {
              return DropdownMenuItem(
                value: e['id'],
                child: Text(e['jenis']),
              );
            }).toList(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onChanged: (value) {
              final gabah = jenisGabah.firstWhere(
                (element) => element['id'].toString() == value.toString(),
              );
              gabahProvider.hargaChanged(gabah['harga']);
              setState(() {
                selected = value.toString();
              });
            },
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Harga per kg",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            "Rp. ${formatter.format(gabahProvider.hargaPerKilo)}",
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Padding _gabahItem(gabah, index) {
    final gabahProvider = Provider.of<Gabah>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 15,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Timbangan ${index + 1}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Provider.of<Gabah>(context, listen: false)
                          .hapusGabah(gabah);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Jumlah karung"),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      onChanged: (value) {
                        if (value != "" || value.isNotEmpty) {
                          gabahProvider.jumlahChanged(gabah['kode'], value);
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Berat timbangan"),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      onChanged: (value) {
                        if (value != "" || value.isNotEmpty) {
                          gabahProvider.beratChanged(gabah['kode'], value);
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _tambah(List jenisGabah) {
    final gabah = jenisGabah
        .firstWhere((element) => element['id'].toString() == selected);

    Provider.of<Gabah>(context, listen: false).tambahGabah(gabah);
  }

  Column _detailNota(List jenisGabah) {
    final total = Provider.of<Gabah>(context).totalHarga;
    Map gabah = {};
    if (selected != null) {
      gabah = jenisGabah
          .firstWhere((element) => element['id'].toString() == selected);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 5,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 17,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total harga :"),
                  Text("Rp. ${formatter.format(total)}"),
                ],
              ),
              ElevatedButton(
                onPressed: total > 0 && selected != null
                    ? () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: NotaDetailScreen(
                            customer: widget.customer,
                            jenisGabah: gabah,
                          ),
                        );
                      }
                    : null,
                child: const Text("Lanjutkan"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
