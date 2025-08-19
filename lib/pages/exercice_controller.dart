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
  final List<int> highlightedPath; // chemin calculé

  ExercicesState({this.sommets = const [], this.aretes = const [], this.highlightedPath = const []});

  ExercicesState copyWith({List<Sommet>? sommets, List<Arete>? aretes, List<int>? highlightedPath}) {
    return ExercicesState(
      sommets: sommets ?? this.sommets,
      aretes: aretes ?? this.aretes,
      highlightedPath: highlightedPath ?? this.highlightedPath,
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

  void reset() {
    state = ExercicesState();
    mode = Mode.none;
    selectedSommetForArete = null;
  }

  /// Dijkstra
  void runDijkstraAlgo(int startId, int endId) {
    final path = _dijkstra(startId, endId);
    state = state.copyWith(highlightedPath: path);
  }

  List<int> _dijkstra(int startId, int endId) {
    final n = state.sommets.length;
    final dist = List<double>.filled(n, double.infinity);
    final prev = List<int?>.filled(n, null);
    dist[startId] = 0;
    final visited = List<bool>.filled(n, false);

    for (int i = 0; i < n; i++) {
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
      for (final e in state.aretes.where((a) => a.source == u)) {
        final v = e.destination;
        final alt = dist[u] + e.weight;
        if (alt < dist[v]) {
          dist[v] = alt;
          prev[v] = u;
        }
      }
    }

    final path = <int>[];
    int? u = endId;
    while (u != null) {
      path.insert(0, u);
      u = prev[u];
    }
    return path;
  }

  /// Bellman-Ford
  void runBellmanFordAlgo(int startId) {
    final path = _bellmanFord(startId);
    state = state.copyWith(highlightedPath: path);
  }

  List<int> _bellmanFord(int startId) {
    final n = state.sommets.length;
    final dist = List<double>.filled(n, double.infinity);
    final prev = List<int?>.filled(n, null);
    dist[startId] = 0;

    for (int i = 0; i < n - 1; i++) {
      for (final e in state.aretes) {
        final u = e.source;
        final v = e.destination;
        if (dist[u] + e.weight < dist[v]) {
          dist[v] = dist[u] + e.weight;
          prev[v] = u;
        }
      }
    }

    final path = <int>[];
    int? u = n > 0 ? n - 1 : null;
    while (u != null) {
      path.insert(0, u);
      u = prev[u];
    }
    return path;
  }

  /// DFS
  void runDFSAlgo(int startId) {
    final path = _dfs(startId);
    state = state.copyWith(highlightedPath: path);
  }

  List<int> _dfs(int startId) {
    final n = state.sommets.length;
    final visited = List<bool>.filled(n, false);
    final path = <int>[];

    void dfs(int u) {
      visited[u] = true;
      path.add(u);
      for (final e in state.aretes.where((a) => a.source == u)) {
        if (!visited[e.destination]) dfs(e.destination);
      }
    }

    dfs(startId);
    return path;
  }

  /// BFS
  void runBFSAlgo(int startId) {
    final path = _bfs(startId);
    state = state.copyWith(highlightedPath: path);
  }

  List<int> _bfs(int startId) {
    final n = state.sommets.length;
    final visited = List<bool>.filled(n, false);
    final path = <int>[];
    final queue = <int>[];
    queue.add(startId);
    visited[startId] = true;

    while (queue.isNotEmpty) {
      final u = queue.removeAt(0);
      path.add(u);
      for (final e in state.aretes.where((a) => a.source == u)) {
        if (!visited[e.destination]) {
          queue.add(e.destination);
          visited[e.destination] = true;
        }
      }
    }
    return path;
  }

  /// Floyd-Warshall (chemin le plus court entre toutes paires)
  void runFloydWarshallAlgo() {
    final n = state.sommets.length;
    final dist = List.generate(n, (_) => List<double>.filled(n, double.infinity));
    final next = List.generate(n, (_) => List<int?>.filled(n, null));

    for (int i = 0; i < n; i++) {
      dist[i][i] = 0;
    }
    for (final e in state.aretes) {
      dist[e.source][e.destination] = e.weight;
      next[e.source][e.destination] = e.destination;
    }

    for (int k = 0; k < n; k++) {
      for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
          if (dist[i][k] + dist[k][j] < dist[i][j]) {
            dist[i][j] = dist[i][k] + dist[k][j];
            next[i][j] = next[i][k];
          }
        }
      }
    }

    // Exemple : chemin de 0 à n-1
    final path = <int>[];
    int? u = 0;
    final end = n - 1;
    while (u != null && u != end) {
      path.add(u);
      u = next[u][end];
    }
    if (u != null) path.add(end);
    state = state.copyWith(highlightedPath: path);
  }

  /// Longest Path (DAG simplifié)
  void runLongestPathAlgo() {
    final n = state.sommets.length;
    final dist = List<double>.filled(n, double.negativeInfinity);
    final prev = List<int?>.filled(n, null);
    dist[0] = 0;

    final topoOrder = _topologicalSort();
    for (final u in topoOrder) {
      for (final e in state.aretes.where((a) => a.source == u)) {
        if (dist[u] + e.weight > dist[e.destination]) {
          dist[e.destination] = dist[u] + e.weight;
          prev[e.destination] = u;
        }
      }
    }

    final path = <int>[];
    int? u = n - 1;
    while (u != null) {
      path.insert(0, u);
      u = prev[u];
    }
    state = state.copyWith(highlightedPath: path);
  }

  List<int> _topologicalSort() {
    final n = state.sommets.length;
    final visited = List<bool>.filled(n, false);
    final order = <int>[];

    void dfs(int u) {
      visited[u] = true;
      for (final e in state.aretes.where((a) => a.source == u)) {
        if (!visited[e.destination]) dfs(e.destination);
      }
      order.insert(0, u);
    }

    for (int i = 0; i < n; i++) {
      if (!visited[i]) dfs(i);
    }
    return order;
  }
}

/// Provider
final exercicesProvider = StateNotifierProvider<ExercicesController, ExercicesState>(
      (ref) => ExercicesController(),
);
