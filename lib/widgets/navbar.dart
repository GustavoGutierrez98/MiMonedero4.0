import 'package:flutter/material.dart';
import 'package:mimonedero/models/pagos.dart';
import 'package:mimonedero/models/pantalla_principal.dart';
import 'package:mimonedero/models/ingreso.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation as before
    if (index == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => IngresoDinero()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => VentanaPago()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on),
          label: 'Depositar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payment),
          label: 'Pagos',
        ),
      ],
      unselectedItemColor: Colors.black, // Color of unselected items
      selectedItemColor: Colors.black, // Color of the selected item
      backgroundColor: Colors.deepOrange, // Background color of the navigation bar
      currentIndex: _selectedIndex, // Set the current selected index
      onTap: _onItemTapped,
    );
  }
}
