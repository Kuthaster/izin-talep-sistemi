import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

void openBytesAsFile(List<int> bytes, String fileName) {
  final extension = fileName.toLowerCase().split('.').last;

  final String mimeType;

  switch (extension) {
    case 'pdf':
      mimeType = 'application/pdf';
      break;
    case 'doc':
      mimeType = 'application/msword';
      break;
    case 'docx':
      mimeType =
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      break;
    default:
      mimeType = 'application/octet-stream';
  }

  final jsBytes = Uint8List.fromList(bytes).toJS;

  final blob = web.Blob([jsBytes].toJS, web.BlobPropertyBag(type: mimeType));

  final url = web.URL.createObjectURL(blob);

  if (extension == 'pdf') {
    // Open PDFs in a new browser tab.
    web.window.open(url, '_blank');

    Future.delayed(const Duration(minutes: 1), () {
      web.URL.revokeObjectURL(url);
    });
  } else {
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = url
      ..download = fileName;

    web.document.body?.append(anchor);
    anchor.click();
    anchor.remove();

    web.URL.revokeObjectURL(url);
  }
}
