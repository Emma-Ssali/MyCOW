import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/cow.dart';
import 'screens/cow_list_screen.dart';

late Isar isar;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open([CowSchema], directory: dir.path);

  runApp(const FarmApp());
}

class FarmApp extends StatelessWidget {
  const FarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const CowListScreen(),
    );
  }
}

///  class HomeScreen extends StatelessWidget {
///    const HomeScreen({super.key});
///  
///    @override
///    Widget build(BuildContext context) {
///      return Scaffold(
///        appBar: AppBar(title: const Text('Farm Manager')),
///        body: const Center(
///          child: Text(
///            'Farm App Starting Point 🐄',
///            style: TextStyle(fontSize: 18),
///          ),
///        ),
///        floatingActionButton: FloatingActionButton(
///          onPressed: () async {
///            final saved = await Navigator.push<bool>(
///              context,
///              MaterialPageRoute(builder: (context) => const AddCowScreen()),
///            );
///            if (saved == true) {
///              // We'll use this in the next step to refresh a cow list
///            }
///          },
///          child: const Icon(Icons.add),
///        ),
///      );
///    }
///  }
