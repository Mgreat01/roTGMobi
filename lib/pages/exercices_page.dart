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
      appBar: AppBar(title: const Text("Exercices Graphes")),
      body: Column(
        children: [
          // Canvas interactif
          Expanded(
            child: GraphCanvas(
              sommets: state.sommets,
              aretes: state.aretes,
              highlightedPath: state.highlightedPath,
              onCanvasTap: (pos) => controller.addSommetAt(pos),
              onSommetTap: (s) => controller.selectSommet(s, context: context),
              onDrag: (id, x, y) => controller.deplacerSommet(id, x, y),
            ),
          ),

          const SizedBox(height: 10),

          // Panneau affichant le chemin calculé
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            width: double.infinity,
            child: state.highlightedPath.isEmpty
                ? const Text("Aucun chemin calculé")
                : Text(
              "Chemin calculé : ${state.highlightedPath.join(" → ")}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          const SizedBox(height: 10),

          // Boutons
          Wrap(
            spacing: 10,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(onPressed: () => controller.setMode(Mode.addSommet), child: const Text("Ajouter sommet")),
              ElevatedButton(onPressed: () => controller.setMode(Mode.addArete), child: const Text("Ajouter arête")),
              ElevatedButton(onPressed: () => controller.runDijkstraAlgo(0, state.sommets.length - 1), child: const Text("Dijkstra")),
              ElevatedButton(onPressed: () => controller.runBellmanFordAlgo(0), child: const Text("Bellman-Ford")),
              ElevatedButton(onPressed: () => controller.runDFSAlgo(0), child: const Text("DFS")),
              ElevatedButton(onPressed: () => controller.runBFSAlgo(0), child: const Text("BFS")),
              ElevatedButton(onPressed: controller.reset, child: const Text("Reset")),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
