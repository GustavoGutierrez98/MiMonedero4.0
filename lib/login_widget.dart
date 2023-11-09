import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mimonedero/main.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorText = ''; // Variable para almacenar el mensaje de error.

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black, // Cambia el color de fondo a negro
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Column(
            children: [
              Icon(
                Icons.account_balance_wallet, // Cambia el icono según tus preferencias
                size: 48,
                color: Colors.deepOrange,
              ),
              SizedBox(height: 10),
              Text(
                'Mi Monedero', // Agregar el título aquí
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Cambia el color del texto a blanco
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: emailController,
            cursorColor: Colors.deepOrange,
            textInputAction: TextInputAction.next,
            onChanged: (text) {
              setState(() {
                errorText = ''; // Borrar el mensaje de error al modificar el campo de correo.
              });
            },
            decoration: const InputDecoration(
              labelText: 'Correo Electrónico',
              labelStyle: TextStyle(color: Colors.white), // Cambia el color del texto del campo de entrada
              hintStyle: TextStyle(color: Colors.white), // Cambia el color del texto de sugerencia
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white), // Cambia el color de la línea cuando el campo está enfocado
              ),
            ),
            style: const TextStyle(color: Colors.white), // Cambia el color del texto del campo de entrada
          ),
          const SizedBox(
            height: 4,
          ),
          TextField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            onChanged: (text) {
              setState(() {
                errorText = ''; // Borrar el mensaje de error al modificar el campo de contraseña.
              });
            },
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              labelStyle: TextStyle(color: Colors.white), // Cambia el color del texto del campo de entrada
              hintStyle: TextStyle(color: Colors.white), // Cambia el color del texto de sugerencia
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white), // Cambia el color de la línea cuando el campo está enfocado
              ),
            ),
            obscureText: true,
            style: const TextStyle(color: Colors.white), // Cambia el color del texto del campo de entrada
          ),
          Text(
            errorText, // Mostrar el mensaje de error.
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50), backgroundColor: Colors.deepOrange, // Cambia el color del botón
            ),
            icon: const Icon(Icons.lock_open, size: 32),
            label: const Text(
              'Iniciar',
              style: TextStyle(fontSize: 24, color: Colors.white), // Cambia el color del texto del botón a blanco
            ),
            onPressed: signIn,
          ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );


  Future signIn() async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator())
  );

  final email = emailController.text.trim();
  final password = passwordController.text.trim();
  
  if (email.isEmpty || password.isEmpty) {
    setState(() {
      errorText = 'Por favor, completa todos los campos.';
    });

    // Cerrar el diálogo de progreso.
    Navigator.of(context).pop();
    
    return; // No intentar iniciar sesión si hay campos vacíos.
  }

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  // ignore: unused_catch_clause
  } on FirebaseAuthException catch (e) {
    setState(() {
      errorText = 'Correo o contraseña incorrectos';
    });
  }

  // Cerrar el diálogo de progreso después de intentar iniciar sesión.
  // ignore: use_build_context_synchronously
  Navigator.of(context).pop();

  navigatorKey.currentState!.popUntil((route) => route.isFirst);
}

}
