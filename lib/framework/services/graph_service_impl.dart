import '../../business/models/node.dart';
import '../../business/models/edge.dart';
import '../../business/models/graph_result.dart';
import '../../business/services/graph_service.dart';

class GraphServiceImpl implements GraphService {
  @override
  GraphResult runDijkstra(List<Node> nodes, List<Edge> edges, Node start, Node end) {
    // Implémentation de Dijkstra
    return GraphResult(highlightedPath: [], data: {});
  }

  @override
  GraphResult runBellmanFord(List<Node> nodes, List<Edge> edges, Node start) {
    return GraphResult(highlightedPath: [], data: {});
  }

  @override
  GraphResult runFloydWarshall(List<Node> nodes, List<Edge> edges) {
    return GraphResult(highlightedPath: [], data: {});
  }

  @override
  GraphResult runDFS(List<Node> nodes, List<Edge> edges, Node start) {
    return GraphResult(highlightedPath: [], data: {});
  }

  @override
  GraphResult runBFS(List<Node> nodes, List<Edge> edges, Node start) {
    return GraphResult(highlightedPath: [], data: {});
  }

  @override
  GraphResult runLongestPath(List<Node> nodes, List<Edge> edges) {
    return GraphResult(highlightedPath: [], data: {});
  }
}
