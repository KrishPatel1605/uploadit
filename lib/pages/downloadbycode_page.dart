import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DownloadByCodePage extends StatefulWidget {
  const DownloadByCodePage({super.key});
  
  @override
  State<DownloadByCodePage> createState() => _DownloadByCodePageState();
}

class _DownloadByCodePageState extends State<DownloadByCodePage> {
  final _codeController = TextEditingController();
  final _supabase = Supabase.instance.client;

  void downloadFile() async {
    final code = _codeController.text.trim();

    try {
      final res =
          await _supabase
              .from('files')
              .select()
              .eq('download_code', code)
              .single();

      if (res == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Invalid code")));
        return;
      }

      final filePath = res['file_path'];
      final fileName = res['original_name'];

      final Uint8List fileBytes = await _supabase.storage
          .from('uploadit')
          .download(filePath);

      final externalDir = await getExternalStorageDirectory();
      if (externalDir==null) {
        throw Exception("Could not access external directory");
      }

      final targetDir = Directory('${externalDir.path}/Downloads');
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      final localFile = File('${targetDir.path}/$fileName');
      await localFile.writeAsBytes(fileBytes);

      await OpenFile.open(localFile.path);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Download failed : $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Download File")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: "Enter Code"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: downloadFile,
              child: const Text("Download"),
            ),
          ],
        ),
      ),
    );
  }
}
