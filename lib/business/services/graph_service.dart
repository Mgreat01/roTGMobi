import '../models/node.dart';
import '../models/edge.dart';
import '../models/graph_result.dart';

abstract class GraphService {
  GraphResult runDijkstra(List<Node> nodes, List<Edge> edges, Node start, Node end);
  GraphResult runBellmanFord(List<Node> nodes, List<Edge> edges, Node start);
  GraphResult runFloydWarshall(List<Node> nodes, List<Edge> edges);
  GraphResult runDFS(List<Node> nodes, List<Edge> edges, Node start);
  GraphResult runBFS(List<Node> nodes, List<Edge> edges, Node start);
  GraphResult runLongestPath(List<Node> nodes, List<Edge> edges);
}
