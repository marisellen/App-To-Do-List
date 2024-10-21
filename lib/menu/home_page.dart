import 'package:app_to_do_list/configure/settings-page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page'; // Usado para navegação por rotas
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _tasks = []; // Lista de tarefas
  final TextEditingController _taskController = TextEditingController(); // Controlador para o campo de tarefa

  @override
  void dispose() {
    _taskController.dispose(); // Limpa o controlador quando a página é destruída
    super.dispose();
  }

  // Método para adicionar uma nova tarefa
  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add({
          'title': _taskController.text,
          'completed': false, // Define como não concluída
        });
        _taskController.clear(); // Limpa o campo de entrada
      });
      // Exibe uma notificação ao adicionar uma nova tarefa
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarefa "${_taskController.text}" adicionada!')),
      );
    }
  }

  // Método para alternar o status da tarefa
  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed']; // Alterna o status da tarefa
    });
  }

  // Método para editar uma tarefa
  void _editTask(int index) {
    _taskController.text = _tasks[index]['title']; // Define o texto no controlador
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Tarefa'),
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              labelText: 'Nova tarefa',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                setState(() {
                  _tasks[index]['title'] = _taskController.text; // Atualiza o título
                  Navigator.of(context).pop(); // Fecha o diálogo
                  _taskController.clear(); // Limpa o campo de entrada
                });
              },
            ),
          ],
        );
      },
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
              Navigator.of(context).pushNamed(SettingsPage.tag); // Navega para a página de configurações
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Campo para adicionar nova tarefa
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'Adicionar nova tarefa',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Botão para adicionar tarefa
            ElevatedButton(
              onPressed: _addTask,
              child: const Text('Adicionar Tarefa'),
            ),
            const SizedBox(height: 16.0),

            // Lista de tarefas
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _tasks[index]['title'],
                      style: TextStyle(
                        decoration: _tasks[index]['completed']
                            ? TextDecoration.lineThrough
                            : null, // Risca a tarefa se estiver concluída
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editTask(index), // Chama o método de edição
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _tasks.removeAt(index); // Remove a tarefa da lista
                            });
                          },
                        ),
                      ],
                    ),
                    onTap: () => _toggleTaskCompletion(index), // Marca a tarefa como concluída ao tocar
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
