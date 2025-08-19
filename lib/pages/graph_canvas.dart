import 'package:flutter/material.dart';
import 'exercice_controller.dart';

class GraphCanvas extends StatelessWidget {
  final List<Sommet> sommets;
  final List<Arete> aretes;
  final List<int> highlightedPath;
  final Function(Offset) onCanvasTap;
  final Function(Sommet) onSommetTap;
  final Function(int, double, double) onDrag;

  const GraphCanvas({
    super.key,
    required this.sommets,
    required this.aretes,
    required this.highlightedPath,
    required this.onCanvasTap,
    required this.onSommetTap,
    required this.onDrag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => onCanvasTap(details.localPosition),
      child: SizedBox.expand(
        child: Stack(
          children: [
            CustomPaint(
              size: Size.infinite,
              painter: _GraphPainter(sommets: sommets, aretes: aretes, highlightedPath: highlightedPath),
            ),
            ...sommets.map((s) => Positioned(
              left: s.x - 15,
              top: s.y - 15,
              width: 30,
              height: 30,
              child: GestureDetector(
                onTap: () => onSommetTap(s),
                onPanUpdate: (details) => onDrag(s.id, s.x + details.delta.dx, s.y + details.delta.dy),
                child: Container(
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                  alignment: Alignment.center,
                  child: Text(s.id.toString(), style: const TextStyle(color: Colors.white)),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  final List<Sommet> sommets;
  final List<Arete> aretes;
  final List<int> highlightedPath;

  _GraphPainter({required this.sommets, required this.aretes, required this.highlightedPath});

  @override
  void paint(Canvas canvas, Size size) {
    final nodePaint = Paint()..color = Colors.blue;
    final highlightedNodePaint = Paint()..color = Colors.red;
    final edgePaint = Paint()..color = Colors.black..strokeWidth = 2.0;
    final highlightedEdgePaint = Paint()..color = Colors.red..strokeWidth = 3.0;

    // Arêtes
    for (final e in aretes) {
      if (e.source >= sommets.length || e.destination >= sommets.length) continue;
      final a = Offset(sommets[e.source].x, sommets[e.source].y);
      final b = Offset(sommets[e.destination].x, sommets[e.destination].y);

      bool isHighlighted = false;
      for (int i = 0; i < highlightedPath.length - 1; i++) {
        if ((highlightedPath[i] == e.source && highlightedPath[i + 1] == e.destination) ||
            (highlightedPath[i] == e.destination && highlightedPath[i + 1] == e.source)) {
          isHighlighted = true;
          break;
        }
      }

      canvas.drawLine(a, b, isHighlighted ? highlightedEdgePaint : edgePaint);

      // Poids
      final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
      final tp = TextPainter(
        text: TextSpan(
          text: e.weight.toString(),
          style: TextStyle(color: isHighlighted ? Colors.red : Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, mid - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) {
    return oldDelegate.sommets != sommets || oldDelegate.aretes != aretes || oldDelegate.highlightedPath != highlightedPath;
  }
}
