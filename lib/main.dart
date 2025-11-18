import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/calculator_viewmodel.dart';
import 'views/home_view.dart';
import 'views/graph_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CalculatorViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeView(),
      routes: {"/graph": (context) => const GraphView()},
    );
  }
}
