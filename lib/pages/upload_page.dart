import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path/path.dart' as p;

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _supabase = Supabase.instance.client;
  String? _downloadCode;

  void pickAndUploadFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    final file = File(result.files.single.path!);
    final fileName = result.files.single.name;
    final uploaderEmail = _supabase.auth.currentUser?.email;
    final uuid = const Uuid().v4();
    final extension = p.extension(fileName);
    final storagePath = 'uploads/$uuid$extension';
    final downloadCode = uuid.substring(0, 6); // 6-character code

    try {
      await _supabase.storage.from('uploadit').upload(storagePath, file);

      await _supabase.from('files').insert({
        'uploader_email': uploaderEmail,
        'file_path': storagePath,
        'original_name': fileName,
        'download_code': downloadCode,
      });

      setState(() {
        _downloadCode = downloadCode;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload File")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickAndUploadFile,
              child: const Text("Pick and Upload File"),
            ),
            if (_downloadCode != null) ...[
              const SizedBox(height: 24),
              Text("Share this code to download: $_downloadCode"),
              QrImageView(data: _downloadCode!, size: 180),
            ],
          ],
        ),
      ),
    );
  }
}
