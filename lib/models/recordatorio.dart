import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class Reminder {
  String serviceName;
  DateTime date;

  Reminder({required this.serviceName, required this.date});
}


class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final List<Reminder> reminders = [];

  final TextEditingController _serviceNameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _addReminder() async {
    if (_serviceNameController.text.isNotEmpty) {
      final newReminder = Reminder(
        serviceName: _serviceNameController.text,
        date: _selectedDate,
      );

      await scheduleNotification(newReminder);

      setState(() {
        reminders.add(newReminder);
        _serviceNameController.clear();
      });
    }
  }

  Future<void> scheduleNotification(Reminder reminder) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  // Ensure that the DateTime is in the future
  final DateTime now = DateTime.now();
  final DateTime scheduledDateTime =
      reminder.date.isAfter(now) ? reminder.date : now.add(Duration(seconds: 1));

  final tz.TZDateTime scheduledDate =
      tz.TZDateTime.from(scheduledDateTime, tz.local);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Recordatorio de Pago',
    'Pagar ${reminder.serviceName} hoy',
    scheduledDate,
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recordatorios de Pagos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _serviceNameController,
              decoration: InputDecoration(labelText: 'Nombre del Servicio'),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Fecha de Pago: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                ),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _addReminder,
            child: Text('Agregar Recordatorio'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return ListTile(
                  title: Text('${reminder.serviceName} - ${DateFormat('dd/MM/yyyy').format(reminder.date)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}