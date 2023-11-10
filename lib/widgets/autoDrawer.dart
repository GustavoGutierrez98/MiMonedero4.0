import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class autoDrawer extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepOrange,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ingresado como: ',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
           ListTile(
            title: const Text('Opcion 1'),
            onTap: () {
              // Acciones para la opción 1
            },
          ),
           ListTile(
            title: const Text('Opcion 2'),
            onTap: () {
              // Acciones para la opción 1
            },
          ),
           ListTile(
            title: const Text('Opcion 3'),
            onTap: () {
              // Acciones para la opción 1
            },
          ), 
          // Aqui podemos generar mas opciones al drawer
          Divider(
            color: Colors.orange,
          ),
          ListTile(
              title: const Text('Cerrar sesion'),   
              onTap: () {
                FirebaseAuth.instance.signOut();
              }) //genera un divisor visual
        ],
      ),
    );
  }
}
