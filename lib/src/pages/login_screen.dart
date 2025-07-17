import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Logger logger = Logger();

  Future<void> _login() async {
    try {
      final email = emailController.text.trim().toLowerCase();
      final password = passwordController.text.trim();

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;
      logger.i("UID obtenido tras login: $uid");

      // 🔄 CAMBIO AQUÍ: de 'usuarios' a 'users'
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('correo', isEqualTo: email)
          .limit(1)
          .get();

      logger.i("Documentos encontrados: ${querySnapshot.docs.length}");

      if (querySnapshot.docs.isEmpty) {
        logger.w("No existe el usuario con correo $email en Firestore.");
        _mostrarDialogo("Error", "No se encontró información del usuario.");
        return;
      }

      final data = querySnapshot.docs.first.data();
      logger.i("Datos del usuario: $data");

      final rol = data['rol'];
      logger.i("Rol obtenido: $rol");

      if (rol == 'usuario') {
        Navigator.pushReplacementNamed(context, 'user_home');
      } else if (rol == 'administrador') {
        Navigator.pushReplacementNamed(context, 'admin_home');
      } else {
        logger.w("Rol no reconocido: $rol");
        _mostrarDialogo("Error", "Rol no reconocido: $rol");
      }
    } catch (e) {
      logger.e("Error al iniciar sesión: $e");
      _mostrarDialogo("Error", "Correo o contraseña incorrectos.");
    }
  }

  void _mostrarDialogo(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            child: const Text("Cerrar"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Iniciar Sesión")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Correo electrónico",
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text("Ingresar")),
          ],
        ),
      ),
    );
  }
}
