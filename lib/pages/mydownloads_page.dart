import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MyDownloadsPage extends StatefulWidget {
  const MyDownloadsPage({super.key});

  @override
  State<MyDownloadsPage> createState() => _MyDownloadsPageState();
}

class _MyDownloadsPageState extends State<MyDownloadsPage> {
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();
    loadDownloads();
  }

  Future<void> loadDownloads() async {
    final externalDir = await getExternalStorageDirectory();
    if (externalDir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't access storage")),
      );
      return;
    }

    final downloadDir = Directory('${externalDir.path}/Downloads');
    if (await downloadDir.exists()) {
      final allFiles = downloadDir.listSync();
      setState(() {
        files = allFiles.whereType<File>().toList();
      });
    } else {
      await downloadDir.create(recursive: true);
    }
  }

  Future<void> showFileOptions(File file) async {
    final fileName = file.path.split('/').last;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: const Text('Open'),
              onTap: () {
                Navigator.pop(context);
                OpenFile.open(file.path);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename'),
              onTap: () async {
                Navigator.pop(context);
                final newName = await promptRename(fileName);
                if (newName != null && newName.trim().isNotEmpty) {
                  final newPath = file.parent.path + '/$newName';
                  await file.rename(newPath);
                  await loadDownloads();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                Share.shareXFiles([XFile(file.path)], text: 'Sharing $fileName');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () async {
                Navigator.pop(context);
                await file.delete();
                await loadDownloads();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> promptRename(String oldName) async {
    final controller = TextEditingController(text: oldName);

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
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
    return Scaffold(
      appBar: AppBar(title: const Text("My Downloads")),
      body: files.isEmpty
          ? const Center(child: Text("No downloaded files found"))
          : ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                final filename = file.path.split('/').last;

                return ListTile(
                  title: Text(filename),
                  onTap: () => OpenFile.open(file.path),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => showFileOptions(file as File),
                  ),
                );
              },
            ),
    );
  }
}
