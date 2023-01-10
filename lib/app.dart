import 'package:flutter/material.dart';
import 'package:nota/providers/auth.dart';
import 'package:nota/screens/login.dart';
import 'package:nota/screens/tab_account.dart';
import 'package:nota/screens/tab_archive.dart';
import 'package:nota/screens/tab_home.dart';
import 'package:nota/screens/tab_receipt.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      const TabHomeScreen(),
      const TabReceiptScreen(),
      const TabArchiveScreen(),
      const TabAccountScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.receipt),
        title: ("Nota"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.archive),
        title: ("Arsip"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: ("Akun"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    Future.delayed(Duration.zero, () {
      if (auth.authenticated == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      }
    });

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
    );
  }
}
