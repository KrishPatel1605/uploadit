import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uploadit/utils/routes.dart';
import 'package:uploadit/widgets/success_popup.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _supabase = Supabase.instance.client;
  String? _fileName;

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

      await showSuccessPopup(
        context: context,
        title: 'Upload complete!',
        message: 'Your file has been successfully uploaded.',
        autoCloseDuration: const Duration(seconds: 2),
        onClose: () {
          Navigator.pushReplacementNamed(context, Routes.myUploadsRoute);
        },
      );
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickAndUploadFile,
              child: DottedBorderBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.upload_file, size: 40, color: Colors.grey),
                    const SizedBox(height: 10),
                    const Text(
                      'Drag and drop your file here\nor click to select',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    if (_fileName != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Selected: $_fileName',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DottedBorderBox extends StatelessWidget {
  final Widget child;

  const DottedBorderBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: child),
    );
  }
}
