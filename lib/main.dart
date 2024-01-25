import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinterest_clone/screens/bottom_nav_bar.dart';
import 'package:pinterest_clone/screens/home_screen.dart';
import 'package:pinterest_clone/screens/onboard_screen.dart';
import 'package:pinterest_clone/screens/splash_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child){
        return MaterialApp(
          title: 'Pinterest',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (settings) {
            if (settings.name == AppRoutes.splashScreen) {
              return MaterialPageRoute(
                builder: (context) {
                  return const SplashScreen();
                },
              );
            }
            if (settings.name == AppRoutes.homeScreenRoute) {
              return MaterialPageRoute(builder: (context) {
                return const HomeScreen();
              });
            }
            if (settings.name == AppRoutes.bottomNavBar) {
              return MaterialPageRoute(builder: (context) {
                return const BottomNavBarScreen();
              });
            }
            if (settings.name == AppRoutes.onboardScreen) {
              return MaterialPageRoute(builder: (context) {
                return const OnboardingScreen();
              });
            }
            return null;
          },
          initialRoute: AppRoutes.bottomNavBar,
        );
      },

    );
  }
}

class AppRoutes {
  static const String splashScreen = '/splash_screen';
  static const String onboardScreen = '/onboard_Screen';
  static const String mainRoute = '/bottom_nav_bar_Screen';
  static const String homeScreenRoute = '/home_Screen';
  static const String bottomNavBar = '/bottom_nav_bar';
}
