import 'package:flutter/material.dart';
import 'package:zenquest/src/config/theme/colors/app_colors.dart';

class RegionMapScreen extends StatelessWidget {
  const RegionMapScreen({super.key});

  final List<Map<String, dynamic>> tasks = const [
    {
      'title': 'Tarea 1: Escucha Interna',
      'description':
          'Aprende a escuchar tus propios pensamientos sin juzgarlos.',
      'unlocked': true,
    },
    {
      'title': 'Tarea 2: Ruidos Externos',
      'description':
          'Identifica qué elementos externos te afectan emocionalmente.',
      'unlocked': true,
    },
    {
      'title': 'Tarea 3: Silencio Consciente',
      'description':
          'Explora momentos de silencio y lo que pueden revelar de ti.',
      'unlocked': false,
    },
    {
      'title': 'Tarea 4: La Voz del Yo',
      'description': 'Conecta con tu voz auténtica más allá del ruido.',
      'unlocked': false,
    },
  ];

  void _showTaskDialog(BuildContext context, Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E2E),
            title: Text(
              task['title'],
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            content: Text(
              task['description'],
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  //TODO:  Aquí iría tu lógica para ir a la pantalla de tarea
                },
                child: const Text(
                  'Comenzar',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildTaskItem(BuildContext context, Map<String, dynamic> task) {
    return GestureDetector(
      onTap:
          task['unlocked']
              ? () => _showTaskDialog(context, task)
              : null, // Deshabilita si está bloqueado
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              task['unlocked']
                  ? const Color(0xFF2B335B)
                  : const Color(0xFF44475A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white70, width: 1.2),
        ),
        child: Row(
          children: [
            Icon(
              task['unlocked'] ? Icons.check_circle : Icons.lock,
              color: task['unlocked'] ? Colors.greenAccent : Colors.white24,
              size: 36,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task['title'],
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121224),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1E3D),
        title: const Text(
          'Camino del Silencio',
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        padding: const EdgeInsets.only(top: 24, bottom: 32),
        itemBuilder: (context, index) {
          return _buildTaskItem(context, tasks[index]);
        },
      ),
    );
  }
}
