class Task {
  final int id;
  final String title;

  Task({required this.id, required this.title});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
    );
  }
}
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'task.dart';

Future<List<Task>> fetchTasks() async {
  final response = await http.get(Uri.parse('https://example.com/tasks'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((task) => Task.fromJson(task)).toList();
  } else {
    throw Exception('Failed to load tasks');
  }
}
import 'package:flutter/material.dart';
import 'task.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: FutureBuilder<List<Task>>(
        future: fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index].title),
                );
              },
            );
          }
        },
      ),
    );
  }
}