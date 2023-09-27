import 'package:flutter/material.dart';  
import 'dart:math';  
  
class FireworkPainter extends CustomPainter {  
  @override  
  void paint(Canvas canvas, Size size) {  
    final paint = Paint()  
      ..color = Colors.red  
      ..strokeCap = StrokeCap.round  
      ..style = PaintingStyle.stroke;  
  
    var path = Path();  
    path.moveTo(0, size.height / 2);  
  
    for (var i = 0; i < 100; i++) {  
      var offset = (i / 5).toDouble();  
      var y = sin(offset) * 20 + size.height / 2;  
      path.lineTo(offset * 10, y);  
    }  
    path.lineTo(size.width, size.height / 2);  
    path.close();  
  
    canvas.drawPath(path, paint);  
  }  
  
  @override  
  bool shouldRepaint(covariant CustomPainter oldDelegate) {  
    return oldDelegate != this;  
  }  
}