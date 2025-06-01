import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zenquest/src/config/theme/colors/app_colors.dart';
import 'package:zenquest/src/presentation/regions/bosque_del_ruido/region_map_screen.dart';

class RegionIntroScreen extends StatefulWidget {
  final String regionName;

  const RegionIntroScreen({super.key, required this.regionName});

  @override
  State<RegionIntroScreen> createState() => _RegionIntroScreenState();
}

class _RegionIntroScreenState extends State<RegionIntroScreen> {
  String _displayedText = '';
  final String _fullText =
      'Aquí aprenderás a silenciar el ruido, escuchándolo...';
  int _textIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTypewriterEffect();
  }

  void _startTypewriterEffect() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_textIndex < _fullText.length) {
        setState(() {
          _displayedText += _fullText[_textIndex];
          _textIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B33),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título principal
              Text(
                'Has entrado en el ${widget.regionName}',
                style: const TextStyle(
                  fontSize: 24,
                  color: AppColors.backgroundColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Sprite del personaje guía
              // TODO : Reemplazar con el sprite real del guía
              Center(child: Image.asset('assets/images/guia.png', height: 100)),
              const SizedBox(height: 24),

              // Texto del guía (efecto máquina de escribir)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.onBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _displayedText,
                  style: const TextStyle(
                    fontSize: 24,
                    color: AppColors.buttonIntro,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(),

              // Botón "Comenzar el camino"
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RegionMapScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonIntro,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Comenzar el camino',
                    style: TextStyle(fontSize: 20, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
