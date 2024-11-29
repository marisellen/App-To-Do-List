import 'package:app_to_do_list/configure/settings-page.dart';
import 'package:app_to_do_list/database/database_helper.dart';
import 'package:app_to_do_list/reminders/reminders_page.dart';
import 'package:app_to_do_list/tasks/categories_page.dart';
import 'package:app_to_do_list/tasks/edit_task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'perfil_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

  final initializationSettingsAndroid = AndroidInitializationSettings('app_icon'); // Use o nome do ícone que você adicionou

  final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        SettingsPage.tag: (context) => const SettingsPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> _categories = []; // Agora as categorias estão no estado da HomePage
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTasks();  // Carregar tarefas do banco de dados ao inicializar
  }

  void _loadTasks() async {
    final tasks = await DatabaseHelper().getTasks();  // Carregar tarefas do banco
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _addTask() async {
    if (_taskController.text.isNotEmpty) {
      await DatabaseHelper().addTask(_taskController.text);  // Adicionar tarefa no banco de dados
      _loadTasks();  // Recarregar lista de tarefas
      _taskController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarefa "${_taskController.text}" adicionada!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O título da tarefa não pode estar vazio!')),
      );
    }
  }

  void _toggleTaskCompletion(int index) async {
    final task = _tasks[index];
    final newCompletedStatus = task['completed'] == 0 ? 1 : 0;
    await DatabaseHelper().updateTask(task['id'], completed: newCompletedStatus);  // Atualizar status da tarefa no banco
    _loadTasks();  // Recarregar lista de tarefas
  }

void _openEditTaskPage(int index) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => EditTaskPage(
        task: _tasks[index],
        categories: _categories,  // Passa as categorias aqui
        onSave: (updatedTask) {
        setState(() {
          _tasks = List.from(_tasks); // Cria uma nova lista mutável
          _tasks[index] = updatedTask;
        });
        },
      ),
    ),
  );
}

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  List<Map<String, dynamic>> _filteredTasks() {
    if (_searchQuery.isEmpty) {
      return _tasks;
    }
    return _tasks.where((task) {
      final taskTitle = task['title'].toLowerCase();
      return taskTitle.contains(_searchQuery);
    }).toList();
  }

void _openCategoriesPage() {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => CategoriesPage(
        onCategoriesUpdated: (categories) {
          setState(() {
            _categories.clear();
            _categories.addAll(categories);
          });
        },
      ),
    ),
  );
}


  void _openRemindersPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RemindersPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsPage.tag);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _searchController,
              onChanged: _updateSearchQuery,
              decoration: InputDecoration(
                labelText: 'Pesquisar tarefas',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'Adicionar nova tarefa',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredTasks().length,
                itemBuilder: (context, index) {
                  final task = _filteredTasks()[index];
                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: task['completed'] == 1,  // Verificando se está concluída
                        onChanged: (value) {
                          _toggleTaskCompletion(index);  // Alterar status de concluída
                        },
                      ),
                      title: Text(
                        task['title'],
                        style: TextStyle(
                          decoration: task['completed'] == 1
                              ? TextDecoration.lineThrough
                              : null,  // Riscar tarefa se concluída
                        ),
                      ),
                      subtitle: Text('Categoria: ${task['category']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _openEditTaskPage(index),  // Editar tarefa
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await DatabaseHelper().deleteTask(task['id']);  // Excluir tarefa do banco
                              _loadTasks();  // Recarregar tarefas após exclusão
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _openCategoriesPage,
                    child: const Text('Categorias'),
                  ),
                  ElevatedButton(
                    onPressed: _addTask,
                    child: const Text('Adicionar Tarefa'),
                  ),
                  ElevatedButton(
                    onPressed: _openRemindersPage,
                    child: const Text('Lembretes'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}