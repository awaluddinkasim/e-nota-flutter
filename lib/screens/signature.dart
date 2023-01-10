import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nota/app.dart';
import 'package:nota/providers/auth.dart';
import 'package:nota/services/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatelessWidget {
  SignatureScreen({super.key});

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  void submit(context) async {
    final token = Provider.of<Auth>(context, listen: false).token;
    final navigator = Navigator.of(context);

    Uint8List? image = await _controller.toPngBytes();
    final tempDir = await getTemporaryDirectory();
    File file = await File("${tempDir.path}/image.png").create();
    file.writeAsBytesSync(image!);

    FormData data = FormData.fromMap({
      "ttd": await MultipartFile.fromFile(file.path),
    });

    Response response = await dio(token: token).post('signature', data: data);
    if (response.statusCode == 200) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => MainApp(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Masukkan tanda tangan"),
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
