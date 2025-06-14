import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyFilesPage extends StatelessWidget {
  const MyFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;
    final email = client.auth.currentUser?.email;

    if (email == null) {
      return const Scaffold(body: Center(child: Text('Not logged in')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Files")),
      body: FutureBuilder(
        future: client.from('files').select().eq('uploader_email', email),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final files = snapshot.data as List;

          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              return ListTile(
                title: Text(file['original_name']),
                subtitle: Text("Code: ${file['download_code']}"),
              );
            },
          );
        },
      ),
    );
  }
}
