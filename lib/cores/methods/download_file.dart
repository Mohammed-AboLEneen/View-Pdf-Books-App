import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

Future<File?> downloadFile(
    {required String url, required String filename}) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$filename';
  final File file = File(filePath);

  if (!await file.exists()) {
    final HttpClient httpClient = HttpClient();
    final HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    final HttpClientResponse response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      final List<int> bytes =
          await consolidateHttpClientResponseBytes(response);
      await file.writeAsBytes(bytes);
      return file;
    } else {
      throw Exception('Failed to download file');
    }
  }
  return null;
}
