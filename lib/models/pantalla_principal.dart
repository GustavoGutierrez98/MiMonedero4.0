import 'package:flutter/material.dart';
import 'package:mimonedero/database/db.dart';
import 'package:mimonedero/widgets/navbar.dart';
import 'package:mimonedero/widgets/autoDrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double totalBalance = 0.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadTotalBalance();
  }

  Future<void> _loadTotalBalance() async {
    try {
      final totalIngresos = await getTotalIngresos();
      final totalPagos = await getTotalPagos();

      setState(() {
        totalBalance = totalIngresos - totalPagos;
      });
    } catch (error) {
      print('Error al cargar el saldo total: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadTotalBalance(),
      builder: (context, snapshot) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text('Mi Monedero'),
            backgroundColor: Colors.deepOrange,
            actions: [
              IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              )
            ],
          ),
          endDrawer: autoDrawer(),
          backgroundColor: Colors.white,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bank.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
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
                      selectionColor: Colors.deepOrange,
                    ),
                    Text(
                      '\$${totalBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: const NavBar(),
        );
      },
    );
  }

  Future<double> getTotalIngresos() async {
    final ingresos = await BalanceDatabase.instance.getAllBalances();
    return ingresos.fold<double>(0.0, (total, ingreso) => ingreso.amount);
  }

  Future<double> getTotalPagos() async {
    final pagos = await PaymentDatabase.instance.getAllPayments();
    return pagos.fold<double>(0.0, (total, pago) => pago.amount);
  }
}
