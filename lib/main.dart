import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

// Pages
import 'pages/home_page.dart';
import 'pages/cours_page.dart';
import 'pages/exercices_page.dart';

// Services
import 'framework/services/graph_service_impl.dart';
import 'business/services/graph_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<GraphService>(() => GraphServiceImpl());
}

void main() {
  setupLocator(); // registre les services
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recherche Opérationnelle & Graphes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/cours': (context) => const CoursPage(),
        '/exercices': (context) => const ExercicesPage(),
      },
    );
  }
}
