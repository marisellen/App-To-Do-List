import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Obtém a instância do banco de dados
Future<Database> get database async {
  // Verifica se o banco de dados já está inicializado
  if (_database != null) return _database!;

  // Se o banco não foi inicializado, chama a função de inicialização
  _database = await _initDatabase();
  return _database!;
}

  // Inicializa o banco de dados
  Future<Database> _initDatabase() async {
//await deleteDatabase(await getDatabasesPath() + '/tasks.db');
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
            category_id INTEGER,  -- Coluna que referencia a categoria
            completed INTEGER,
            date TEXT,
            time TEXT,
            FOREIGN KEY (category_id) REFERENCES categories (id) -- Relacionamento com a tabela categories
          )
        ''');

        // Criação da tabela categories
        await db.execute(''' 
          CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          // Atualização do banco para incluir novas colunas
          await db.execute('ALTER TABLE tasks ADD COLUMN description TEXT');
          await db.execute('ALTER TABLE tasks ADD COLUMN date TEXT');
          await db.execute('ALTER TABLE tasks ADD COLUMN time TEXT');
          await db.execute('ALTER TABLE tasks ADD COLUMN category_id INTEGER');
          
          // Adiciona o relacionamento com a tabela categories
          await db.execute(''' 
            CREATE TABLE IF NOT EXISTS categories (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL
            )
          ''');

        }
      },
    );
  }

  // Adiciona uma categoria a uma tarefa
  Future<void> updateTaskCategory(int taskId, int categoryId) async {
    final db = await database;
    await db.update(
      'tasks',
      {'category_id': categoryId}, // Atualiza category_id, não category
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  // Remove a categoria de uma tarefa
  Future<void> removeCategoryFromTask(int taskId) async {
    final db = await database;
    await db.update(
      'tasks',
      {'category_id': null}, // Remove a categoria
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  // Obtém a categoria associada a uma tarefa
  Future<Map<String, dynamic>?> getCategoryForTask(int taskId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(''' 
      SELECT c.id, c.name
      FROM categories c
      INNER JOIN tasks t ON t.category_id = c.id
      WHERE t.id = ?
    ''', [taskId]);

    // Retorna a categoria ou null se não houver
    return result.isNotEmpty ? result.first : null;
  }

  // Obtém as tarefas associadas a uma categoria
  Future<List<Map<String, dynamic>>> getTasksForCategory(int categoryId) async {
    final db = await database;
    final List<Map<String, dynamic>> tasks = await db.rawQuery(''' 
      SELECT t.id, t.title
      FROM tasks t
      WHERE t.category_id = ?
    ''', [categoryId]);

    return tasks;
  }

  // Adiciona uma nova tarefa com apenas o título (sem categoria inicialmente)
  Future<int> addTask(String title) async {
    final db = await database;
    return db.insert(
      'tasks',
      {
        'title': title,
        'description': null,
        'category_id': null,  // Inicializa com null, sem categoria
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
    int? categoryId,  // Alteração para aceitar categoryId em vez de category
    String? date,
    String? time,
    int? completed,
  }) async {
    final db = await database;

    final updates = {
      if (description != null) 'description': description,
      if (categoryId != null) 'category_id': categoryId,  // Atualiza category_id
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
