import 'package:flutter/material.dart';
import 'package:uploadit/utils/download_helper.dart';
import 'package:uploadit/utils/routes.dart';
import 'package:uploadit/widgets/success_popup.dart';

class DownloadByCodePage extends StatefulWidget {
  const DownloadByCodePage({super.key});

  @override
  State<DownloadByCodePage> createState() => _DownloadByCodePageState();
}

class _DownloadByCodePageState extends State<DownloadByCodePage> {
  final _codeController = TextEditingController();

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
              onPressed: () async {
                final code = _codeController.text;
                downloadFileByCode(context, code);
                await showSuccessPopup(
                  context: context,
                  title: 'Download complete!',
                  message: 'Your file has been successfully downloaded.',
                  autoCloseDuration: const Duration(seconds: 2),
                  onClose: () {
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.myDownloadsRoute,
                    );
                  },
                );
              },
              child: const Text("Download"),
            ),
          ],
        ),
      ),
    );
  }
}
