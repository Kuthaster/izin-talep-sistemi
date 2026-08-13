import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/leave_request_attachment.dart';
import 'package:izin_talep_sistemi/providers/leave_request_attachment_service_provider.dart';

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
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result == null || result.files.single.path == null) return;

    setState(() => _loading = true);
    try {
      final service = ref.read(leaveRequestAttachmentServiceProvider);
      await service.upload(
        widget.leaveRequestId,
        result.files.single.path!,
        result.files.single.name,
      );
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
            const Text('Ekler', style: TextStyle(fontWeight: FontWeight.w600)),
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
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        if (_loading) const LinearProgressIndicator(),
        ..._attachments.map(
          (a) => ListTile(
            dense: true,
            leading: const Icon(Icons.picture_as_pdf_outlined, size: 20),
            title: Text(a.fileName, overflow: TextOverflow.ellipsis),
            onTap: () {
              // opens in browser (web) or requires a download+open flow on mobile
            },
          ),
        ),
      ],
    );
  }
}
