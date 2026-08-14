import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class AdminAppBarState {
  final String title;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final List<Widget>? additionalActions;
  final ValueChanged<String>? onSearchChanged;
  final String searchQuery;
  final bool hasSearch;

  const AdminAppBarState({
    required this.title,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.additionalActions,
    this.onSearchChanged,
    this.searchQuery = '',
    this.hasSearch = false,
  });

  AdminAppBarState copyWith({
    String? title,
    String? primaryActionLabel,
    VoidCallback? onPrimaryAction,
    List<Widget>? additionalActions,
    TextEditingController? searchController,
    ValueChanged<String>? onSearchChanged,
    String? searchQuery,
    bool? hasSearch,
  }) {
    return AdminAppBarState(
      title: title ?? this.title,
      primaryActionLabel: primaryActionLabel ?? this.primaryActionLabel,
      onPrimaryAction: onPrimaryAction ?? this.onPrimaryAction,
      additionalActions: additionalActions ?? this.additionalActions,
      onSearchChanged: onSearchChanged ?? this.onSearchChanged,
      searchQuery: searchQuery ?? this.searchQuery,
      hasSearch: hasSearch ?? this.hasSearch,
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
    ValueChanged<String>? onSearchChanged,
    bool hasSearch = false,
  }) {
    state = AdminAppBarState(
      title: title,
      primaryActionLabel: primaryActionLabel,
      onPrimaryAction: onPrimaryAction,
      additionalActions: additionalActions,
      onSearchChanged: onSearchChanged,
      searchQuery: '',
      hasSearch: hasSearch,
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final adminAppBarProvider =
    StateNotifierProvider<AdminAppBarNotifier, AdminAppBarState>(
      (ref) => AdminAppBarNotifier(),
    );
