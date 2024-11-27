import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Obtém a instância do banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa o banco de dados
  Future<Database> _initDatabase() async {
  // await deleteDatabase(await getDatabasesPath() + '/tasks.db');
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

  return openDatabase(
    path,
    version: 3, // Atualize a versão para 3
    onCreate: (db, version) async {
      // Criação da tabela tasks
      await db.execute(''' 
        CREATE TABLE tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT,
          completed INTEGER,
          date TEXT,
          time TEXT
        )
      ''');

      // Criação da tabela categories
      await db.execute(''' 
        CREATE TABLE categories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL
        )
      ''');

      // Tabela intermediária para relacionar tarefas e categorias
      await db.execute(''' 
        CREATE TABLE task_categories (
          task_id INTEGER,
          category_id INTEGER,
          PRIMARY KEY (task_id, category_id),
          FOREIGN KEY (task_id) REFERENCES tasks (id),
          FOREIGN KEY (category_id) REFERENCES categories (id)
        )
      ''');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 3) {
        // Atualização do banco para incluir novas colunas
          await db.execute('ALTER TABLE tasks ADD COLUMN description TEXT');
          await db.execute('ALTER TABLE tasks ADD COLUMN date TEXT');
          await db.execute('ALTER TABLE tasks ADD COLUMN time TEXT');
        // Criação da tabela task_categories
        await db.execute(''' 
          CREATE TABLE task_categories (
            task_id INTEGER,
            category_id INTEGER,
            PRIMARY KEY (task_id, category_id),
            FOREIGN KEY (task_id) REFERENCES tasks (id),
            FOREIGN KEY (category_id) REFERENCES categories (id)
          )
        ''');
      }
    },
  );
}

// Associa uma tarefa a uma categoria
Future<void> addTaskToCategory(int taskId, int categoryId) async {
  final db = await database;
  await db.insert(
    'task_categories',
    {
      'task_id': taskId,
      'category_id': categoryId,
    },
    conflictAlgorithm: ConflictAlgorithm.ignore, // Ignora se a associação já existir
  );
}

// Obtém as categorias associadas a uma tarefa
Future<List<Map<String, dynamic>>> getCategoriesForTask(int taskId) async {
  final db = await database;
  final List<Map<String, dynamic>> categories = await db.rawQuery('''
    SELECT c.id, c.name
    FROM categories c
    INNER JOIN task_categories tc ON c.id = tc.category_id
    WHERE tc.task_id = ?
  ''', [taskId]);

  return categories;
}

// Obtém as tarefas associadas a uma categoria
Future<List<Map<String, dynamic>>> getTasksForCategory(int categoryId) async {
  final db = await database;
  final List<Map<String, dynamic>> tasks = await db.rawQuery('''
    SELECT t.id, t.title
    FROM tasks t
    INNER JOIN task_categories tc ON t.id = tc.task_id
    WHERE tc.category_id = ?
  ''', [categoryId]);

  return tasks;
}

  // Adiciona uma nova tarefa com apenas o título
  Future<int> addTask(String title) async {
    final db = await database;
    return db.insert(
      'tasks',
      {
        'title': title,
        'description': null,
        'category': null,
        'completed': 0,
        'date': null,
        'time': null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Atualiza uma tarefa existente com descrição, categoria e status
Future<int> updateTask(
    int id, {
    String? description,
    String? category,
    String? date,
    String? time,
    int? completed,
  }) async {
    final db = await database;

    final updates = {
      if (description != null) 'description': description,
      if (category != null) 'category': category,  // Certifique-se de que a categoria é atualizada
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (completed != null) 'completed': completed,
    };

    return db.update(
      'tasks',
      updates,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Obtém todas as tarefas
  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return db.query('tasks');
  }

  // Atualiza o status de conclusão da tarefa
  Future<int> updateTaskCompletion(int id, {required bool completed}) async {
    final db = await database;
    return db.update(
      'tasks',
      {'completed': completed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Exclui uma tarefa
  Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Adiciona uma nova categoria
  Future<int> addCategory(String name) async {
    final db = await database;
    return db.insert(
      'categories',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Atualiza uma categoria existente
  Future<int> updateCategory(int id, String name) async {
    final db = await database;
    return db.update(
      'categories',
      {'name': name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Exclui uma categoria
  Future<int> deleteCategory(int id) async {
    final db = await database;
    return db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Obtém todas as categorias
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return db.query('categories');
  }
}
