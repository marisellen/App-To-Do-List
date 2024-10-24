import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Reminder {
  String title;
  String description;
  DateTime dateTime;

  Reminder({required this.title, required this.description, required this.dateTime});
}

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  _RemindersPageState createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final List<Reminder> _reminders = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDateTime;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    tz.initializeTimeZones();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addReminder() {
    if (_titleController.text.isNotEmpty && _selectedDateTime != null) {
      setState(() {
        final reminder = Reminder(
          title: _titleController.text,
          description: _descriptionController.text,
          dateTime: _selectedDateTime!,
        );
        _reminders.add(reminder);
        _scheduleNotification(reminder);
        _titleController.clear();
        _descriptionController.clear();
        _selectedDateTime = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lembrete "${_titleController.text}" adicionado!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
    }
  }

  void _scheduleNotification(Reminder reminder) async {
    tz.TZDateTime scheduledTZDateTime = tz.TZDateTime.from(reminder.dateTime, tz.local);

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Lembrete: ${reminder.title}',
      reminder.description,
      scheduledTZDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _editReminder(int index) {
    _titleController.text = _reminders[index].title;
    _descriptionController.text = _reminders[index].description;
    _selectedDateTime = _reminders[index].dateTime;

    setState(() {
      _reminders.removeAt(index);
    });
  }

  void _deleteReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lembrete excluído!')),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lembretes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título do Lembrete'),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () => _selectDateTime(context),
              child: Text(_selectedDateTime == null
                  ? 'Selecionar Data e Hora'
                  : 'Data e Hora: ${DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime!)}'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addReminder,
              child: const Text('Adicionar Lembrete'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  final reminder = _reminders[index];
                  return ListTile(
                    title: Text(reminder.title),
                    subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(reminder.dateTime)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editReminder(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteReminder(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
