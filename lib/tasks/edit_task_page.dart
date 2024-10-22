import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa a biblioteca intl para formatação de data

class EditTaskPage extends StatefulWidget {
  final Map<String, dynamic> task;
  final List<Map<String, dynamic>> categories; // Recebe a lista de categorias
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
  String? selectedCategory; // Mudar para nullable

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.task['date'];
    _selectedTime = widget.task['time'];
    titleController.text = widget.task['title'];
    descriptionController.text = widget.task['description'];
    
    // Verifique se a categoria existe nas categorias
    selectedCategory = widget.categories
        .map((category) => category['name'])
        .contains(widget.task['category']) ? widget.task['category'] : null; 
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
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 16.0),

            // Botão para selecionar a data
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(_selectedDate == null
                  ? 'Selecionar Data'
                  : 'Data: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}'),
            ),
            const SizedBox(height: 16.0),

            // Botão para selecionar o horário
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text(_selectedTime == null
                  ? 'Selecionar Horário'
                  : 'Horário: ${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'),
            ),
            const SizedBox(height: 16.0),

            // Dropdown para selecionar a categoria
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
              onPressed: titleController.text.isEmpty ||
                      descriptionController.text.isEmpty ||
                      selectedCategory == null // Verifique se está nulo
                  ? null
                  : () {
                      widget.onSave({
                        'title': titleController.text,
                        'description': descriptionController.text,
                        'category': selectedCategory,
                        'completed': widget.task['completed'],
                        'date': _selectedDate,
                        'time': _selectedTime,
                      });
                      Navigator.of(context).pop();
                    },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
