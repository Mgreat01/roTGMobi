import 'package:flutter/material.dart';
import 'exercice_controller.dart';

class GraphCanvas extends StatelessWidget {
  final List<Sommet> sommets;
  final List<Arete> aretes;
  final Function(Offset) onCanvasTap;
  final Function(Sommet) onSommetTap;
  final Function(int, double, double) onDrag;

  const GraphCanvas({
    super.key,
    required this.sommets,
    required this.aretes,
    required this.onCanvasTap,
    required this.onSommetTap,
    required this.onDrag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        onCanvasTap(details.localPosition);
      },
      child: SizedBox.expand(
        child: Stack(
          children: [
            CustomPaint(
              size: Size.infinite,
              painter: _GraphPainter(sommets: sommets, aretes: aretes),
            ),
            ...sommets.map((s) => Positioned(
              left: s.x - 15,
              top: s.y - 15,
              width: 30,
              height: 30,
              child: GestureDetector(
                onTap: () => onSommetTap(s),
                onPanUpdate: (details) => onDrag(s.id, s.x + details.delta.dx, s.y + details.delta.dy),
                onLongPress: () {}, // peut ajouter suppression si voulu
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

  _GraphPainter({required this.sommets, required this.aretes});

  @override
  void paint(Canvas canvas, Size size) {
    final nodePaint = Paint()..color = Colors.blue;
    final edgePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    final textStyle = const TextStyle(color: Colors.black, fontSize: 12);

    // Dessiner les arêtes
    for (final e in aretes) {
      if (e.source < sommets.length && e.destination < sommets.length) {
        final a = Offset(sommets[e.source].x, sommets[e.source].y);
        final b = Offset(sommets[e.destination].x, sommets[e.destination].y);
        canvas.drawLine(a, b, edgePaint);

        // Afficher le poids
        final textPainter = TextPainter(
          text: TextSpan(text: e.weight.toString(), style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
        textPainter.paint(canvas, mid - Offset(textPainter.width / 2, textPainter.height / 2));
      }
    }

    // Dessiner les sommets
    for (final s in sommets) {
      final center = Offset(s.x, s.y);
      canvas.drawCircle(center, 15, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) => true;
}
