import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///My animated look-alike pinterest loading indicator

class AnimatedCircularContainer extends StatefulWidget {
  const AnimatedCircularContainer({super.key});

  @override
  State<AnimatedCircularContainer> createState() => _AnimatedCircularContainerState();
}

class _AnimatedCircularContainerState extends State<AnimatedCircularContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _controller.repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: Center(
        child: Container(
          width: 50.w,
          height: 50.h,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
          child: const Center(
            child: Icon(CupertinoIcons.rectangle_grid_2x2_fill),
          ),
        ),
      ),
    );
  }
}

