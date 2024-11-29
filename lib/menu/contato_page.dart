import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _phoneController = TextEditingController();
  final _mobileController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Chave para o formulário

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // Carregar os dados salvos
  void _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _phoneController.text = prefs.getString('phone') ?? ''; // Se não existir, fica vazio
      _mobileController.text = prefs.getString('mobile') ?? ''; // Se não existir, fica vazio
    });
  }

  // Limpar os campos
  void _clearFields() {
    setState(() {
      _phoneController.clear();
      _mobileController.clear();
    });
  }

  // Salvar os dados no SharedPreferences
  void _save() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Salvar os valores dos campos
      await prefs.setString('phone', _phoneController.text);
      await prefs.setString('mobile', _mobileController.text);

      // Exibir a mensagem de sucesso quando a validação estiver ok
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Alteração feita com sucesso!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(168, 204, 171, 244),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contato"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Atribui a chave do formulário
          child: Column(
            children: [
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefone Fixo'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, preencha o telefone fixo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _mobileController,
                decoration:
                    const InputDecoration(labelText: 'Telefone Celular'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, preencha o telefone celular';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _clearFields,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 123, 126, 122),
                      foregroundColor: Colors.white,
                      minimumSize:
                          const Size(10, 30), // Largura e altura do botão
                    ),
                    child: const Text('Limpar'),
                  ),
                  const SizedBox(width: 10), // Espaçamento entre os botões
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(168, 204, 171, 244),
                      foregroundColor: Colors.white,
                      minimumSize:
                          const Size(30, 35), // Largura e altura do botão
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
}
