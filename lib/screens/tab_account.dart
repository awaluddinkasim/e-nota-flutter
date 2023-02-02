import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nota/providers/auth.dart';
import 'package:nota/screens/profile.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class TabAccountScreen extends StatelessWidget {
  const TabAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(Image.asset("assets/img/avatar.jpg").image, context);

    return LoaderOverlay(
      child: SafeArea(
        child: ListView(
          children: [
            Transform(
              transform: Matrix4.translationValues(0, -50, 0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                padding: const EdgeInsets.fromLTRB(0, 120, 0, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: ClipOval(
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.asset(
                            "assets/img/avatar.jpg",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const ProfileScreen(),
                      );
                    },
                    child: const Text("Profile"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.loaderOverlay.show();
                      Provider.of<Auth>(context, listen: false).logout();
                    },
                    child: const Text("Logout"),
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
