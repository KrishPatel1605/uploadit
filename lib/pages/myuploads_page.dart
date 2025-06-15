import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyUploadsPage extends StatelessWidget {
  const MyUploadsPage({super.key});

  void showQrPopup(BuildContext context, String code) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QrImageView(data: code, size: 150),
                    const SizedBox(height: 10),
                    Text(
                      code,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Close Button
              Positioned(
                top: -10,
                right: -10,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
                trailing: IconButton(
                  onPressed: () {
                    showQrPopup(context, file['download_code']);
                  },
                  icon: Icon(Icons.qr_code),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
