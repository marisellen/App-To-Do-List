import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importação do SharedPreferences

import 'theme_manager.dart';

// Instância para gerenciar notificações locais
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
  bool _notificationsEnabled = false; // Estado para gerenciar a ativação das notificações

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings(); // Carrega as configurações de notificação ao iniciar
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Função para carregar as configurações de notificação salvas
  void _loadNotificationSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? false; // Carrega o estado salvo
    });
  }

  // Função para salvar as configurações de notificação
  void _saveNotificationSettings(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifications_enabled', value); // Salva o estado das notificações
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
            // Switch para trocar o tema entre claro e escuro
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

            // Campo de texto para mudar a senha
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Mudar Senha',
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20.0),

            // Switch para ativar/desativar notificações
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Notificações'),
                Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value; // Atualiza o estado
                      _saveNotificationSettings(value); // Salva o estado
                    });
                    if (value) {
                      showNotification(); // Chama a função para mostrar a notificação se ativado
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Botão para salvar as configurações
            ElevatedButton(
              onPressed: () {
                // Exibe uma mensagem de confirmação de salvamento
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Configurações salvas com sucesso')),
                );
              },
              child: const Text('Salvar Configurações'),
            ),
          ],
        ),
      ),
    );
  }

  // Função para mostrar uma notificação
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

