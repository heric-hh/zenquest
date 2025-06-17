import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zenquest/src/config/theme/colors/app_colors.dart';
import 'package:zenquest/src/presentation/regions/bosque_del_ruido/bdr_task_detail.dart';

// 1. Modelo de datos para la tarea
class Task {
  final int chapterNumber;
  final int dayNumber;
  final int taskOrder;
  final String title;
  final String description;
  final String expectedCompletionType;
  final int defaultXP;
  final List<dynamic> rewardItems;
  final String? unlocksAchievement;
  bool unlocked; // Añadimos esta propiedad para manejar el estado de desbloqueo

  Task({
    required this.chapterNumber,
    required this.dayNumber,
    required this.taskOrder,
    required this.title,
    required this.description,
    required this.expectedCompletionType,
    required this.defaultXP,
    required this.rewardItems,
    this.unlocksAchievement,
    this.unlocked =
        false, // Por defecto, las tareas se consideran bloqueadas a menos que se especifique
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      chapterNumber: json['chapterNumber'],
      dayNumber: json['dayNumber'],
      taskOrder: json['taskOrder'],
      title: json['title'],
      description: json['description'],
      expectedCompletionType: json['expectedCompletionType'],
      defaultXP: json['defaultXP'],
      rewardItems: json['rewardItems'] as List<dynamic>,
      unlocksAchievement: json['unlocksAchievement'],
      // Aquí puedes agregar lógica para determinar si una tarea está desbloqueada
      // Por ahora, asumiremos que todas las tareas recibidas están desbloqueadas para este ejemplo
      unlocked:
          true, // Esto deberá ser determinado por la lógica de negocio real
    );
  }
}

class RegionMapScreen extends StatefulWidget {
  const RegionMapScreen({super.key});

  @override
  State<RegionMapScreen> createState() => _RegionMapScreenState();
}

class _RegionMapScreenState extends State<RegionMapScreen> {
  // Lista para almacenar las tareas cargadas desde la API
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _fetchTasks();
  }

  // Función para llamar a la API y obtener las tareas
  Future<List<Task>> _fetchTasks() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.2:3000/api/tasks/all-tasks'),
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((task) => Task.fromJson(task)).toList();
      } else {
        // Manejar errores de la API
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar errores de red u otros errores
      throw Exception('Failed to load tasks: $e');
    }
  }

  void _showTaskDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E2E),
            title: Text(
              task.title,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.description,
                  style: const TextStyle(fontSize: 20, color: Colors.white70),
                ),
                const SizedBox(height: 10),
                Text(
                  'Experiencia: ${task.defaultXP} XP', // Muestra la experiencia
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => BDRTaskDetailScreen(
                            title: task.title,
                            description: task.description,
                            instruction:
                                'Escribe lo que aparezca sin filtros ni correcciones.', // Esta instrucción parece ser genérica, podrías querer obtenerla de la API también
                          ),
                    ),
                  );
                },
                child: const Text(
                  'Comenzar',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildTaskItem(BuildContext context, Task task) {
    return GestureDetector(
      onTap:
          task.unlocked
              ? () => _showTaskDialog(context, task)
              : null, // Deshabilita si está bloqueado
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              task.unlocked ? const Color(0xFF2B335B) : const Color(0xFF44475A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white70, width: 1.2),
        ),
        child: Row(
          children: [
            Icon(
              task.unlocked ? Icons.check_circle : Icons.lock,
              color: task.unlocked ? Colors.greenAccent : Colors.white24,
              size: 36,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.title,
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
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No hay tareas disponibles.',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            // Si los datos se cargaron correctamente, muestra la lista de tareas
            return ListView.builder(
              itemCount: snapshot.data!.length,
              padding: const EdgeInsets.only(top: 24, bottom: 32),
              itemBuilder: (context, index) {
                return _buildTaskItem(context, snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}
