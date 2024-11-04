import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MirrorImageAnimation extends StatefulWidget {
  const MirrorImageAnimation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MirrorImageAnimationState createState() => _MirrorImageAnimationState();
}

class _MirrorImageAnimationState extends State<MirrorImageAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration:
          const Duration(milliseconds: 200), // Speed of the mirror animation
      vsync: this,
    );

    // Set up a Tween animation to mirror the image horizontally
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // Loop the animation indefinitely

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(_animation.value, 1.0),
            child: child,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset(
            'assets/images/newmambo.png',
            fit: BoxFit.cover,
            height: 60,
            width: 60,
          ),
        ),
      ),
    );
  }
}

class SimpleLoadingIndicator extends StatelessWidget {
  const SimpleLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/animations/icons8-search.json",
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              repeat: true,
              reverse: true),
          const SizedBox(height: 4),
          const Text(
            "Curating the perfect selection for you", // Inform user if no products are available
            style: TextStyle(
                color: Color.fromARGB(255, 116, 116, 116),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
