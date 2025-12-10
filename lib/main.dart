import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'presentation/dashboard/dashboard_page.dart';
import 'presentation/cart/bloc/cart_bloc.dart';
import 'presentation/cart/bloc/cart_event.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator(); // Initialize GetIt
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider allows us to inject multiple Blocs into the tree.
    return MultiBlocProvider(
      providers: [
        // GLOBAL BLOC:
        // We inject the CartBloc here. 'create' is called once when the app starts.
        // We immediately add 'CartStarted' to fetch any existing items (if we had local storage).
        BlocProvider<CartBloc>(
          create: (context) => sl<CartBloc>()..add(CartStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Shopeasy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          // Design Decision: Define global styles here to avoid cluttering widgets
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        home: const DashboardPage()
      ),
    );
  }
}