import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'exercice_controller.dart';
import 'graph_canvas.dart';

class ExercicesPage extends ConsumerWidget {
  const ExercicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exercicesProvider);
    final controller = ref.read(exercicesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercices Graphes"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 3,
      ),
      body: Column(
        children: [
          // Canvas avec fond doux
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: GraphCanvas(
                sommets: state.sommets,
                aretes: state.aretes,
                highlightedPath: state.highlightedPath,
                onCanvasTap: (pos) => controller.addSommetAt(pos),
                onSommetTap: (s) => controller.selectSommet(s, context: context),
                onDrag: (id, x, y) => controller.deplacerSommet(id, x, y),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Panneau chemin
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            width: double.infinity,
            child: state.highlightedPath.isEmpty
                ? const Text(
              "Aucun chemin calculé",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blueGrey),
            )
                : Text(
              "Chemin calculé : ${state.highlightedPath.join(" → ")}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
          ),

          const SizedBox(height: 10),

          // Boutons stylisés épurés
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                _styledButton("Ajouter sommet", Icons.add_circle, Colors.blue.shade700, () => controller.setMode(Mode.addSommet)),
                _styledButton("Ajouter arête", Icons.show_chart, Colors.orange.shade700, () => controller.setMode(Mode.addArete)),
                _styledButton("Dijkstra", Icons.route, Colors.blue.shade700, () => controller.runDijkstraAlgo(0, state.sommets.length - 1)),
                _styledButton("Bellman-Ford", Icons.swap_horiz, Colors.orange.shade700, () => controller.runBellmanFordAlgo(0)),
                _styledButton("DFS", Icons.travel_explore, Colors.blue.shade700, () => controller.runDFSAlgo(0)),
                _styledButton("BFS", Icons.grid_view, Colors.orange.shade700, () => controller.runBFSAlgo(0)),
                _styledButton("Floyd-Warshall", Icons.all_inclusive, Colors.blue.shade700, () => controller.runFloydWarshallAlgo()),
                _styledButton("Longest Path", Icons.timeline, Colors.orange.shade700, () => controller.runLongestPathAlgo()),
                _styledButton("Reset", Icons.refresh, Colors.grey.shade600, controller.reset),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Fonction pour créer des boutons épurés avec icône
  Widget _styledButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 3,
          shadowColor: Colors.grey.shade400,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
