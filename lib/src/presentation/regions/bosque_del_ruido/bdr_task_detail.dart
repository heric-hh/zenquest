import 'package:flutter/material.dart';

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
    // Aquí podrías guardar los datos o navegar a otra pantalla
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
    return Scaffold(
      backgroundColor: const Color(0xFF121224),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1E3D),
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ListView(
          children: [
            Text(
              widget.description,
              style: const TextStyle(fontSize: 10, color: Colors.white70),
            ),
            const SizedBox(height: 16),
            !_exerciseStarted
                ? ElevatedButton(
                  onPressed: _startExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Text(
                    'Iniciar Ejercicio',
                    style: TextStyle(fontSize: 10),
                  ),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tiempo restante: ${_formatTime(_remainingSeconds)}",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.greenAccent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.instruction,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Escribe tu reflexión:',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B1E3D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _reflectionController,
                        maxLines: 6,
                        style: const TextStyle(
                          color: Colors.white,

                          fontSize: 10,
                        ),
                        decoration: const InputDecoration.collapsed(
                          hintText: "Escribe aquí...",
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _completeTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          'Completar',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
