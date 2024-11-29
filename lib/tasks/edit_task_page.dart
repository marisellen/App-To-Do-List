import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class EditTaskPage extends StatefulWidget {
  final Map<String, dynamic> task;
  final List<Map<String, dynamic>> categories; 
=======
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class EditTaskPage extends StatefulWidget {
  final Map<String, dynamic> task;
  final List<Map<String, dynamic>> categories;
>>>>>>> SextaVer
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
<<<<<<< HEAD
    _selectedDate = widget.task['date'];
    _selectedTime = widget.task['time'];
    titleController.text = widget.task['title'];
    descriptionController.text = widget.task['description'];
    selectedCategory = widget.categories
            .map((category) => category['name'])
            .contains(widget.task['category'])
        ? widget.task['category']
        : null;
=======
    _selectedDate = widget.task['date'] != null
        ? DateTime.parse(widget.task['date'])
        : null;
    _selectedTime = widget.task['time'] != null
        ? TimeOfDay(
            hour: int.parse(widget.task['time'].split(':')[0]),
            minute: int.parse(widget.task['time'].split(':')[1]),
          )
        : null;
    titleController.text = widget.task['title'];
    descriptionController.text = widget.task['description'] ?? '';
    selectedCategory = widget.task['category'];
>>>>>>> SextaVer
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
=======
  Future<void> updateTask(BuildContext context, Map<String, dynamic> updatedTask) async {
    final db = Provider.of<Database>(context, listen: false);

    await db.update(
      'tasks',
      {
        'title': updatedTask['title'],
        'description': descriptionController.text.isNotEmpty ? descriptionController.text : null,
        'category_id': updatedTask['category_id'], // Atualize para usar category_id
        'date': updatedTask['date']?.toIso8601String(),
        'time': updatedTask['time'] != null
            ? '${updatedTask['time']!.hour}:${updatedTask['time']!.minute}'
            : null,
        'completed': updatedTask['completed'] == true ? 1 : 0, // Armazena como 0 ou 1
      },
      where: 'id = ?',
      whereArgs: [updatedTask['id']],
    );
  }

>>>>>>> SextaVer
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
<<<<<<< HEAD
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        selectedCategory != null;
  }

  Future<void> _scheduleNotification(DateTime scheduledDate) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      channelDescription: 'Notificações de tarefas',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
=======
    return titleController.text.isNotEmpty && selectedCategory != null;
>>>>>>> SextaVer
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
<<<<<<< HEAD
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
=======
                  ? () async {
                      final updatedTask = {
                        'id': widget.task['id'],
                        'title': titleController.text,
                        'description': descriptionController.text,
                        'category': selectedCategory,
                        'date': _selectedDate,
                        'time': _selectedTime,
                        'completed': widget.task['completed'],
                      };

                      await updateTask(context, updatedTask);
                      widget.onSave(updatedTask);
>>>>>>> SextaVer
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
