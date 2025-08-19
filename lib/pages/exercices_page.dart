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
            child: GraphCanvas(
              sommets: state.sommets,
              aretes: state.aretes,
              onCanvasTap: (pos) => controller.addSommetAt(pos),
              onSommetTap: (s) => controller.selectSommet(s, context: context),
              onDrag: (id, x, y) => controller.deplacerSommet(id, x, y),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: [
              ElevatedButton(
                onPressed: () => controller.setMode(Mode.addSommet),
                child: const Text("Ajouter sommet"),
              ),
              ElevatedButton(
                onPressed: () => controller.setMode(Mode.addArete),
                child: const Text("Ajouter arête"),
              ),
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
