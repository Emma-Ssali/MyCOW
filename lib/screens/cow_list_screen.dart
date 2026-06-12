import 'package:flutter/material.dart';
import '../main.dart';
import '../models/cow.dart';
import 'add_cow_screen.dart';

/// Displays the list of all cows stored in the local Isar database.
/// This is the home screen of the app — users can view, add, and
/// delete cow records from here.
class CowListScreen extends StatefulWidget {
  const CowListScreen({super.key});

  @override
  State<CowListScreen> createState() => _CowListScreenState();
}

class _CowListScreenState extends State<CowListScreen> {
  // Holds the cows currently loaded from the database.
  List<Cow> _cows = [];

  // Controls whether the loading spinner is shown.
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // Load cows from the database as soon as the screen is created.
    _loadCows();
  }

  /// Fetches all cows from Isar, sorted by most recently updated first,
  /// and refreshes the UI with the results.
  Future<void> _loadCows() async {
    setState(() => _loading = true);

    final cows = await isar.cows.where().sortByUpdatedAtDesc().findAll();

    setState(() {
      _cows = cows;
      _loading = false;
    });
  }

  /// Shows a confirmation dialog, and if the user confirms,
  /// permanently deletes the given cow from the database.
  Future<void> _deleteCow(Cow cow) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete cow?'),
        content: Text(
          'Remove cow with tag "${cow.tagNumber}"? This cannot be undone.',
        ),
        actions: [
          // Cancel — closes the dialog without deleting.
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          // Confirm — closes the dialog and signals deletion.
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    // Only delete if the user explicitly tapped "Delete".
    if (confirm == true) {
      await isar.writeTxn(() async {
        await isar.cows.delete(cow.id);
      });
      // Refresh the list so the deleted cow disappears immediately.
      _loadCows();
    }
  }

  /// Formats a DateTime as "day/month/year", or returns a dash
  /// if the date is null (e.g. date of birth not set).
  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Returns a color representing the cow's current status,
  /// used for the avatar background in the list.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cows')),

      // Body shows one of three states: loading, empty, or the cow list.
      body: _loading
          // 1. Still fetching data from Isar — show a spinner.
          ? const Center(child: CircularProgressIndicator())
          : _cows.isEmpty
              // 2. No cows saved yet — show a friendly placeholder message.
              ? const Center(
                  child: Text(
                    'No cows yet.\nTap + to add your first cow.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              // 3. We have cows — display them in a scrollable list.
              : RefreshIndicator(
                  // Lets the user pull-down to reload the list from the database.
                  onRefresh: _loadCows,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _cows.length,
                    itemBuilder: (context, index) {
                      final cow = _cows[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          // Circular avatar showing the first letter of the
                          // tag number, colored by the cow's status.
                          leading: CircleAvatar(
                            backgroundColor:
                                _statusColor(cow.status).withValues(alpha: 0.15),
                            child: Text(
                              cow.tagNumber.isNotEmpty
                                  ? cow.tagNumber.substring(0, 1).toUpperCase()
                                  : '?',
                              style: TextStyle(color: _statusColor(cow.status)),
                            ),
                          ),

                          // Main title: the cow's tag number.
                          title: Text(
                            'Tag: ${cow.tagNumber}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          // Subtitle: breed, sex, status, and acquisition date.
                          subtitle: Text(
                            '${cow.breed} · ${cow.sex == CowSex.female ? 'Female' : 'Male'} · '
                            '${cow.status.name[0].toUpperCase()}${cow.status.name.substring(1)}\n'
                            'Acquired: ${_formatDate(cow.acquisitionDate)}',
                          ),
                          isThreeLine: true,

                          // Delete button on the right of each row.
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _deleteCow(cow),
                          ),
                        ),
                      );
                    },
                  ),
                ),

      // Floating "+" button — opens the Add Cow form.
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => const AddCowScreen()),
          );

          // If the form reported a successful save, refresh the list
          // so the new cow appears immediately.
          if (saved == true) {
            _loadCows();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}