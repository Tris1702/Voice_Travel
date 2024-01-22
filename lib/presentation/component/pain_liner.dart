import 'dart:ui';

import 'package:flutter/material.dart';

class BlackLinePainter extends CustomPainter {

  final List<List<Offset>> sequencePoints;
  // final Offset limitX;
  // final Offset limitY:

  BlackLinePainter(this.sequencePoints);//, this.limitX, this.limitY);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black..strokeWidth = 5.0;
    for (var points in sequencePoints) {
      for (int index = 1; index < points.length; index++) {
        canvas.drawLine(points[index-1], points[index], paint);
      }
    }
  }

  @override
  bool shouldRepaint(BlackLinePainter oldDelegate) => sequencePoints != oldDelegate.sequencePoints;
}