// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nota/app.dart';
import 'package:nota/constants.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class NotaPDF extends StatefulWidget {
  final String kode;
  final bool hasBackButton;
  final List? actions;
  const NotaPDF({
    super.key,
    required this.kode,
    this.actions,
    this.hasBackButton = false,
  });

  @override
  State<NotaPDF> createState() => _NotaPDFState();
}

class _NotaPDFState extends State<NotaPDF> {
  bool _isLoading = true;

  PDFDocument? document;
  bool _fileExist = false;

  @override
  void initState() {
    super.initState();
    _loadDocument();
    _checkFile();
  }

  void _checkFile() {
    var path = "/storage/emulated/0/Download/${widget.kode}.pdf";
    if (File(path).existsSync()) {
      setState(() {
        _fileExist = true;
      });
    }
  }

  void _loadDocument() async {
    try {
      document = await PDFDocument.fromURL(
        "${AppConstants.baseUrl}files/nota/${widget.kode}/nota.pdf",
        cacheManager: CacheManager(
          Config(
            widget.kode,
            stalePeriod: Duration.zero,
          ),
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _share() async {
    var path = "/storage/emulated/0/Download/${widget.kode}.pdf";
    if (File(path).existsSync()) {
      await Share.shareXFiles(
        [XFile(path)],
        text: "Bagikan Nota",
      );
    } else {
      _download(share: true);
    }
  }

  void _delete() async {
    var path = "/storage/emulated/0/Download/${widget.kode}.pdf";
    if (File(path).existsSync()) {
      File(path).delete();
    }
  }

  void _download({bool share = false}) async {
    if (_fileExist) {
      _delete();
    }
    final msg = ScaffoldMessenger.of(context);
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      String fileUrl =
          "${AppConstants.baseUrl}files/nota/${widget.kode}/nota.pdf";
      var path = "/storage/emulated/0/Download/";
      var downloadDir = Directory(path);

      String savename = "${widget.kode}.pdf";
      String savePath = "${downloadDir.path}/$savename";
      print(savePath);

      const snackBar = SnackBar(
        content: Text('Sedang mendownload...'),
      );

      msg.showSnackBar(snackBar);
      try {
        await Dio().download(
          fileUrl,
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              print((received / total * 100).toStringAsFixed(0) + "%");
            }
          },
        );

        if (share) {
          _share();
        } else {
          var snackBar = SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Nota telah terdownload'),
                GestureDetector(
                  onTap: () {
                    OpenFile.open(savePath);
                  },
                  child: const Text(
                    'BUKA',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          );
          msg.showSnackBar(snackBar);
          print("File is saved to download folder.");
        }
      } on DioError catch (e) {
        print(e);

        const snackBar = SnackBar(
          content: Text('Download gagal'),
        );

        msg.showSnackBar(snackBar);
      }
    } else {
      print("No permission to read and write.");
      const snackBar = SnackBar(
        content: Text('Permission denied'),
      );

      msg.showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: !widget.hasBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MainApp(),
                  ),
                  (route) => false,
                ),
              )
            : null,
        title: const Text("Nota"),
        actions: [
          ...?widget.actions,
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          _download();
                        },
                        leading: const Icon(Icons.download),
                        title: const Text("Unduh"),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          if (_fileExist) {
                            _share();
                          } else {
                            _download(share: true);
                          }
                        },
                        leading: const Icon(Icons.share),
                        title: const Text("Bagikan"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : PDFViewer(document: document!),
      ),
    );
  }
}
