import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadDownloadCounts {
  final int uploads;
  final int downloads;
  const UploadDownloadCounts({required this.uploads, required this.downloads});
}

Future<UploadDownloadCounts> getCountsForCurrentUser() async {
  final client = Supabase.instance.client;
  final email = client.auth.currentUser?.email;
  if (email == null) return const UploadDownloadCounts(uploads: 0, downloads: 0);

  final uploadRows = await client.from('files').select('id').eq('uploader_email', email);
  final uploadCount = (uploadRows as List).length;

  final dir = await getExternalStorageDirectory();
  int downloadCount = 0;
  if (dir != null) {
    final dlDir = Directory('${dir.path}/Downloads');
    if (await dlDir.exists()) {
      downloadCount = dlDir.listSync().whereType<File>().length;
    }
  }

  return UploadDownloadCounts(uploads: uploadCount, downloads: downloadCount);
}
