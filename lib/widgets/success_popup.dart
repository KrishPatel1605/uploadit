import 'package:flutter/material.dart';

Future<void> showSuccessPopup({
  required BuildContext context,
  required String title,
  required String message,
  VoidCallback? onClose,
  Duration? autoCloseDuration,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Success'),
        ],
      ),
      content: Text('$title\n\n$message'),
    ),
  );

  if (autoCloseDuration != null) {
    await Future.delayed(autoCloseDuration);
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
      if (onClose != null) onClose();
    }
  }
}
