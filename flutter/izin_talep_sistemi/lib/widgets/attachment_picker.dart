import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/leave_request_attachment.dart';
import 'package:izin_talep_sistemi/providers/leave_request_attachment_service_provider.dart';

import 'package:izin_talep_sistemi/theme/theme_extensions.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class AttachmentPicker extends ConsumerStatefulWidget {
  final int leaveRequestId;
  const AttachmentPicker({super.key, required this.leaveRequestId});

  @override
  ConsumerState<AttachmentPicker> createState() => _AttachmentPickerState();
}

class _AttachmentPickerState extends ConsumerState<AttachmentPicker> {
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

  Future<void> _pickAndUpload() async {
    const typeGroup = XTypeGroup(
      label: 'documents',
      extensions: ['pdf', 'doc', 'docx'],
    );

    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;

    setState(() => _loading = true);
    try {
      final service = ref.read(leaveRequestAttachmentServiceProvider);
      await service.upload(widget.leaveRequestId, file);
      await _load();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Spacer(),
            TextButton.icon(
              onPressed: _loading ? null : _pickAndUpload,
              icon: const Icon(Icons.attach_file, size: 18),
              label: const Text('Dosya Ekle'),
            ),
          ],
        ),
        if (_error != null)
          Text(
            _error!,
            style: TextStyle(color: context.colors.error, fontSize: 12),
          ),
        if (_loading) const LinearProgressIndicator(),
        ..._attachments.map(
          (a) => ListTile(
            dense: true,
            leading: const Icon(Icons.picture_as_pdf_outlined, size: 20),
            title: Text(a.fileName, overflow: TextOverflow.ellipsis),
            onTap: () async {
              try {
                final service = ref.read(leaveRequestAttachmentServiceProvider);

                final dir = await getApplicationDocumentsDirectory();
                final savePath = '${dir.path}/${a.id}_${a.fileName}';

                await service.downloadToFile(a.id, savePath);

                await OpenFilex.open(savePath);
              } catch (e) {
                if (mounted) setState(() => _error = e.toString());
              }
            },
          ),
        ),
      ],
    );
  }
}
