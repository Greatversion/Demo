import 'package:flutter/material.dart';

class DiscountTagWidget extends StatelessWidget {
  final String discountText;
  const DiscountTagWidget({
    super.key,
    required this.discountText,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomDiscountClipper(),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: const LinearGradient(colors: [
                Colors.redAccent,
                Color.fromARGB(255, 231, 154, 39)
              ])),
          child: Text(
            discountText,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          )),
    );
  }
}

class CustomDiscountClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width - 10, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 10, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
