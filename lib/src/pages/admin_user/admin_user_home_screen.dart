import 'package:flutter/material.dart';

class AdminUserHomeScreen extends StatefulWidget {
  const AdminUserHomeScreen({super.key});

  @override
  State<AdminUserHomeScreen> createState() => _AdminUserHomeScreenState();
}

class _AdminUserHomeScreenState extends State<AdminUserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pantalla de Administrador')),
      body: const Center(child: Text('¡Bienvenida, administradora!')),
    );
  }
}
