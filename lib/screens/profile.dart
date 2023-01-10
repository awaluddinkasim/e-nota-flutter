import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nota/providers/auth.dart';
import 'package:nota/services/dio.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _key = GlobalKey<FormState>();

  final _nama = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();

  void _submit() async {
    final navigator = Navigator.of(context);
    final authProvider = Provider.of<Auth>(context, listen: false);

    Map data = {
      "nama": _nama.text,
      "username": _username.text,
      "password": _password.text,
    };

    try {
      Response response =
          await dio(token: authProvider.token).put("profile", data: data);

      if (response.statusCode == 200) {
        authProvider.updateUser(response.data['user']);
        navigator.pop();
      }
    } on DioError catch (e) {
      print(e.response!.data['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context, listen: false).user;
    _nama.text = user!.nama ?? "";
    _username.text = user.username ?? "";

    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 30,
                  ),
                  child: Form(
                    key: _key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nama,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harap diisi';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _username,
                          decoration:
                              const InputDecoration(labelText: 'Username'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harap diisi';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _password,
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              context.loaderOverlay.show();
                              _submit();
                            }
                          },
                          child: const Text("Simpan"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
