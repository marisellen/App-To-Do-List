import 'package:app_to_do_list/login/login_page.dart';
import 'package:app_to_do_list/menu/home_page.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page'; // Usado para navegação por rotas
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Aqui você pode adicionar a lógica de registro
      // Se o registro for bem-sucedido, navegue para a HomePage
      Navigator.of(context).pushReplacementNamed(HomePage.tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Campo de e-mail
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Campo de senha
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Botão de registro
              ElevatedButton(
                onPressed: _register,
                child: const Text('Cadastrar'),
              ),
              const SizedBox(height: 16.0),

              // Link para login
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(LoginPage.tag); // Navega para a página de login
                },
                child: const Text('Já tem uma conta? Faça login!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
