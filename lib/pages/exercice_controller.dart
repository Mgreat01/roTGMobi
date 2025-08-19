import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modèle d’un Sommet
class Sommet {
  final int id;
  final double x;
  final double y;

  Sommet({required this.id, required this.x, required this.y});
}

/// Modèle d’une Arête
class Arete {
  final int source;
  final int destination;

  Arete({required this.source, required this.destination});
}

/// État : contient tous les sommets et arêtes
class ExercicesState {
  final List<Sommet> sommets;
  final List<Arete> aretes;

  ExercicesState({
    this.sommets = const [],
    this.aretes = const [],
  });

  ExercicesState copyWith({
    List<Sommet>? sommets,
    List<Arete>? aretes,
  }) {
    return ExercicesState(
      sommets: sommets ?? this.sommets,
      aretes: aretes ?? this.aretes,
    );
  }
}

/// Contrôleur (Notifier)
class ExercicesController extends StateNotifier<ExercicesState> {
  ExercicesController() : super(ExercicesState());

  /// Ajouter un sommet
  void ajouterSommet() {
    final newSommet = Sommet(
      id: state.sommets.length,
      x: 50 + (state.sommets.length * 40).toDouble(),
      y: 100,
    );
    state = state.copyWith(sommets: [...state.sommets, newSommet]);
  }

  /// Ajouter une arête entre 2 sommets
  void ajouterArete(int source, int destination) {
    final newArete = Arete(source: source, destination: destination);
    state = state.copyWith(aretes: [...state.aretes, newArete]);
  }

  /// Reset
  void reset() {
    state = ExercicesState();
  }
}

/// 👉 Provider global
final exercicesProvider =
StateNotifierProvider<ExercicesController, ExercicesState>(
      (ref) => ExercicesController(),
);
