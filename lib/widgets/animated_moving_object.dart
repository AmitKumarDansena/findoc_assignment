import 'package:flutter/material.dart';

/// A reusable widget that displays an animated moving object.
///
/// This widget can be used on different screens with potentially different
/// parameters to create varied animations.
class AnimatedMovingObject extends StatefulWidget {
  /// An index to differentiate instances and customize their behavior.
  final int index; // <-- Add this line

  /// Creates an [AnimatedMovingObject].
  /// Updated to accept the index parameter.
  const AnimatedMovingObject({Key? key, required this.index}) : super(key: key); // <-- Update this line

  @override
  State<AnimatedMovingObject> createState() => _AnimatedMovingObjectState();
}

/// State for [AnimatedMovingObject].
class _AnimatedMovingObjectState extends State<AnimatedMovingObject>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _alignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10), // Adjust duration
      vsync: this,
    )..repeat(); // Repeat indefinitely

    // Define a more complex path, e.g., diagonal movement
    _alignmentAnimation = Tween<Alignment>(
      begin: Alignment(-1.1, 1.1), // Start bottom-left, slightly off-screen
      end: Alignment(1.1, -1.1), // End top-right, slightly off-screen
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear)); // Linear for constant speed
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Align(
          alignment: _alignmentAnimation.value,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3), // Semi-transparent
              shape: BoxShape.circle, // Circular shape
            ),
            // Optional: Add child widget inside the circle
            // child: Icon(Icons.circle, color: Colors.white.withOpacity(0.5), size: 40,),
          ),
        );
      },
    );
  }
}