import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AdminAppBarState {
  final String title;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final List<Widget>? additionalActions;
  final ValueChanged<String>? onSearchChanged;
  final String searchQuery;

  const AdminAppBarState({
    required this.title,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.additionalActions,
    this.onSearchChanged,
    this.searchQuery = '',
  });

  AdminAppBarState copyWith({
    String? title,
    String? primaryActionLabel,
    VoidCallback? onPrimaryAction,
    List<Widget>? additionalActions,
    TextEditingController? searchController,
    ValueChanged<String>? onSearchChanged,
    String? searchQuery,
  }) {
    return AdminAppBarState(
      title: title ?? this.title,
      primaryActionLabel: primaryActionLabel ?? this.primaryActionLabel,
      onPrimaryAction: onPrimaryAction ?? this.onPrimaryAction,
      additionalActions: additionalActions ?? this.additionalActions,
      onSearchChanged: onSearchChanged ?? this.onSearchChanged,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class AdminAppBarNotifier extends StateNotifier<AdminAppBarState> {
  AdminAppBarNotifier() : super(const AdminAppBarState(title: 'Admin Panel'));

  void updateAppBar({
    required String title,
    String? primaryActionLabel,
    VoidCallback? onPrimaryAction,
    List<Widget>? additionalActions,
    TextEditingController? searchController,
    ValueChanged<String>? onSearchChanged,
    String? searchQuery,
  }) {
    state = state.copyWith(
      title: title,
      primaryActionLabel: primaryActionLabel,
      onPrimaryAction: onPrimaryAction,
      additionalActions: additionalActions,
      onSearchChanged: onSearchChanged,
      searchQuery: '',
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void reset() {
    state = const AdminAppBarState(title: 'Admin Panel');
  }
}

final adminAppBarProvider =
    StateNotifierProvider<AdminAppBarNotifier, AdminAppBarState>(
      (ref) => AdminAppBarNotifier(),
    );
