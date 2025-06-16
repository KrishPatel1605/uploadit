import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Couldn't access storage")));
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Downloads")),
      body:
          files.isEmpty
              ? const Center(child: Text("No download files found"))
              : ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];
                  final filename = file.path.split('/').last;

                  return ListTile(
                    title: Text(filename),
                    trailing: IconButton(
                      onPressed: () {
                        OpenFile.open(file.path);
                      },
                      icon: const Icon(Icons.open_in_new),
                    ),
                  );
                },
              ),
    );
  }
}
