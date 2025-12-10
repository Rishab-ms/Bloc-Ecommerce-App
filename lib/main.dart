import 'package:flutter/material.dart';
import 'core/di/injection_container.dart'; // Import the DI setup

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize our dependencies (Repositories, Dio, etc.)
  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopeasy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // We will replace thi5s with our Dashboard page later
      home: const Scaffold(body: Center(child: Text("Part 2 Complete!"))),
    );
  }
}