import 'package:flutter/material.dart';

class EditListScreen extends StatelessWidget {
  const EditListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Student List')),
      body: const Center(
        child: Text('Aquí luego pondremos la lista de alumnos para editar'),
      ),
    );
  }
}
