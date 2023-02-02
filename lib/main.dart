import 'package:flutter/material.dart';
import 'package:nota/constants.dart';
import 'package:nota/providers/auth.dart';
import 'package:nota/providers/customer.dart';
import 'package:nota/providers/gabah.dart';
import 'package:nota/screens/loading.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => Customer()),
        ChangeNotifierProvider(create: (context) => Gabah()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoadingScreen(),
    );
  }
}
