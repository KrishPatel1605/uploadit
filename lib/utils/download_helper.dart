import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> downloadFileByCode(BuildContext context, String code) async {
  final supabase = Supabase.instance.client;

  try {
    final res =
        await supabase
            .from('files')
            .select()
            .eq('download_code', code.trim())
            .single();

    if (res == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid code")));
      return;
    }

    final filePath = res['file_path'];
    final fileName = res['original_name'];

    final Uint8List fileBytes = await supabase.storage
        .from('uploadit')
        .download(filePath);

    final externalDir = await getExternalStorageDirectory();
    if (externalDir == null) {
      throw Exception("Could not access external directory");
    }
    print('External dir: ${externalDir?.path}');

    final targetDir = Directory('${externalDir.path}/Downloads');
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final localFile = File('${targetDir.path}/$fileName');
    print('Writing to: ${localFile.path}');
    await localFile.writeAsBytes(fileBytes);
    print('File written successfully');

    await OpenFile.open(localFile.path);
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Download failed: $e")));
  }
}
