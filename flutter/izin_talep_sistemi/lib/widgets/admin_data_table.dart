import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/admin_appbar_provider.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';

class AdminDataTable<T> extends ConsumerStatefulWidget {
  final List<T> items;
  final List<String> columnLabels;
  final List<int Function(T, T)> sortComparators;
  final List<DataCell> Function(T) buildCells;
  final bool Function(T, String)? searchLabel;
  final int itemsPerPage;
  final bool showPagination;
  final String? emptyStateTitle;
  final String? emptyStateMessage;
  final VoidCallback? onEmptyStateAction;
  final String? emptyStateActionLabel;
  final double? dataSpacing;

  const AdminDataTable({
    super.key,
    required this.items,
    required this.columnLabels,
    required this.sortComparators,
    required this.buildCells,
    this.searchLabel,
    this.itemsPerPage = 15,
    this.showPagination = true,
    this.emptyStateTitle,
    this.emptyStateMessage,
    this.onEmptyStateAction,
    this.emptyStateActionLabel,
    this.dataSpacing,
  });

  @override
  ConsumerState<AdminDataTable<T>> createState() => _AdminDataTableState<T>();
}

class _AdminDataTableState<T> extends ConsumerState<AdminDataTable<T>> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  int _currentPage = 0;

  List<T> _filteredSortedItems(String searchQuery) {
    var filtered = widget.items;

    if (widget.searchLabel != null && searchQuery.trim().isNotEmpty) {
      filtered = filtered
          .where((item) => widget.searchLabel!(item, searchQuery.trim()))
          .toList();
    }

    if (filtered.isEmpty) return const [];

    final sorted = [...filtered];
    if (_sortColumnIndex < widget.sortComparators.length) {
      sorted.sort((a, b) {
        final result = widget.sortComparators[_sortColumnIndex](a, b);
        return _sortAscending ? result : -result;
      });
    }
    return sorted;
  }

  void _onSortTap(int columnIndex) {
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumnIndex = columnIndex;
        _sortAscending = true;
      }
      _currentPage = 0;
    });
  }

  int get _maxPage {
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final appBarState = ref.watch(adminAppBarProvider);
    final String currentSearchQuery = appBarState.searchQuery;

    final data = _filteredSortedItems(currentSearchQuery);

    if (data.isEmpty) return _buildEmptyState();

    final totalPages = widget.showPagination
        ? (data.length / widget.itemsPerPage).ceil()
        : 1;

    final safePage = _currentPage.clamp(
      0,
      totalPages - 1 < 0 ? 0 : totalPages - 1,
    );
    if (safePage != _currentPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _currentPage = safePage);
      });
    }

    final pageItems = widget.showPagination
        ? data
              .skip(safePage * widget.itemsPerPage)
              .take(widget.itemsPerPage)
              .toList()
        : data;

    final startIndex = widget.showPagination
        ? safePage * widget.itemsPerPage + 1
        : 1;
    final endIndex = widget.showPagination
        ? (safePage * widget.itemsPerPage + pageItems.length)
        : data.length;

    final columns = widget.columnLabels.asMap().entries.map((entry) {
      final index = entry.key;
      final label = entry.value;
      final isActive = _sortColumnIndex == index;
      final canSort = index < widget.sortComparators.length;

      return DataColumn(
        label: canSort
            ? InkWell(
                onTap: () => _onSortTap(index),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label),
                    if (isActive) ...[
                      const SizedBox(width: 4),
                      Icon(
                        _sortAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 16,
                        color: context.colors.onSurface,
                      ),
                    ],
                  ],
                ),
              )
            : Text(label),
      );
    }).toList();

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: widget.dataSpacing ?? 40,
                  dataRowMaxHeight: 36,
                  dataRowMinHeight: 24,
                  dividerThickness: 0.6,
                  showCheckboxColumn: true,
                  columns: columns,
                  rows: pageItems
                      .map((item) => DataRow(cells: widget.buildCells(item)))
                      .toList(),
                ),
              ),
            ),
          ),
          if (widget.showPagination) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '$startIndex–$endIndex of ${data.length}',
                    style: TextStyle(),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.first_page),
                    disabledColor: Theme.of(
                      context,
                    ).colorScheme.primaryFixedDim,
                    onPressed: safePage > 0
                        ? () => setState(() => _currentPage = 0)
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    disabledColor: Theme.of(
                      context,
                    ).colorScheme.primaryFixedDim,
                    onPressed: safePage > 0
                        ? () => setState(() => _currentPage = safePage - 1)
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    disabledColor: Theme.of(
                      context,
                    ).colorScheme.primaryFixedDim,
                    onPressed: safePage < totalPages - 1
                        ? () => setState(() => _currentPage = safePage + 1)
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.last_page),
                    disabledColor: Theme.of(
                      context,
                    ).colorScheme.primaryFixedDim,
                    onPressed: safePage < totalPages - 1
                        ? () => setState(() => _currentPage = totalPages - 1)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.indeterminate_check_box_sharp,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            widget.emptyStateTitle ?? 'Veri Yok',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          if (widget.emptyStateMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.emptyStateMessage!,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
          if (widget.onEmptyStateAction != null) ...[
            const SizedBox(height: 20),
            FilledButton(
              onPressed: widget.onEmptyStateAction,
              child: Text(widget.emptyStateActionLabel ?? 'Yeni oluştur'),
            ),
          ],
        ],
      ),
    );
  }
}
