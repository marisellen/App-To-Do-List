import 'package:flutter/material.dart';

class PersonalDataPage extends StatefulWidget {
  const PersonalDataPage({super.key});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    _nameController.text = 'User';
    _emailController.text = 'user@example.com';
    _birthDate = DateTime(1990, 5, 25);
    _updateBirthDateField();
  }

  void _updateBirthDateField() {
    if (_birthDate != null) {
      _birthDateController.text =
          '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}';
    } else {
      _birthDateController.clear();
    }
  }

  void _clearFields() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _birthDate = null;
      _birthDateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dados Pessoais"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _birthDateController,
                    decoration: const InputDecoration(
                      labelText: 'Data de Nascimento',
                      hintText: 'Selecione a data',
                    ),
                    validator: (value) {
                      if (_birthDate == null) {
                        return 'Por favor, selecione a data de nascimento';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _clearFields,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(168, 204, 171, 244),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Limpar'),
                  ),
                  const SizedBox(width: 10), // Espaço entre os botões
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Retornar os dados para a ProfilePage
                        Navigator.pop(context, {
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'birthDate': _birthDate,
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(168, 204, 171, 244),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        _updateBirthDateField();
      });
    }
  }
}
