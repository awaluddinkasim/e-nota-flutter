import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nota/app.dart';
import 'package:nota/providers/auth.dart';
import 'package:nota/services/dio.dart';
import 'package:provider/provider.dart';

class NotaEditScreen extends StatefulWidget {
  final Map nota;
  const NotaEditScreen({super.key, required this.nota});

  @override
  State<NotaEditScreen> createState() => _NotaEditScreenState();
}

class _NotaEditScreenState extends State<NotaEditScreen> {
  final _catatan = TextEditingController();

  final formatter = NumberFormat();

  @override
  Widget build(BuildContext context) {
    _catatan.text = widget.nota['catatan'] ?? "";

    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(title: const Text("Edit Catatan")),
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
                                "${widget.nota['customer']['nama']}",
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("No. HP"),
                            Text("${widget.nota['customer']['no_hp']}"),
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
                                "${widget.nota['gabah']['jenis']}",
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Jumlah karung"),
                            Text("${widget.nota['items'].length}"),
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
                              "Rp. ${formatter.format(widget.nota['total_harga'])}",
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
                      context.loaderOverlay.show();
                      _update(context);
                    },
                    child: const Text("Simpan"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _update(BuildContext context) async {
    final token = Provider.of<Auth>(context, listen: false).token;
    final navigator = Navigator.of(context);

    Map data = {
      "id": widget.nota['id'],
      "catatan": _catatan.text,
    };

    Response response = await dio(token: token).put("nota", data: data);
    if (response.statusCode == 200) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => MainApp(),
        ),
        (route) => false,
      );
    }
  }
}
