import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'configure/settings-page.dart';
import 'configure/theme_manager.dart';
import 'login/login_page.dart';
import 'login/register_page.dart';
import 'menu/home_page.dart';

// Instância para gerenciar notificações locais
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Configuração para inicializar notificações no Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Inicialização do plugin de notificações
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Inicialização das time zones
  tz.initializeTimeZones();

  // Inicializando o banco de dados SQLite
  final Database database = await initDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeManager()),
        Provider(create: (context) => database), // Banco de dados fornecido no app
      ],
      child: const MyApp(),
    ),
  );
}

Future<Database> initDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'tasks.db');

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, done INTEGER NOT NULL)',
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: themeManager.isDarkTheme ? Brightness.dark : Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: LoginPage.tag,
      routes: {
        LoginPage.tag: (context) => const LoginPage(),
        RegisterPage.tag: (context) => const RegisterPage(),
        SettingsPage.tag: (context) => const SettingsPage(),
        HomePage.tag: (context) => const HomePage(),
      },
      home: Scaffold(
        appBar: AppBar(title: const Text('Notificações Locais')),
        body: Center(
          child: ElevatedButton(
            onPressed: showNotification, // Botão para mostrar notificação
            child: const Text('Mostrar Notificação'),
          ),
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