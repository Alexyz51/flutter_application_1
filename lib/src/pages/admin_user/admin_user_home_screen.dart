import 'package:flutter/material.dart';

class AdminUserHomeScreen extends StatelessWidget {
  const AdminUserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Anecdótico'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'editar_lista') {
                Navigator.of(context).pushNamed('edit_list');
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'editar_lista',
                child: Text('Editar Lista'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // Segunda barra: ubicación actual
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Inicio',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          // Contenido principal
          Expanded(child: Center(child: Text('¡Bienvenido, administrador!'))),
        ],
      ),
    );
  }
}
