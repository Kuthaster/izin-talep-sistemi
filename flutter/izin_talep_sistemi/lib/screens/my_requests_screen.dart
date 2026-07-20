
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/widgets/leave_request_list.dart';

import '../providers/leave_request_provider.dart';
import 'package:izin_talep_sistemi/widgets/create_request_form.dart';

class MyRequestsScreen extends ConsumerWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
  return Scaffold(
      appBar: AppBar(
      title: const Text('İzin Taleplerim'),
      actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(myLeaveRequestsProvider),
          ),
        ],
      ),
      body: Column(
        children: const [
          Expanded(
            child: LeaveRequestList()),
      ],
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => const CreateRequestForm(),
      ),
      child: const Icon(Icons.add),
    ),
    );
  }
}