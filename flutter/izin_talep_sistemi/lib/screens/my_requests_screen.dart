
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'dart:core';
import '../providers/leave_request_provider.dart';

class MyRequestsScreen extends ConsumerWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
  final asyncRequests = ref.watch(myLeaveRequestsProvider);
  
  return Scaffold(
      appBar: AppBar(
      title: const Text('İzin Taleplerim'),
      actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(myLeaveRequestsProvider),
          ),
        ],),
      body: asyncRequests.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
        data: (requests) => RefreshIndicator(
          onRefresh: () => ref.refresh(myLeaveRequestsProvider.future),
            child: ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return ListTile(
              title: Text(request.leaveTypeName),
                subtitle: Text('${request.status} — Level ${request.currentLevel}'),
              );
            }, //ItemBuilder
          ),
       ),
      ),
    );
  }
  }