import 'package:flutter/material.dart';
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
  final double weight;

  Arete({required this.source, required this.destination, this.weight = 1});
}

/// État : contient tous les sommets et arêtes
class ExercicesState {
  final List<Sommet> sommets;
  final List<Arete> aretes;

  ExercicesState({this.sommets = const [], this.aretes = const []});

  ExercicesState copyWith({List<Sommet>? sommets, List<Arete>? aretes}) {
    return ExercicesState(
      sommets: sommets ?? this.sommets,
      aretes: aretes ?? this.aretes,
    );
  }
}

/// Modes d’interaction
enum Mode { none, addSommet, addArete }

/// Contrôleur
class ExercicesController extends StateNotifier<ExercicesState> {
  ExercicesController() : super(ExercicesState());

  Mode mode = Mode.none;
  Sommet? selectedSommetForArete;

  void setMode(Mode m) {
    mode = m;
    selectedSommetForArete = null;
  }

  void addSommetAt(Offset position) {
    if (mode != Mode.addSommet) return;
    final newSommet = Sommet(
      id: state.sommets.length,
      x: position.dx,
      y: position.dy,
    );
    state = state.copyWith(sommets: [...state.sommets, newSommet]);
  }

  void selectSommet(Sommet s, {BuildContext? context}) async {
    if (mode == Mode.addArete) {
      if (selectedSommetForArete == null) {
        selectedSommetForArete = s; // premier sommet sélectionné
      } else {
        // Deuxième sommet → créer arête
        double weight = 1;
        if (context != null) {
          final input = await showDialog<String>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Poids de l'arête"),
              content: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Entrez le poids"),
                onSubmitted: (value) => Navigator.pop(ctx, value),
              ),
            ),
          );
          if (input != null) weight = double.tryParse(input) ?? 1;
        }
        ajouterArete(selectedSommetForArete!.id, s.id, weight: weight);
        selectedSommetForArete = null;
      }
    }
  }

  void ajouterArete(int source, int destination, {double weight = 1}) {
    final newArete = Arete(source: source, destination: destination, weight: weight);
    state = state.copyWith(aretes: [...state.aretes, newArete]);
  }

  void deplacerSommet(int id, double x, double y) {
    final updated = state.sommets.map((s) {
      if (s.id == id) return Sommet(id: s.id, x: x, y: y);
      return s;
    }).toList();
    state = state.copyWith(sommets: updated);
  }

  void supprimerSommet(int id) {
    final updatedSommets = state.sommets.where((s) => s.id != id).toList();
    final updatedAretes = state.aretes.where((a) => a.source != id && a.destination != id).toList();
    state = state.copyWith(sommets: updatedSommets, aretes: updatedAretes);
  }

  void supprimerArete(Arete a) {
    final updatedAretes = state.aretes.where((ar) => ar != a).toList();
    state = state.copyWith(aretes: updatedAretes);
  }

  /// Algorithme Dijkstra (simplifié)
  List<int> dijkstra(int startId, int endId) {
    final n = state.sommets.length;
    final dist = List<double>.filled(n, double.infinity);
    final prev = List<int?>.filled(n, null);
    dist[startId] = 0;

    final visited = List<bool>.filled(n, false);

    for (int i = 0; i < n; i++) {
      // Trouver le sommet non visité avec distance minimale
      double minDist = double.infinity;
      int u = -1;
      for (int j = 0; j < n; j++) {
        if (!visited[j] && dist[j] < minDist) {
          minDist = dist[j];
          u = j;
        }
      }

      if (u == -1) break;
      visited[u] = true;

      // Mettre à jour les voisins
      for (final e in state.aretes) {
        if (e.source == u) {
          final v = e.destination;
          final alt = dist[u] + e.weight;
          if (alt < dist[v]) {
            dist[v] = alt;
            prev[v] = u;
          }
        }
      }
    }

    // Construire le chemin
    final path = <int>[];
    int? u = endId;
    while (u != null) {
      path.insert(0, u);
      u = prev[u];
    }
    return path;
  }

  void reset() {
    state = ExercicesState();
    mode = Mode.none;
    selectedSommetForArete = null;
  }
}

/// Provider global
final exercicesProvider = StateNotifierProvider<ExercicesController, ExercicesState>(
      (ref) => ExercicesController(),
);
