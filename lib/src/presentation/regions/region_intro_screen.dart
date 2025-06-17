import 'dart:async';
import 'dart:convert'; // Import for JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
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
  String _fullText = ''; // This will now come from the API
  String _introTitle = ''; // New state variable for the title
  int _textIndex = 0;
  Timer? _timer;
  bool _isLoading = true; // To show loading state
  String? _errorMessage; // To handle errors

  // Replace with your actual API endpoint
  final String _apiEndpoint =
      'http://192.168.1.2:3000/api/chapters/title-description';

  @override
  void initState() {
    super.initState();
    _fetchRegionIntroData();
  }

  Future<void> _fetchRegionIntroData() async {
    try {
      final response = await http.post(
        Uri.parse(_apiEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'unlockedZoneId': 'CH-1'}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _introTitle = data['title'] ?? 'Título no disponible';
          _fullText = data['description'] ?? 'Descripción no disponible.';
          _isLoading = false;
          _startTypewriterEffect(); // Start typewriter effect after fetching data
        });
      } else {
        setState(() {
          _errorMessage = 'Error al cargar los datos: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión: $e';
        _isLoading = false;
      });
    }
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
          child:
              _isLoading
                  ? const Center(
                    child: CircularProgressIndicator(),
                  ) // Show loading indicator
                  : _errorMessage != null
                  ? Center(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ) // Show error message
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título principal
                      Text(
                        _introTitle, // Use the fetched title
                        style: const TextStyle(
                          fontSize: 24,
                          color: AppColors.backgroundColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Sprite del personaje guía
                      Center(
                        child: Image.asset(
                          'assets/images/guia.png',
                          height: 100,
                        ),
                      ),
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
                              MaterialPageRoute(
                                builder: (_) => RegionMapScreen(),
                              ),
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
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                            ),
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
