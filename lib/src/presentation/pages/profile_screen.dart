import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenquest/src/config/theme/colors/app_colors.dart';
import 'package:zenquest/src/presentation/pages/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose(); // Liberar recursos del controlador
    super.dispose();
  }

  void _saveName() async {
    final String name = _nameController.text;
    // Aquí puedes almacenar el nombre en una base de datos, enviar a un servidor, etc.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'user_name',
      name,
    ); // Guardar el nombre en SharedPreferences
    print('Nombre guardado: $name'); // Ejemplo de acción
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: AppColors.primaryColor),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '¿Cómo quieres que te llamemos?',
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.onPrimary,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.onPrimary,
                      ), // Borde cuando no está enfocado
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.onPrimary,
                        width: 2.0,
                      ), // Borde cuando está enfocado
                    ),
                    hintText: "Escribe tu nombre",
                  ),
                  style: TextStyle(color: AppColors.onPrimary, fontSize: 16),
                  cursorColor: AppColors.onPrimary,
                  cursorHeight: 24,
                  cursorWidth: 10,
                  maxLength: 20,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  _saveName(); // Guardar el nombre
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  backgroundColor: AppColors.buttonIntro,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  child: Text(
                    'Guardar',
                    style: TextStyle(fontSize: 20, color: Colors.white),
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
