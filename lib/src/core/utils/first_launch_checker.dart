import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstLaunchChecker extends StatelessWidget {
  final Widget homeWidget;
  final Widget onboardingWidget;

  const FirstLaunchChecker({
    Key? key,
    required this.homeWidget,
    required this.onboardingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isFirstLaunch(),
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return snapshot.data == true ? onboardingWidget : homeWidget;
        }
      },
    );
  }

  Future<bool> _isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'is_first_launch';
    final isFirstLaunch = prefs.getBool(key) ?? true;

    if (isFirstLaunch) {
      await prefs.setBool(key, false);
    }

    return isFirstLaunch;
  }
}
