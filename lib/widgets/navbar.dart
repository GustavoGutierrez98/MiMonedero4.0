import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

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
    /*if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => IngresoDinero()));
    } else if (index == 2) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => VentanaPago()));
    }*/
    if (index == 0) {
      Navigator.pushReplacementNamed(context, 'home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, 'ingreso');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, 'pago');
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
      unselectedItemColor: Colors.black, // Color de los items no seleccionados
      selectedItemColor: Colors.black, // Color de los items seleccionados
      backgroundColor: Colors.deepOrange, // Background color del navigation bar
      currentIndex: _selectedIndex, // Set the current selected index
      onTap: _onItemTapped,
    );
  }
}
