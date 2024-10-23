import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart'; // Certifique-se de importar o provider corretamente

import 'theme_manager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class SettingsPage extends StatefulWidget {
  static String tag = 'settings-page'; // Usado para navegação por rotas
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
                    themeManager.toggleTheme();
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
                      _notificationsEnabled = value;
                      if (_notificationsEnabled) {
                        showNotification();
                      }
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
                  const SnackBar(
                      content: Text('Configurações salvas com sucesso')),
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

  // Função para mostrar a notificação
  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // ID do canal
      'your_channel_name', // Nome do canal
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // ID da notificação
      'Título da Notificação', // Título
      'Corpo da Notificação', // Corpo
      platformChannelSpecifics,
      payload: 'item x', // Dado opcional para identificar a notificação
    );
  }
}
