import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uploadit/auth/auth_service.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});
  final authService = AuthService();

  void signOut() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = authService.getCurrentUserEmail();
    return Drawer(
      child: Container(
        color: Colors.deepPurple,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(color: Colors.deepPurple),
                accountName: Text("Krish Patel"),
                accountEmail: Text(currentEmail.toString()),
              ),
            ),
            ListTile(
              leading: Icon(CupertinoIcons.home, color: Colors.white),
              title: Text(
                "Home",
                textScaler: TextScaler.linear(1.2),
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout, //login icon is different
                color: Colors.white,
              ),
              title: Text(
                "Sign Out",
                textScaler: TextScaler.linear(1.2),
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
