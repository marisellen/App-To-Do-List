import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onCategoriesUpdated; // Callback para atualizar categorias

  const CategoriesPage({Key? key, required this.onCategoriesUpdated}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final List<Map<String, dynamic>> _categories = []; 
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  void _addCategory() {
    if (_categoryController.text.isNotEmpty) {
      setState(() {
        _categories.add({
          'name': _categoryController.text,
          'tasks': <String>[], 
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
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  setState(() {
                    _categories[index]['tasks'].add(taskController.text);
                    widget.onCategoriesUpdated(_categories); // Atualiza a lista de categorias
                    Navigator.of(context).pop();
                  });
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
                  return Card(
                    child: ListTile(
                      title: Text(category['name']),
                      subtitle: Text('Tarefas: ${category['tasks'].join(', ')}'),
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
