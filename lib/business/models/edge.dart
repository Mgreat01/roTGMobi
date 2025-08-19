import 'node.dart';

class Edge {
  final Node from;
  final Node to; // <- important
  final double weight;

  Edge({required this.from, required this.to, this.weight = 1});
}
