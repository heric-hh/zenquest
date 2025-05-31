import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenquest/src/config/theme/colors/app_colors.dart';
import 'package:zenquest/src/core/utils/first_launch_checker.dart';
import 'package:zenquest/src/presentation/navigation/main_navigation.dart';
import 'package:zenquest/src/presentation/pages/home_screen.dart';
import 'package:zenquest/src/presentation/pages/intro_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZenQuest',
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          surface: AppColors.surfaceColor,
          error: AppColors.errorColor,
          onPrimary: AppColors.onPrimary,
          onSecondary: AppColors.onSecondary,
          onSurface: AppColors.onSurface,
          onError: AppColors.onError,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.pixelifySansTextTheme(),
      ),
      home: FirstLaunchChecker(
        homeWidget: const MainNavigation(),
        onboardingWidget: const IntroScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
