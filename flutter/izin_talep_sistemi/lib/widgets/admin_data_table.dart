import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/admin_appbar_provider.dart';

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
    this.itemsPerPage = 10,
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

class _AdminDataSource<T> extends DataTableSource {
  final List<T> items;
  final List<DataCell> Function(T) buildCells;

  _AdminDataSource({required this.items, required this.buildCells});

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index >= items.length) return null;
    final item = items[index];
    return DataRow(cells: buildCells(item));
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  int get selectedRowCount => 0;
}

class _AdminDataTableState<T> extends ConsumerState<AdminDataTable<T>> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

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

  @override
  Widget build(BuildContext context) {
    final appBarState = ref.watch(adminAppBarProvider);
    final String currentSearchQuery = appBarState.searchQuery;

    final data = _filteredSortedItems(currentSearchQuery);

    if (data.isEmpty) return _buildEmptyState();

    final columns = widget.columnLabels.asMap().entries.map((entry) {
      final label = entry.value;
      return DataColumn(
        label: Text(label),
        onSort: (columnIndex, ascending) {
          setState(() {
            _sortColumnIndex = columnIndex;
            _sortAscending = ascending;
          });
        },
      );
    }).toList();

    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardThemeData(
          color: Theme.of(context).colorScheme.surface,
        ), //TODO buraya bak renk
      ),
      child: PaginatedDataTable(
        rowsPerPage: widget.itemsPerPage,
        showFirstLastButtons: true,
        showEmptyRows: false,
        showCheckboxColumn: true,
        header: Text("test"),
        columns: columns,
        source: _AdminDataSource<T>(items: data, buildCells: widget.buildCells),
        sortColumnIndex: _sortColumnIndex,
        columnSpacing: widget.dataSpacing ?? 40,
        sortAscending: _sortAscending,
        dataRowMaxHeight: 40,
        dataRowMinHeight: 30,
        dividerThickness: 0.4,
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
            color: Colors.grey[400],
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
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
          if (widget.onEmptyStateAction != null) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: widget.onEmptyStateAction,
              child: Text(widget.emptyStateActionLabel ?? 'Yeni oluştur'),
            ),
          ],
        ],
      ),
    );
  }
}
