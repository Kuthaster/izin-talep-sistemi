import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/leave_request_attachment.dart';
import 'package:izin_talep_sistemi/providers/leave_request_attachment_service_provider.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';
import 'package:izin_talep_sistemi/ultilities/web_file_opener.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class AttachmentList extends ConsumerStatefulWidget {
  final int leaveRequestId;
  const AttachmentList({super.key, required this.leaveRequestId});

  @override
  ConsumerState<AttachmentList> createState() => _AttachmentListState();
}

class _AttachmentListState extends ConsumerState<AttachmentList> {
  List<LeaveRequestAttachment> _attachments = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final service = ref.read(leaveRequestAttachmentServiceProvider);
      _attachments = await service.getAttachments(widget.leaveRequestId);
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openAttachment(LeaveRequestAttachment a) async {
    try {
      final service = ref.read(leaveRequestAttachmentServiceProvider);

      if (kIsWeb) {
        final bytes = await service.downloadBytes(a.id);
        openBytesAsFile(bytes, a.fileName);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final savePath = '${dir.path}/${a.id}_${a.fileName}';
        await service.downloadToFile(a.id, savePath);
        final result = await OpenFilex.open(savePath);
        if (result.type != ResultType.done) {
          throw Exception(
            'Bu dosya türünü görüntüleyecek bir uygulama bulunamadı.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Dosya açılamadı: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LinearProgressIndicator();
    if (_error != null) {
      return Text(
        _error!,
        style: TextStyle(color: context.colors.error, fontSize: 12),
      );
    }
    if (_attachments.isEmpty) {
      return Text(
        'Ek bulunmuyor.',
        style: TextStyle(fontSize: 12, color: context.colors.onSurfaceVariant),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _attachments
          .map(
            (a) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.picture_as_pdf_outlined, size: 20),
              title: Text(
                a.fileName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
              onTap: () => _openAttachment(a),
            ),
          )
          .toList(),
    );
  }
}
