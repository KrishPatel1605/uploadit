import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uploadit/utils/download_helper.dart';
import 'package:uploadit/utils/routes.dart';
import 'package:uploadit/widgets/success_popup.dart';

class DownloadByQRPage extends StatefulWidget {
  const DownloadByQRPage({super.key});

  @override
  State<DownloadByQRPage> createState() => _DownloadByQRPageState();
}

class _DownloadByQRPageState extends State<DownloadByQRPage> {
  bool _hasScanned = false;

  void _onDetect(BarcodeCapture capture) async {
    if (_hasScanned) return;
    final String? code = capture.barcodes.first.rawValue;

    if (code != null && code.isNotEmpty) {
      _hasScanned = true;
      await downloadFileByCode(context, code);
      await showSuccessPopup(
        context: context,
        title: 'Download complete!',
        message: 'Your file has been successfully downloaded.',
        autoCloseDuration: const Duration(seconds: 2),
        onClose: () {
          Navigator.pushReplacementNamed(context, Routes.myDownloadsRoute);
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid QR code")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Download via QR Code')),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _onDetect,
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.normal,
              facing: CameraFacing.back,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black54,
              child: const Text(
                "Align the QR code within the camera view",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
