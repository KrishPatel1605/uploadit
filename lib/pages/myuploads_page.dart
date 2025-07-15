import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uploadit/utils/download_helper.dart';

class MyUploadsPage extends StatefulWidget {
  const MyUploadsPage({super.key});

  @override
  State<MyUploadsPage> createState() => _MyUploadsPageState();
}

class _MyUploadsPageState extends State<MyUploadsPage> {
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

  Future<void> showFileOptions(file, supabase) async {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Download'),
                  onTap: () {
                    final code = file['download_code'];
                    Navigator.pop(context);
                    downloadFileByCode(context, code);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Rename'),
                  onTap: () async {
                    Navigator.pop(context);
                    final newName = await promptRename(file);
                    if (newName != null && newName.trim().isNotEmpty) {
                      try {
                        final id = file['id'];
                        await supabase
                            .from('files')
                            .update({'original_name': newName})
                            .eq('id', id);
                        if (mounted) setState(() {});
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share Code'),
                  onTap: () async {
                    Navigator.pop(context);
                    final code = file['download_code'];
                    await Share.share(
                      'Download code for "${file['original_name']}": $code',
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete'),
                  onTap: () async {
                    final path = file['file_path'];
                    final id = file['id'];
                    Navigator.pop(context);
                    try {
                      await supabase.storage.from('uploadit').remove(['$path']);
                      await supabase.from('files').delete().eq('id', id);
                      if (mounted) setState(() {});
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<String?> promptRename(file) async {
    final controller = TextEditingController(
      text: file['original_name'] as String,
    );

    return showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Rename File"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: "New file name"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: const Text("Rename"),
              ),
            ],
          ),
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
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final files = snapshot.data as List;

          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              return ListTile(
                title: Text(file['original_name']),
                subtitle: Text("Code: ${file['download_code']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showQrPopup(context, file['download_code']);
                      },
                      icon: Icon(Icons.qr_code),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () => showFileOptions(file, client),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
