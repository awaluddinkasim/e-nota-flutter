import 'package:flutter/material.dart';
import 'package:nota/providers/auth.dart';
import 'package:nota/providers/nota.dart';
import 'package:nota/screens/nota_edit.dart';
import 'package:nota/screens/pdf.dart';
import 'package:provider/provider.dart';

class TabArchiveScreen extends StatefulWidget {
  const TabArchiveScreen({super.key});

  @override
  State<TabArchiveScreen> createState() => _TabArchiveScreenState();
}

class _TabArchiveScreenState extends State<TabArchiveScreen> {
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      precacheImage(Image.asset("assets/img/avatar.jpg").image, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Iterable daftarNota = !Provider.of<Nota>(context).filtered
        ? Provider.of<Nota>(context).daftarNota
        : Provider.of<Nota>(context).filteredNota;

    return SafeArea(
      top: false,
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _header(context),
            _body(daftarNota, context),
          ],
        ),
      ),
    );
  }

  Padding _body(Iterable<dynamic> daftarNota, BuildContext context) {
    final isLoading = Provider.of<Nota>(context).isLoading;

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
                if (daftarNota.isEmpty)
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
                  for (var nota in daftarNota) _nota(nota),
              ],
            ),
    );
  }

  Padding _nota(nota) {
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
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => NotaPDF(
                    hasBackButton: true,
                    kode: nota['nomor'].toString().replaceAll('/', '-'),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NotaEditScreen(
                                nota: nota,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
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
                          "Nota: ${nota['nomor']}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text("${nota['customer']['nama']}"),
                        Text("${nota['tanggal']}"),
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
    final notaProvider = Provider.of<Nota>(context, listen: false);

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
                height: 10,
              ),
              const Text(
                "Arsip",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _search,
                onChanged: (value) {
                  if (value == "") {
                    notaProvider.resetFilter();
                  }
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 20,
                  ),
                  hintText: "Cari nomor nota...",
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_search.text != "") {
                        notaProvider.filterNota(_search.text);
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

  Future<void> _refresh() async {
    final token = Provider.of<Auth>(context, listen: false).token;
    Provider.of<Nota>(context, listen: false).getNota(token);
  }
}
