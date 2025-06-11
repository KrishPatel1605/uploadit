import 'package:flutter/material.dart';
import 'package:uploadit/auth/auth_service.dart';
import 'package:uploadit/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authService = AuthService();

  void signOut() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = authService.getCurrentUserEmail();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
        actions: [IconButton(onPressed: signOut, icon: Icon(Icons.logout))],
      ),
      body: Center(child: Text(currentEmail.toString()),
      ),
      drawer: MyDrawer(),
    );
  }
}
