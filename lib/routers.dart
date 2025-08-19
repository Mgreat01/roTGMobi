import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/cours_page.dart';
import 'pages/exercices_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/cours':
        return MaterialPageRoute(builder: (_) => const CoursPage());
      case '/exercices':
        return MaterialPageRoute(builder: (_) => const ExercicesPage());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
