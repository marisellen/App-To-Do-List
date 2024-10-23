import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addReminder() {
    if (_titleController.text.isNotEmpty && _selectedDateTime != null) {
      setState(() {
        _reminders.add(Reminder(
          title: _titleController.text,
          description: _descriptionController.text,
          dateTime: _selectedDateTime!,
        ));
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

  void _editReminder(int index) {
    _titleController.text = _reminders[index].title;
    _descriptionController.text = _reminders[index].description;
    _selectedDateTime = _reminders[index].dateTime;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Lembrete'),
          content: _buildReminderForm(),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _reminders[index] = Reminder(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    dateTime: _selectedDateTime!,
                  );
                  _titleController.clear();
                  _descriptionController.clear();
                  _selectedDateTime = null;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
  }

  Widget _buildReminderForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Título'),
        ),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(labelText: 'Descrição'),
        ),
        const SizedBox(height: 8.0),
        TextButton(
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDateTime ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (picked != null && picked != _selectedDateTime) {
              final TimeOfDay? timePicked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
              );

              if (timePicked != null) {
                setState(() {
                  _selectedDateTime = DateTime(
                    picked.year,
                    picked.month,
                    picked.day,
                    timePicked.hour,
                    timePicked.minute,
                  );
                });
              }
            }
          },
          child: Text(
            _selectedDateTime == null
                ? 'Selecionar Data e Hora'
                : 'Data: ${_selectedDateTime!.toLocal()}',
          ),
        ),
      ],
    );
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
          children: [
            _buildReminderForm(),
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
                  return Card(
                    child: ListTile(
                      title: Text(reminder.title),
                      subtitle: Text('${reminder.description}\n${reminder.dateTime}'),
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
