import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mimonedero/database/db.dart';
import 'package:mimonedero/widgets/navbar.dart'; // Import your database clas
import 'package:mimonedero/widgets/autoDrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double totalBalance = 0.0; // Initialize the total balance
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadTotalBalance();
  }

  Future<void> _loadTotalBalance() async {
    final balance = await getTotalBalance();
    setState(() {
      totalBalance = balance;
    });
  }

  void updateTotalBalance(double paymentAmount) {
    setState(() {
      totalBalance = totalBalance - paymentAmount; // Decrease the total balance
    });
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<double>(
      // Use a FutureBuilder to fetch the total balance
      future:
          getTotalBalance(), // Define this function to fetch the total balance
      builder: (context, snapshot) {
        double totalBalance = snapshot.data ?? 0.0;
        return Scaffold(
          key: _scaffoldKey, //Asigna la llave al scaffold
          appBar: AppBar(
            title: const Text('Mi Monedero'),
            backgroundColor: Colors.deepOrange,
            actions: [
              //Drawer
              IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              )
            ],
          ),
          endDrawer: autoDrawer(), //end Drawer
          backgroundColor: Colors.white,
          body: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Saldo Total:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '\$${totalBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
          bottomNavigationBar: const NavBar(),
        );
      },
    );
  }

  Future<double> getTotalBalance() async {
    // Fetch the list of balance records
    final balances = await BalanceDatabase.instance.getAllBalances();

    // Calculate the total balance by summing up the 'amount' field
    double totalBalance =
        balances.fold(0.0, (total, balance) => total + balance.amount);

    return totalBalance;
  }
}
