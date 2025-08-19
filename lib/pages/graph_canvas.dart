import 'package:flutter/material.dart';
import 'exercice_controller.dart'; // pour les classes Sommet et Arete

class GraphCanvas extends StatelessWidget {
  final List<Sommet> sommets;
  final List<Arete> aretes;

  const GraphCanvas({
    super.key,
    required this.sommets,
    required this.aretes,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GraphPainter(sommets: sommets, aretes: aretes),
      // Assure que le canvas prend toute la place dispo
      child: const SizedBox.expand(),
    );
  }
}

class _GraphPainter extends CustomPainter {
  final List<Sommet> sommets;
  final List<Arete> aretes;

  _GraphPainter({required this.sommets, required this.aretes});

  @override
  void paint(Canvas canvas, Size size) {
    // Peinture pour sommets
    final nodePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Peinture pour arêtes
    final edgePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    // 1) Dessiner les arêtes
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

    // 2) Dessiner les sommets + labels
    for (final s in sommets) {
      final center = Offset(s.x, s.y);
      canvas.drawCircle(center, 12, nodePaint);

      final tp = TextPainter(
        text: TextSpan(
          text: s.id.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) {
    // Redessine si la liste change (taille ou contenu)
    return oldDelegate.sommets != sommets || oldDelegate.aretes != aretes;
  }
}
