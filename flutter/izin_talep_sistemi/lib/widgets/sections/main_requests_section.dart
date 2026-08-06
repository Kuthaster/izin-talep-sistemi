import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/widgets/leave_request_list.dart';

class MainRequestsSection extends ConsumerWidget {
  const MainRequestsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Expanded(child: LeaveRequestList())],
    );
  }
}
