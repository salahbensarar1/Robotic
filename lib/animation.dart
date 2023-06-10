import 'package:flutter/material.dart';

class MyAnimatedWidget extends StatefulWidget {
  final Duration duration;
  final Widget child;

  const MyAnimatedWidget({
    required this.duration,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: false);

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
        return Transform.scale(
          scale: _controller.value * 0.5 + 0.5,
          child: widget.child,
        );
      },
    );
  }
}
