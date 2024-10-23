import 'package:app_to_do_list/configure/settings-page.dart';
import 'package:app_to_do_list/reminders/reminders_page.dart';
import 'package:app_to_do_list/tasks/categories_page.dart';
import 'package:app_to_do_list/tasks/edit_task_page.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _tasks = [];
  final List<Map<String, dynamic>> _categories = []; // Lista de categorias
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _taskController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add({
          'title': _taskController.text,
          'completed': false,
          'category': 'Sem Categoria',
          'date': null,
          'description': '',
          'reminder': null,
        });
        _taskController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarefa "${_taskController.text}" adicionada!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O título da tarefa não pode estar vazio!')),
      );
    }
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
    });
  }

  void _openEditTaskPage(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTaskPage(
          task: _tasks[index],
          categories: _categories, // Passa a lista de categorias
          onSave: (updatedTask) {
            setState(() {
              _tasks[index] = updatedTask; // Atualiza a tarefa com os novos dados
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

  // Método para abrir a página de categorias
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
    ).then((_) {
      // Atualiza a lista de categorias quando voltar da CategoriesPage
      setState(() {});
    });
  }

  // Método para abrir a página de lembretes
  void _openRemindersPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RemindersPage(), // Navegando para a página de lembretes
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
                        value: task['completed'],
                        onChanged: (value) {
                          _toggleTaskCompletion(_tasks.indexOf(task));
                        },
                      ),
                      title: Text(
                        task['title'],
                        style: TextStyle(
                          decoration: task['completed']
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Text('Categoria: ${task['category']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _openEditTaskPage(_tasks.indexOf(task)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _tasks.remove(task);
                              });
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Alinha os botões
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
