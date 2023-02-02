import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nota/app.dart';
import 'package:nota/providers/auth.dart';
import 'package:nota/providers/customer.dart';
import 'package:nota/providers/gabah.dart';
import 'package:nota/screens/login.dart';
import 'package:nota/screens/signature.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      checkAuth();
    });
  }

  void checkAuth() async {
    final navigator = Navigator.of(context);
    final auth = Provider.of<Auth>(context, listen: false);
    String? token = await storage.read(key: "token");

    if (token != null) {
      auth.getUserData(token);
    } else {
      navigator.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    Future.delayed(Duration.zero, () {
      if (auth.authenticated != null && auth.authenticated == true) {
        Provider.of<Customer>(context, listen: false).getCustomers(auth.token);
        Provider.of<Gabah>(context, listen: false).getData(auth.token);
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
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      }
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
