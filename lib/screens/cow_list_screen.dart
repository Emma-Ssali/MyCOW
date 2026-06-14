import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/cow.dart';
import 'add_cow_screen.dart';
import 'cow_detail_screen.dart';

/// Displays the list of all cows with search and filter capabilities.
class CowListScreen extends StatefulWidget {
  const CowListScreen({super.key});

  @override
  State<CowListScreen> createState() => _CowListScreenState();
}

class _CowListScreenState extends State<CowListScreen> {
  // All cows loaded from Isar — never modified after loading.
  List<Cow> _allCows = [];

  // Filtered/searched subset shown in the list.
  List<Cow> _filteredCows = [];

  bool _loading = true;

  // Search controller — listens to text input changes.
  final _searchController = TextEditingController();

  // Currently selected status filter — null means "All".
  CowStatus? _selectedStatus;

  // Currently selected tag filter.
  // 'all' | 'tagged' | 'untagged'
  String _tagFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadCows();

    // Re-run filter every time the search text changes.
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Loads all cows from Isar, then applies current filters.
  Future<void> _loadCows() async {
    setState(() => _loading = true);

    final cows = await isar.cows
        .where()
        .sortByUpdatedAtDesc()
        .findAll();

    setState(() {
      _allCows = cows;
      _loading = false;
    });

    _applyFilters();
  }

  /// Applies search text + status filter + tag filter to _allCows
  /// and updates _filteredCows for the UI to display.
  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();

    setState(() {
      _filteredCows = _allCows.where((cow) {
        // Search filter — matches tag number (case-insensitive).
        final matchesSearch = query.isEmpty ||
            cow.tagNumber.toLowerCase().contains(query);

        // Status filter — null means show all statuses.
        final matchesStatus =
            _selectedStatus == null || cow.status == _selectedStatus;

        // Tag filter.
        final matchesTag = _tagFilter == 'all' ||
            (_tagFilter == 'tagged' && cow.tagNumber.isNotEmpty) ||
            (_tagFilter == 'untagged' && cow.tagNumber.isEmpty);

        return matchesSearch && matchesStatus && matchesTag;
      }).toList();
    });
  }

  /// Clears all active filters and search text.
  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedStatus = null;
      _tagFilter = 'all';
    });
    _applyFilters();
  }

  Future<void> _deleteCow(Cow cow) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete cow?'),
        content: Text(
          'Remove cow with tag "${cow.tagNumber}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await isar.writeTxn(() async {
        await isar.cows.delete(cow.id);
      });
      _loadCows();
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _statusColor(CowStatus status) {
    switch (status) {
      case CowStatus.active:
        return Colors.green;
      case CowStatus.sold:
        return Colors.blue;
      case CowStatus.dead:
        return Colors.grey;
      case CowStatus.missing:
        return Colors.orange;
    }
  }

  /// Builds the search bar at the top of the list.
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by tag number...',
          prefixIcon: const Icon(Icons.search),
          // Show a clear button when there is text.
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _applyFilters();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  /// Builds the row of filter chips below the search bar.
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Row(
        children: [
          // Tag filter chips.
          _tagChip('All', 'all'),
          const SizedBox(width: 6),
          _tagChip('Tagged', 'tagged'),
          const SizedBox(width: 6),
          _tagChip('Untagged', 'untagged'),
          const SizedBox(width: 12),

          // Divider between tag and status filters.
          Container(width: 1, height: 24, color: Colors.grey.shade300),
          const SizedBox(width: 12),

          // Status filter chips — one per CowStatus value.
          ...CowStatus.values.map((status) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(
                    status.name[0].toUpperCase() + status.name.substring(1),
                  ),
                  selected: _selectedStatus == status,
                  onSelected: (selected) {
                    setState(() {
                      // Tapping the active status chip again deselects it.
                      _selectedStatus = selected ? status : null;
                    });
                    _applyFilters();
                  },
                  selectedColor: _statusColor(status).withValues(alpha: 0.2),
                  checkmarkColor: _statusColor(status),
                ),
              )),

          // Clear all filters button — only shown when filters are active.
          if (_selectedStatus != null || _tagFilter != 'all' ||
              _searchController.text.isNotEmpty) ...[
            const SizedBox(width: 6),
            ActionChip(
              label: const Text('Clear'),
              avatar: const Icon(Icons.close, size: 16),
              onPressed: _clearFilters,
            ),
          ],
        ],
      ),
    );
  }

  /// A single tag filter chip (All / Tagged / Untagged).
  Widget _tagChip(String label, String value) {
    final isSelected = _tagFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _tagFilter = value);
        _applyFilters();
      },
      selectedColor: Colors.green.withValues(alpha: 0.2),
      checkmarkColor: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if any filter is currently active — used for the results count.
    final filtersActive = _selectedStatus != null ||
        _tagFilter != 'all' ||
        _searchController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cows'),
        // Show total cow count in the app bar.
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_allCows.length} total',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search bar.
                _buildSearchBar(),

                // Filter chips row.
                _buildFilterChips(),

                // Results count — only shown when a filter is active.
                if (filtersActive)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                    child: Row(
                      children: [
                        Text(
                          '${_filteredCows.length} result${_filteredCows.length == 1 ? '' : 's'}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Cow list or empty state.
                Expanded(
                  child: _filteredCows.isEmpty
                      ? Center(
                          child: Text(
                            filtersActive
                                ? 'No cows match your search.'
                                : 'No cows yet.\nTap + to add your first cow.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadCows,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                            itemCount: _filteredCows.length,
                            itemBuilder: (context, index) {
                              final cow = _filteredCows[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  onTap: () async {
                                    final updated = await Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CowDetailScreen(cow: cow),
                                      ),
                                    );
                                    if (updated == true) {
                                      _loadCows();
                                    }
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: _statusColor(cow.status)
                                        .withValues(alpha: 0.15),
                                    child: Text(
                                      cow.tagNumber.isNotEmpty
                                          ? cow.tagNumber
                                              .substring(0, 1)
                                              .toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                          color: _statusColor(cow.status)),
                                    ),
                                  ),
                                  title: Text(
                                    'Tag: ${cow.tagNumber}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    '${cow.breed} · ${cow.sex == CowSex.female ? 'Female' : 'Male'} · '
                                    '${cow.status.name[0].toUpperCase()}${cow.status.name.substring(1)}\n'
                                    'Acquired: ${_formatDate(cow.acquisitionDate)}',
                                  ),
                                  isThreeLine: true,
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _deleteCow(cow),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => const AddCowScreen()),
          );
          if (saved == true) {
            _loadCows();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}