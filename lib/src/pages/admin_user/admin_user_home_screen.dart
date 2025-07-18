import 'package:flutter/material.dart';
import '../widgets/breadcrumb_navigation.dart';

class AdminUserHomeScreen extends StatelessWidget {
  const AdminUserHomeScreen({super.key});

  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar lista'),
                onTap: () {
                  Navigator.pop(context);
                  // Aquí ponés la lógica para ir a editar lista
                  Navigator.pushNamed(context, 'edit_list');
                },
              ),
              // Podés agregar más opciones acá si querés
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administrador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _openMenu(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BreadcrumbBar(
          items: [
            BreadcrumbItem(
              label: 'Inicio',
              onTap: () {
                Navigator.pushReplacementNamed(context, 'admin_home');
              },
            ),
          ],
        ),
      ),
    );
  }
}
