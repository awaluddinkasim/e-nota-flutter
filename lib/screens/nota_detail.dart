import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nota/providers/gabah.dart';
import 'package:nota/screens/customer_signature.dart';
import 'package:provider/provider.dart';

class NotaDetailScreen extends StatelessWidget {
  final Map customer;
  final Map jenisGabah;

  NotaDetailScreen({
    super.key,
    required this.customer,
    required this.jenisGabah,
  });

  final _catatan = TextEditingController();

  final formatter = NumberFormat();

  void _tandaTangan(BuildContext context) {
    final gabah = Provider.of<Gabah>(context, listen: false);

    Map data = {
      "customer": customer,
      "jenis_gabah": jenisGabah,
      "daftar_gabah": gabah.daftarGabah,
      "total_harga": gabah.totalHarga,
      "catatan": _catatan.text,
    };

    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => CustomerSignatureScreen(
          data: data,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gabah = Provider.of<Gabah>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Nota")),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade300,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Detail",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Nama pelanggan"),
                          const SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: Text(
                              "${customer['nama']}",
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("No. HP"),
                          Text("${customer['no_hp']}"),
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Jenis gabah"),
                          const SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: Text(
                              "${jenisGabah['jenis']}",
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Jumlah karung"),
                          Text("${gabah.totalJumlah}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total harga",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Rp. ${formatter.format(gabah.totalHarga)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _catatan,
                  decoration: const InputDecoration(
                    labelText: "Catatan",
                    hintText: "(opsional)",
                    prefixIcon: Icon(Icons.note),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _tandaTangan(context);
                  },
                  child: const Text("Tanda tangan pelanggan"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
