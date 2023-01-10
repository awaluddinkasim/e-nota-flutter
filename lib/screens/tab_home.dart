import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabHomeScreen extends StatelessWidget {
  const TabHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("E-Nota"),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 20,
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Selamat Datang",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/img/welcome.svg",
                      height: 350,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
