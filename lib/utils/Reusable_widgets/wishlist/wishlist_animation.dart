import 'package:flutter/material.dart';

class AutoHeartAnimationWidget extends StatefulWidget {
  @override
  _AutoHeartAnimationWidgetState createState() =>
      _AutoHeartAnimationWidgetState();
}

class _AutoHeartAnimationWidgetState extends State<AutoHeartAnimationWidget>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  double _scale = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation(); // Start animation automatically when the widget is built
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _scale = 1.0;
        _isVisible = true;
      });

      // Reverse the animation after 1 second
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _scale = 0.0;
          _isVisible = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale, // Control the scale of the heart icon
      duration: const Duration(milliseconds: 300), // Scale duration
      curve: Curves.easeOutBack, // Easing curve for smooth scaling
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0, // Control the visibility
        duration: const Duration(milliseconds: 300), // Fade in/out duration
        child: const Icon(
          Icons.favorite_rounded,
          size: 100.0, // Size of the heart icon
          color: Colors.white, // Color of the heart icon
        ),
      ),
    );
  }
}
