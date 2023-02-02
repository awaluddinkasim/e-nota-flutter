import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nota/providers/auth.dart';
import 'package:nota/screens/nota_edit.dart';
import 'package:nota/screens/pdf.dart';
import 'package:nota/services/dio.dart';
import 'package:provider/provider.dart';

class ArchiveScreen extends StatefulWidget {
  final String id;
  final String nama;
  const ArchiveScreen({super.key, required this.id, required this.nama});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  final _search = TextEditingController();
  bool _isLoading = true;
  bool _filtered = false;
  Iterable _daftarNota = [];
  Iterable _filteredNota = [];

  Future<void> _getNota() async {
    final token = Provider.of<Auth>(context, listen: false).token;

    Response response = await dio(token: token).get('nota/${widget.id}');
    if (response.statusCode == 200) {
      setState(() {
        _daftarNota = response.data['nota'];
        _isLoading = false;
      });
    }
  }

  void _filter(String keyword) {
    setState(() {
      _filtered = true;
      _filteredNota = _daftarNota.where(
        (element) => element.toString().toLowerCase().contains(keyword),
      );
    });
  }

  void _resetFilter() {
    setState(() {
      _filtered = false;
      _filteredNota = [];
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getNota();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _getNota,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              _header(context),
              _body(_filtered ? _filteredNota : _daftarNota, context),
            ],
          ),
        ),
      ),
    );
  }

  Padding _body(Iterable<dynamic> daftarNota, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: _isLoading
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
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Daftar nota ${widget.nama}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
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
                        Text("${nota['gabah']['jenis']}"),
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
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Daftar nota",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _search,
                onChanged: (value) {
                  if (value == "") {
                    _resetFilter();
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
                        _filter(_search.text);
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
