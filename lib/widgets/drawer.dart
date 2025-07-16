import 'package:flutter/material.dart';
import 'package:uploadit/auth/auth_service.dart';
import 'package:uploadit/utils/routes.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Logged in as:',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    currentEmail ?? 'No Email',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, thickness: 1),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text(
                "Home",
                textScaler: TextScaler.linear(1.2),
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pushNamed(context, Routes.homeRoute),
            ),
            ListTile(
              leading: Icon(Icons.upload_file, color: Colors.white),
              title: Text(
                "Upload File",
                textScaler: TextScaler.linear(1.2),
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pushNamed(context, Routes.uploadRoute),
            ),
            ExpansionTile(
              leading: const Icon(Icons.download, color: Colors.white),
              title: const Text(
                "Download File",
                textScaler: TextScaler.linear(1.2),
                style: TextStyle(color: Colors.white),
              ),
              collapsedIconColor: Colors.white,
              iconColor: Colors.white,
              childrenPadding: const EdgeInsets.only(left: 40),
              children: [
                ListTile(
                  leading: const Icon(Icons.qr_code, color: Colors.white),
                  title: const Text(
                    "By QR Code",
                    textScaler: TextScaler.linear(1.1),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        Routes.downloadByQRRoute,
                      ),
                ),
                ListTile(
                  leading: const Icon(Icons.input, color: Colors.white),
                  title: const Text(
                    "By Code Input",
                    textScaler: TextScaler.linear(1.1),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        Routes.downloadByCodeRoute,
                      ),
                ),
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.folder, color: Colors.white),
              title: Text(
                "My Files",
                textScaler: TextScaler.linear(1.2),
                style: TextStyle(color: Colors.white),
              ),
              collapsedIconColor: Colors.white,
              iconColor: Colors.white,
              childrenPadding: const EdgeInsets.only(left: 40),
              children: [
                ListTile(
                  leading: const Icon(Icons.upload_file, color: Colors.white),
                  title: const Text(
                    "My Uploads",
                    textScaler: TextScaler.linear(1.1),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap:
                      () => Navigator.pushNamed(context, Routes.myUploadsRoute),
                ),
                ListTile(
                  leading: const Icon(Icons.download, color: Colors.white),
                  title: const Text(
                    "My Downloads",
                    textScaler: TextScaler.linear(1.1),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap:
                      () =>
                          Navigator.pushNamed(context, Routes.myDownloadsRoute),
                ),
              ],
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
