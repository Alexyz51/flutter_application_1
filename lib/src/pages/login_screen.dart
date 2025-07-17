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
      final rol = data['rol'];

      if (rol == 'usuario') {
        Navigator.pushReplacementNamed(context, 'user_home');
      } else if (rol == 'administrador') {
        Navigator.pushReplacementNamed(context, 'admin_home');
      } else {
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
    const azulGrisClaro = Color.fromARGB(255, 175, 183, 197);

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackButton(color: Colors.black),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/book.png', height: 100),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Registro Anecdótico',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: azulGrisClaro,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: "Correo electrónico",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "Contraseña",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: azulGrisClaro,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Ingresar"),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'register');
                          },
                          child: Text(
                            "¿No tienes cuenta? Regístrate aquí",
                            style: TextStyle(color: azulGrisClaro),
                          ),
                        ),
                      ],
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
