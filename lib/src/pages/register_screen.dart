import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Crear el usuario en Firebase Auth
        final UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        final userId = userCredential.user!.uid;

        // Guardar información adicional en Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'nombre': _nameController.text.trim(),
          'apellido': _surnameController.text.trim(),
          'correo': _emailController.text.trim(),
          'rol': 'usuario', // por defecto
        });

        // Ir a la pantalla de login u otra
        Navigator.pushReplacementNamed(context, 'login');
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Ocurrió un error';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'El correo ya está en uso.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'La contraseña es muy débil.';
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrarse')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa tu nombre' : null,
              ),
              TextFormField(
                controller: _surnameController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa tu apellido' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return 'Ingresa tu correo';
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  return emailRegex.hasMatch(value)
                      ? null
                      : 'Ingresa un correo válido';
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) =>
                    value!.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar contraseña',
                ),
                obscureText: true,
                validator: (value) => value != _passwordController.text
                    ? 'Las contraseñas no coinciden'
                    : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _registerUser,
                      child: const Text('Registrarse'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
