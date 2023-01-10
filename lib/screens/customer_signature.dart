import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nota/providers/auth.dart';
import 'package:nota/providers/nota.dart';
import 'package:nota/screens/pdf.dart';
import 'package:nota/services/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

class CustomerSignatureScreen extends StatelessWidget {
  final Map data;
  CustomerSignatureScreen({super.key, required this.data});

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  void submit(context) async {
    final token = Provider.of<Auth>(context, listen: false).token;
    final nota = Provider.of<Nota>(context, listen: false);
    final navigator = Navigator.of(context);

    Uint8List? image = await _controller.toPngBytes();
    final tempDir = await getTemporaryDirectory();
    File file = await File("${tempDir.path}/image.png").create();
    file.writeAsBytesSync(image!);

    FormData data = FormData.fromMap({
      ...this.data,
      "ttd": await MultipartFile.fromFile(file.path),
    });

    try {
      Response response = await dio(token: token).post('nota', data: data);
      if (response.statusCode == 200) {
        nota.getNota(token);
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => NotaPDF(
              kode: response.data['nomor'].toString().replaceAll('/', '-'),
            ),
          ),
          (route) => false,
        );
      }
    } on DioError catch (e) {
      print(e.response!.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Masukkan tanda tangan pelanggan"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 5 / 4,
              child: Signature(
                controller: _controller,
                backgroundColor: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      context.loaderOverlay.show();
                      submit(context);
                    },
                    child: const Text("Selesai"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _controller.clear();
                    },
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.grey),
                    ),
                    child: const Text("Clear"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
