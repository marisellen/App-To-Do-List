import 'package:app_to_do_list/database/database_helper.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onCategoriesUpdated; // Callback para atualizar categorias

  const CategoriesPage({super.key, required this.onCategoriesUpdated});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  // Inicializa a lista de categorias como vazia
  final List<Map<String, dynamic>> _categories = [];
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  // Método para adicionar categoria ao banco de dados
  Future<void> _addCategory() async {
    if (_categoryController.text.isNotEmpty) {
      String categoryName = _categoryController.text;
      int categoryId = await DatabaseHelper().addCategory(categoryName); // Salva a categoria no banco
      setState(() {
        _categories.add({
          'id': categoryId,
          'name': categoryName,
          'tasks': <String>[], // Inicialmente sem tarefas
        });
        _categoryController.clear();
        widget.onCategoriesUpdated(_categories); // Atualiza a lista de categorias na HomePage
      });
    } else {
      // Exibe um alerta se a categoria estiver vazia
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O nome da categoria não pode estar vazio!')),
      );
    }
  }

  // Método para carregar as categorias do banco de dados
  Future<void> _loadCategories() async {
    List<Map<String, dynamic>> categories = await DatabaseHelper().getCategories(); // Carrega as categorias
    setState(() {
      _categories.clear(); // Limpa as categorias antes de adicionar as carregadas
      _categories.addAll(categories); // Adiciona as categorias carregadas
    });
  }

  // Método para adicionar tarefa à categoria
  void _addTaskToCategory(int index) {
    TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Tarefa'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(labelText: 'Nome da tarefa'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (taskController.text.isNotEmpty) {
                  final db = DatabaseHelper();

                  // Adiciona a tarefa
                  int taskId = await db.addTask(taskController.text);

                  // Associa a tarefa à categoria
                  int categoryId = _categories[index]['id'];
                  await db.updateTaskCategory(taskId, categoryId);

                  setState(() {
                    // Atualiza a lista de tarefas e categorias
                    _categories[index]['tasks'] = _categories[index]['tasks'] ?? [];
                    _categories[index]['tasks'].add(taskController.text); // Garante que 'tasks' nunca seja null
                    widget.onCategoriesUpdated(_categories); // Atualiza a lista de categorias
                  });

                  Navigator.of(context).pop();
                } else {
                  // Exibe um alerta se o nome da tarefa estiver vazio
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('O nome da tarefa não pode estar vazio!')),
                  );
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCategories(); // Carrega as categorias ao iniciar, mas a lista inicial é vazia
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Adicionar nova categoria',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addCategory,
              child: const Text('Adicionar Categoria'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final tasks = category['tasks'] ?? []; // Garante que 'tasks' nunca seja null
                  return Card(
                    child: ListTile(
                      title: Text(category['name']),
                      subtitle: Text('Tarefas: ${tasks.join(', ')}'), // Exibe tarefas
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _addTaskToCategory(index),
                      ),
                    ),
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
