import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';



import 'onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.addListener(() {
      if (_controller.value == 0.5) {
        _blinkAndSlideUp();
      }
    });

    _controller.forward();
  }

  void _blinkAndSlideUp() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.reverse();

      Future.delayed(const Duration(milliseconds: 500), () {

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const OnboardingScreen(),
            transitionsBuilder: (context, animation, _, child) {
              final screenAnimation = Tween(
                begin: const Offset(0, 1),
                end: Offset.zero,
              )
                  .chain(CurveTween(curve: Curves.bounceOut))
                  .animate(animation);

              return Stack(
                children: [
                  Positioned(
                    top: -50 * (1 - _controller.value), // Adjust this value based on the logo size
                    left: 0,
                    right: 0,
                    child: Opacity(
                      opacity: 1 - _controller.value,
                      child: Image.asset(
                        'assets/images/pinterst.png',
                        height: 50.h,
                        width: 50.w,
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: screenAnimation,
                    child: child,
                  ),
                ],
              );
            },
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.2 - (_controller.value * 0.4),
              child: child,
            );
          },
          child: Image.asset(
            'assets/images/pinterst.png',
            height: 70.h,
            width: 70.w,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


