import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'exercice_controller.dart';
import 'graph_canvas.dart';

class ExercicesPage extends ConsumerWidget {
  const ExercicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exercicesProvider); // état (sommets + arêtes)
    final controller = ref.read(exercicesProvider.notifier); // actions

    return Scaffold(
      appBar: AppBar(title: const Text("Exercices Graphes")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: GraphCanvas(
                sommets: state.sommets,
                aretes: state.aretes,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: controller.ajouterSommet,
                child: const Text("Ajouter sommet"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  if (state.sommets.length >= 2) {
                    controller.ajouterArete(0, state.sommets.length - 1);
                  }
                },
                child: const Text("Ajouter arête"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: controller.reset,
                child: const Text("Reset"),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
