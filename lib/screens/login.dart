import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nota/app.dart';
import 'package:nota/providers/auth.dart';
import 'package:nota/providers/customer.dart';
import 'package:nota/providers/gabah.dart';
import 'package:nota/providers/nota.dart';
import 'package:nota/screens/signature.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _username = TextEditingController();
  final _password = TextEditingController();

  void login() async {
    Map creds = {
      "username": _username.text,
      "password": _password.text,
    };

    Provider.of<Auth>(context, listen: false).login(creds);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    Future.delayed(Duration.zero, () {
      if (auth.authenticated != null && auth.authenticated == true) {
        Provider.of<Customer>(context, listen: false).getCustomers(auth.token);
        Provider.of<Gabah>(context, listen: false).getData(auth.token);
        Provider.of<Nota>(context, listen: false).getNota(auth.token);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) {
              if (auth.user!.ttd != null) {
                return MainApp();
              }
              return SignatureScreen();
            },
          ),
          (route) => false,
        );
      } else if (auth.authenticated != null && auth.authenticated == false) {
        context.loaderOverlay.hide();
      }
    });

    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: Colors.blue.shade100,
        body: SafeArea(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            children: [
              const SizedBox(
                height: 150,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Log in",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Penotaan Gabah Digital",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: _username,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          prefixIcon: const Icon(Icons.person),
                          hintText: "Username",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Harap diisi";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _password,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Harap diisi";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.loaderOverlay.show();
                            login();
                          }
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
