import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Certifique-se de importar o provider corretamente

import 'theme_manager.dart';

class SettingsPage extends StatefulWidget {
  static String tag = 'settings-page'; // Usado para navegação por rotas
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Controladores para obter os valores dos campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variável para controlar o status das notificações
  bool _notificationsEnabled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Acessa o ThemeManager via Provider
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Trocar Tema
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tema Escuro'),
                Switch(
                  value: themeManager.isDarkTheme,
                  onChanged: (value) {
                    themeManager.toggleTheme(); // Alterna o tema ao trocar o switch
                  },
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Campo de Nome
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Mudar Nome',
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20.0),

            // Campo de E-mail
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Mudar E-mail',
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20.0),

            // Campo de Senha
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Mudar Senha',
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20.0),

            // Botão de Notificações
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Notificações'),
                Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value; // Alterna o status das notificações
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Botão de Salvar Configurações
            ElevatedButton(
              onPressed: () {
                // Exibe mensagem de confirmação de salvamento
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Configurações salvas com sucesso')),
                );
                // Aqui você pode adicionar lógica para persistir as configurações, se necessário.
              },
              child: const Text('Salvar Configurações'),
            ),
          ],
        ),
      ),
    );
  }
}
