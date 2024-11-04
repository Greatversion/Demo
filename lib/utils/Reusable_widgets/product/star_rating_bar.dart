// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class StarRatingBar extends StatelessWidget {
  final double rating;

  const StarRatingBar({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(
            Icons.star,
            color: Color(0xFFFFD700),
            size: 26,
          );
        } else if (index < rating) {
          return HalfFilledStar(rating: rating);
        } else {
          return Icon(
            size: 26,
            Icons.star_border,
            color: rating == 0
                ? Colors.black
                : const Color.fromARGB(255, 255, 230, 0),
          );
        }
      }),
    );
  }
}

class HalfFilledStar extends StatelessWidget {
  final double rating;
  const HalfFilledStar({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Icon(
          size: 26,
          Icons.star_border,
          color: Color.fromARGB(255, 255, 230, 0),
        ),
        ClipRect(
          clipper: HalfClipper(),
          child: Icon(
            Icons.star,
            size: 26,
            color: rating == 0
                ? Colors.black
                : const Color.fromARGB(255, 255, 230, 0),
          ),
        ),
      ],
    );
  }
}

class HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0.0, 0.0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
