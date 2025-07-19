import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/widgets/breadcrumb_navigation.dart';
import 'package:flutter_application_1/src/pages/admin_user/csv_import_screen.dart'; // Importación agregada

class EditListScreen extends StatelessWidget {
  const EditListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Anecdótico'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BreadcrumbBar(
              items: [
                BreadcrumbItem(
                  label: 'Inicio',
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, 'admin_home'),
                ),
                BreadcrumbItem(
                  label: 'Editar Lista',
                  onTap: null, // Pantalla actual, no clickable
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CsvImportScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Importar desde CSV'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
