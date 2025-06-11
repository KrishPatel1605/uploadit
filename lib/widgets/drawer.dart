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
            Container(
              color: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.deepPurple),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      currentEmail ?? 'No Email',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, thickness: 1),
            ListTile(
              leading: const Icon(CupertinoIcons.home, color: Colors.white),
              title: const Text(
                "Home",
                textScaler: TextScaler.linear(1.2),
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
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
