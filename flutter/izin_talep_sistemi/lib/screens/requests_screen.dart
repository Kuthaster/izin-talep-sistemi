import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/widgets/create_request_form.dart';
import 'package:izin_talep_sistemi/widgets/leave_request_list.dart';

import '../providers/leave_request_provider.dart';

class RequestsScreen extends ConsumerWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, //başlık merkezleme
        title: const Text('İzin Taleplerim'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(leaveRequestsProvider),
          ), //sayfa yenileme appbarda
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Expanded(child: LeaveRequestList()), //liste
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          backgroundColor: Theme.of(context).colorScheme.surface,
          context: context,
          isScrollControlled: true,
          builder: (context) => const CreateRequestForm(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
