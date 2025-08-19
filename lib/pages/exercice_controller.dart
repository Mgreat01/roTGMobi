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
  final Sommet? selectedSommet;

  ExercicesState({
    this.sommets = const [],
    this.aretes = const [],
    this.selectedSommet,
  });

  ExercicesState copyWith({
    List<Sommet>? sommets,
    List<Arete>? aretes,
    Sommet? selectedSommet,
  }) {
    return ExercicesState(
      sommets: sommets ?? this.sommets,
      aretes: aretes ?? this.aretes,
      selectedSommet: selectedSommet,
    );
  }
}

/// Contrôleur (Notifier)
class ExercicesController extends StateNotifier<ExercicesState> {
  ExercicesController() : super(ExercicesState());

  /// Ajouter un sommet à une position donnée
  void ajouterSommet(double x, double y) {
    final newSommet = Sommet(
      id: state.sommets.length,
      x: x,
      y: y,
    );
    state = state.copyWith(sommets: [...state.sommets, newSommet]);
  }

  /// Gérer la sélection pour créer des arêtes
  void selectSommet(Sommet s) {
    if (state.selectedSommet == null) {
      state = state.copyWith(selectedSommet: s);
    } else if (state.selectedSommet!.id != s.id) {
      ajouterArete(state.selectedSommet!.id, s.id);
      state = state.copyWith(selectedSommet: null);
    } else {
      state = state.copyWith(selectedSommet: null);
    }
  }

  /// Ajouter une arête entre 2 sommets par id
  void ajouterArete(int source, int destination) {
    final newArete = Arete(source: source, destination: destination);
    state = state.copyWith(aretes: [...state.aretes, newArete]);
  }

  /// Reset complet
  void reset() {
    state = ExercicesState();
  }
}

/// Provider global
final exercicesProvider =
StateNotifierProvider<ExercicesController, ExercicesState>(
      (ref) => ExercicesController(),
);
