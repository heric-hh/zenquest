import 'package:flutter/material.dart';
import 'package:zenquest/src/config/theme/colors/app_colors.dart';

class BDRTaskDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String instruction;

  const BDRTaskDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.instruction,
  });

  @override
  State<BDRTaskDetailScreen> createState() => _BDRTaskDetailScreenState();
}

class _BDRTaskDetailScreenState extends State<BDRTaskDetailScreen> {
  final TextEditingController _reflectionController = TextEditingController();
  bool _exerciseStarted = false;
  int _remainingSeconds = 180;
  late final Stopwatch _stopwatch;

  @override
  /// Initializes the state of the widget.
  /// This function is called when the widget is inserted into the tree.
  /// It initializes the stopwatch to zero.
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  void _startExercise() {
    setState(() {
      _exerciseStarted = true;
      _stopwatch.start();
      _tick();
    });
  }

  void _tick() async {
    while (_stopwatch.isRunning && _remainingSeconds > 0) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _remainingSeconds--;
      });
    }
    if (_remainingSeconds <= 0) {
      _stopwatch.stop();
    }
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void _completeTask() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("¡Tarea completada!"),
            content: const Text("Has dado un paso más en tu camino."),
            actions: [
              TextButton(
                onPressed:
                    () => Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst),
                child: const Text("Volver al mapa"),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF121224),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1E3D),
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child:
              !_exerciseStarted
                  ? Column(
                    key: const ValueKey('initial_state'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _startExercise,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                          ),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text(
                            'Iniciar Ejercicio',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  )
                  : ListView(
                    key: const ValueKey('exercise_started'),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tiempo restante:",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            _formatTime(_remainingSeconds),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.instruction,
                        style: textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Escribe tu reflexión:',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1E3D),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          controller: _reflectionController,
                          maxLines: 6,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration.collapsed(
                            hintText: "Escribe aquí tu experiencia...",
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: ElevatedButton(
                          onPressed: _completeTask,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Completar',
                            style: TextStyle(fontSize: 14),
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
