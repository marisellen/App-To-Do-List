import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz; // Importando o pacote timezone

class EditTaskPage extends StatefulWidget {
  final Map<String, dynamic> task;
  final List<Map<String, dynamic>> categories; 
  final Function(Map<String, dynamic>) onSave;

  const EditTaskPage({
    required this.task,
    required this.categories,
    required this.onSave,
  });

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedCategory; 

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.task['date'];
    _selectedTime = widget.task['time'];
    titleController.text = widget.task['title'];
    descriptionController.text = widget.task['description'];
    selectedCategory = widget.categories
            .map((category) => category['name'])
            .contains(widget.task['category'])
        ? widget.task['category']
        : null;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  bool _isFormValid() {
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        selectedCategory != null;
  }

  Future<void> _scheduleNotification(DateTime scheduledDate) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'task_channel', // ID do canal
      'Task Notifications', // Nome do canal
      channelDescription: 'Notificações de tarefas',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Converte DateTime para TZDateTime
    tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    await FlutterLocalNotificationsPlugin().zonedSchedule(
      0,
      'Lembrete de Tarefa',
      titleController.text,
      tzScheduledDate,
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
        title: const Text('Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título da Tarefa'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              onChanged: (_) => setState(() {}),
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(_selectedDate == null
                  ? 'Selecionar Data'
                  : 'Data: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text(_selectedTime == null
                  ? 'Selecionar Horário'
                  : 'Horário: ${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'),
            ),
            const SizedBox(height: 16.0),
            DropdownButton<String>(
              value: selectedCategory,
              hint: const Text('Selecionar Categoria'),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                }
              },
              items: widget.categories.map<DropdownMenuItem<String>>(
                (Map<String, dynamic> category) {
                  return DropdownMenuItem<String>(
                    value: category['name'],
                    child: Text(category['name']),
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isFormValid()
                  ? () {
                      DateTime scheduledDate = DateTime(
                        _selectedDate!.year,
                        _selectedDate!.month,
                        _selectedDate!.day,
                        _selectedTime!.hour,
                        _selectedTime!.minute,
                      );
                      _scheduleNotification(scheduledDate);
                      widget.onSave({
                        'title': titleController.text,
                        'description': descriptionController.text,
                        'category': selectedCategory,
                        'completed': widget.task['completed'],
                        'date': _selectedDate,
                        'time': _selectedTime,
                      });
                      Navigator.of(context).pop();
                    }
                  : null,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
