import 'package:pompompay/core/hook/hooks.dart';

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    double radius = 20;
    double cutY = size.height * 0.25;

    // Start from top-left
    path.moveTo(0, 0);

    // Left edge
    path.lineTo(0, cutY - radius);
    path.arcToPoint(
      Offset(0, cutY + radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(0, size.height);

    // Bottom-left to bottom-right
    path.lineTo(size.width, size.height);

    // Right edge
    path.lineTo(size.width, cutY + radius);
    path.arcToPoint(
      Offset(size.width, cutY - radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(size.width, 0);

    // Close the path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
