import 'package:flutter/material.dart';
import 'exercice_controller.dart';

class GraphCanvas extends StatelessWidget {
  final List<Sommet> sommets;
  final List<Arete> aretes;
  final Sommet? selectedSommet;
  final Function(Sommet) onSommetTap;

  const GraphCanvas({
    super.key,
    required this.sommets,
    required this.aretes,
    required this.onSommetTap,
    this.selectedSommet,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GraphPainter(
        sommets: sommets,
        aretes: aretes,
        selectedSommet: selectedSommet,
      ),
      child: Stack(
        children: sommets
            .map((s) => Positioned(
          left: s.x - 15,
          top: s.y - 15,
          width: 30,
          height: 30,
          child: GestureDetector(
            onTap: () => onSommetTap(s),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selectedSommet?.id == s.id
                    ? Colors.red
                    : Colors.blue,
              ),
              alignment: Alignment.center,
              child: Text(
                s.id.toString(),
                style: const TextStyle(
                    color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ))
            .toList(),
      ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  final List<Sommet> sommets;
  final List<Arete> aretes;
  final Sommet? selectedSommet;

  _GraphPainter({
    required this.sommets,
    required this.aretes,
    this.selectedSommet,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final edgePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    for (final e in aretes) {
      if (e.source >= 0 &&
          e.source < sommets.length &&
          e.destination >= 0 &&
          e.destination < sommets.length) {
        final a = Offset(sommets[e.source].x, sommets[e.source].y);
        final b = Offset(sommets[e.destination].x, sommets[e.destination].y);
        canvas.drawLine(a, b, edgePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) => true;
}
