import 'package:flutter/material.dart';
import 'package:nota/providers/auth.dart';
import 'package:nota/providers/customer.dart';
import 'package:nota/providers/gabah.dart';
import 'package:nota/providers/nota.dart';
import 'package:nota/screens/loading.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => Customer()),
        ChangeNotifierProvider(create: (context) => Nota()),
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoadingScreen(),
    );
  }
}