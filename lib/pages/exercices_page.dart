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
          Expanded(
            child: GestureDetector(
              onTapUp: (details) {
                controller.ajouterSommet(
                  details.localPosition.dx,
                  details.localPosition.dy,
                );
              },
              child: GraphCanvas(
                sommets: state.sommets,
                aretes: state.aretes,
                selectedSommet: state.selectedSommet,
                onSommetTap: controller.selectSommet,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
