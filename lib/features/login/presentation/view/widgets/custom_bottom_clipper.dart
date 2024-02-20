import 'package:flutter/material.dart';

class CustomBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    var firstControlPoint =
        Offset(size.width - 55, size.height - (size.height / 1.4));
    var firstEndPoint = Offset(
        size.width - (size.width / 1.7), size.height - (size.height / 1.3));
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(35, size.height - 95);
    var secondEndPoint = Offset(0.0, size.height / 2.4);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(0.0, size.height - 40);
    path.lineTo(0.0, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
