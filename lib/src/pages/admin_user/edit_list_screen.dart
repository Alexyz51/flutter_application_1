import 'package:flutter/material.dart';

class EditListScreen extends StatelessWidget {
  const EditListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Anecdótico'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Inicio > Editar Lista',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Center(child: Text('Aquí podrás editar la lista.'))),
        ],
      ),
    );
  }
}
