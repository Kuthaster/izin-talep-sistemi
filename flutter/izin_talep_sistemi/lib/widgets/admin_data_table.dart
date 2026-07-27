import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminDataTable<T> extends ConsumerStatefulWidget {
  final List<T> items;
  final List<DataColumn> columns;
  final List<DataRow> Function(List<T>) buildRows;
  // final List<int Function(T, T)>? sortComparators;
  final int itemsPerPage;
  final bool showPagination;
  final String? emptyStateTitle;
  final String? emptyStateMessage;
  final VoidCallback? onEmptyStateAction;
  final String? emptyStateActionLabel;

  const AdminDataTable({
    super.key,
    required this.items,
    required this.columns,
    required this.buildRows,
    /* required this.sortComparators,*/ this.itemsPerPage = 10,
    this.showPagination = true,
    this.emptyStateTitle,
    this.emptyStateMessage,
    this.onEmptyStateAction,
    this.emptyStateActionLabel,
  });

  @override
  ConsumerState<AdminDataTable<T>> createState() => _AdminDataTableState<T>();
}

class _AdminDataTableState<T> extends ConsumerState<AdminDataTable<T>> {
  int _currentPage = 0;
  final int _sortColumnIndex = 0;
  final bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    final startIndex = _currentPage * widget.itemsPerPage;
    final endIndex = (startIndex + widget.itemsPerPage).clamp(
      0,
      widget.items.length,
    );
    final pageItems = widget.items.sublist(startIndex, endIndex);
    final rows = widget.buildRows(pageItems);

    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DataTable(
                  columns: widget.columns,
                  rows: rows,
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  columnSpacing: 24,
                  dataRowMinHeight: 69,
                  dataRowMaxHeight: 70,
                  headingRowHeight: 65,
                  headingRowColor: WidgetStateColor.resolveWith(
                    (states) => Colors.grey[100]!,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.showPagination) _buildPagination(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 18),
          Text(
            widget.emptyStateTitle ?? 'No data',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
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
              child: Text(widget.emptyStateActionLabel ?? 'Create new'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPagination() {
    final totalPages = (widget.items.length / widget.itemsPerPage).ceil();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Page ${_currentPage + 1} of $totalPages',
            style: TextStyle(color: Colors.grey[600]),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _currentPage > 0
                    ? () => setState(() => _currentPage--)
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _currentPage < totalPages - 1
                    ? () => setState(() => _currentPage++)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
