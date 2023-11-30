import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<String> services = ['Agua', 'Luz', 'Cable', 'Internet'];
  String selectedService = 'Agua'; // Default to 'Agua'
  int months = 1; // Default to 1 month

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    scheduleNotifications(); // Schedule notifications on app startup
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mimonedero.png');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle user's action when clicking on the notification
    print('Notification selected with payload: $payload');
  }

  Future<void> scheduleNotification(String serviceName, DateTime date) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'payment_channel',
      'Recordatorios de Pagos',
      'Notificación de Recordatorio de Pago',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Recordatorio de Pago',
      'Recuerda pagar tu servicio de $serviceName',
      date,
      platformChannelSpecifics,
      payload: 'payload',
    );
  }

  void scheduleNotifications() {
    // Simulate the process of adding a new reminder for the selected service and date.
    DateTime reminderDate = DateTime.now().add(Duration(days: months * 30));
    scheduleNotification(selectedService, reminderDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordatorios de Pagos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: selectedService,
              items: services.map((String service) {
                return DropdownMenuItem<String>(
                  value: service,
                  child: Text(service),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedService = newValue ?? 'Agua';
                  scheduleNotifications(); // Reschedule notifications when service is changed
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Seleccionar Fecha:'),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != DateTime.now()) {
                      setState(() {
                        months = pickedDate.difference(DateTime.now()).inDays ~/ 30;
                        scheduleNotifications(); // Reschedule notifications when date is changed
                      });
                    }
                  },
                  child: const Text('Seleccionar'),
                ),
                Text('$months meses(s)'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulate the process of adding a new reminder for the selected service and date.
                DateTime reminderDate = DateTime.now().add(Duration(days: months * 30));
                scheduleNotification(selectedService, reminderDate);
              },
              child: const Text('Agregar Recordatorio de Pago'),
            ),
          ],
        ),
      ),
    );
  }
}