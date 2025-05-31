import 'package:flutter/material.dart';

class RegionIntroScreen extends StatelessWidget {
  final String regionName;

  const RegionIntroScreen({super.key, required this.regionName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B33),
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: Text(regionName),
      // ),
      body: Center(
        child: Text(
          'Introducción a $regionName',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
