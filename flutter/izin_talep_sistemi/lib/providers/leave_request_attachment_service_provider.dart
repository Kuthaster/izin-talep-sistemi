import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/dio_provider.dart';
import 'package:izin_talep_sistemi/services/leave_request_attachment_service.dart';

final leaveRequestAttachmentServiceProvider =
    Provider<LeaveRequestAttachmentService>((ref) {
      return LeaveRequestAttachmentService(dio: ref.watch(dioProvider));
    });
