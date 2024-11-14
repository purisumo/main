// lib/services/database_service.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/user.dart';
import '../model/feature.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the database
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the default databases location
    String path = join(await getDatabasesPath(), 'test7.db');
    // Open the database, creating it if it doesn't exist
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Example: Adding a new column to an existing table in version 2
      await db.execute('ALTER TABLE task_list ADD COLUMN due_date TEXT');
    }

    // Add other migrations as needed for further versions
    if (oldVersion < 3) {
      // Example: Adding a new table
      await db.execute('''
      CREATE TABLE new_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');
    }
  }

  // Create the users table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullname TEXT NOT NULL,
        username TEXT UNIQUE NOT NULL,
        passwordHash TEXT NOT NULL
      )
    ''');

    await db.execute('''
    CREATE TABLE task_list (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,    
      task_text TEXT NOT NULL,
      created DATETIME DEFAULT CURRENT_TIMESTAMP,
      target_time INTEGER NOT NULL, 
      is_complete BOOLEAN DEFAULT 0,
      FOREIGN KEY (user_id) REFERENCES users (id)                  
       ON DELETE NO ACTION ON UPDATE NO ACTION
     )
     ''');

    await db.execute('''
    CREATE TABLE focus_session (
      id INTEGER PRIMARY KEY AUTOINCREMENT,  
      focus_text TEXT NOT NULL
     )
     ''');

    await db.execute('''
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,    
      note_text TEXT NOT NULL, 
      FOREIGN KEY (user_id) REFERENCES users (id)                  
       ON DELETE NO ACTION ON UPDATE NO ACTION
     )
     ''');

    await db.execute('''
    CREATE TABLE goals (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,    
      goal_text TEXT NOT NULL, 
      checked BOOLEAN DEFAULT 0,
      FOREIGN KEY (user_id) REFERENCES users (id)                  
       ON DELETE NO ACTION ON UPDATE NO ACTION
     )
     ''');

    await db.execute('''
    CREATE TABLE wgoals (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,    
      goal_text TEXT NOT NULL, 
      checked BOOLEAN DEFAULT 0,
      FOREIGN KEY (user_id) REFERENCES users (id)                  
       ON DELETE NO ACTION ON UPDATE NO ACTION
     )
     ''');

    await db.execute('''
    CREATE TABLE procrastination (
      id INTEGER PRIMARY KEY AUTOINCREMENT,  
      proc_text TEXT NOT NULL
     )
     ''');
  }

  // Insert a new user
  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<void> updateUser(User user) async {
    final db = await database;

    await db.update(
      'users', // Name of the users table
      user.toMap(), // Update with the new user details
      where: 'id = ?', // Find the user by id
      whereArgs: [user.id], // Pass the user ID to update the correct user
    );
  }

  Future<void> updateUseracc(User user) async {
    final db = await database; // Get the database instance
    await db.update(
      'users', // The table name
      user.toMap(), // Convert user to a map
      where: 'id = ?', // Update the user based on their ID
      whereArgs: [user.id],
    );
  }

  Future<User?> getUserById(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('users', where: 'id = ?', whereArgs: [userId]);

    if (maps.isNotEmpty) {
      return User(
        id: maps[0]['id'],
        fullname: maps[0]['fullname'],
        username: maps[0]['username'],
        passwordHash: maps[0]['passwordHash'],
      );
    }
    return null; // User not found
  }

  // Retrieve a user by email
  Future<User?> getUserByEmail(String username) async {
    Database db = await database;
    List<Map<String, dynamic>> maps =
        await db.query('users', where: 'username = ?', whereArgs: [username]);

    if (maps.isNotEmpty) {
      return User(
        id: maps.first['id'],
        fullname: maps.first['fullname'],
        username: maps.first['username'],
        passwordHash: maps.first['passwordHash'],
      );
    }
    return null;
  }

  // Insert a new task into the database
  Future<int> insertTask(TaskList task) async {
    final db = await database;
    return await db.insert(
      'task_list',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all tasks
  Future<List<TaskList>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('task_list');

    return List.generate(maps.length, (i) {
      return TaskList.fromMap(maps[i]);
    });
  }

  Future<List<TaskList>> getTasksuid(int userId) async {
    final db = await database;

    // Query the task_list table and filter by user_id
    final List<Map<String, dynamic>> maps = await db.query(
      'task_list',
      where: 'user_id = ?', // The condition for filtering by userId
      whereArgs: [userId], // Provide the current user's ID as the argument
    );

    // Convert the list of maps to a list of TaskList objects
    return List.generate(maps.length, (i) {
      return TaskList.fromMap(maps[i]);
    });
  }

  // Get a single task by ID
  Future<TaskList?> getTaskById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'task_list',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TaskList.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Update an existing task
  Future<int> updateTask(TaskList task) async {
    final db = await database;
    return await db.update(
      'task_list',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> updateTaskCompletionStatus(int taskId, bool isComplete) async {
    final db = await database; // Get a reference to the database

    // Convert the boolean to an integer for storing in SQLite (1 for true, 0 for false)
    int isCompleteValue = isComplete ? 1 : 0;

    // Update the task's 'isComplete' field
    return await db.update(
      'task_list', // Name of the table
      {
        'is_complete': isCompleteValue, // Update the isComplete field
      },
      where: 'id = ?', // Specify which task to update
      whereArgs: [taskId], // Use the task's id as a condition
    );
  }

  Future<int> getUncheckedTaskCount(int userId) async {
    final db = await database;
    var result = await db.rawQuery(
        'SELECT COUNT(*) FROM task_list WHERE user_id = ? AND is_complete = 0',
        [userId]);

    // Return the count of incomplete tasks
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Delete a task by ID
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'task_list',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Insert a new note into the database
  Future<int> addNote(Note note) async {
    Database db = await database;
    return await db.insert('notes', note.toMap());
  }

  // Get all notes for a user
  Future<List<Note>> getNotes(int userId) async {
    Database db = await database;
    var notes =
        await db.query('notes', where: 'user_id = ?', whereArgs: [userId]);
    List<Note> noteList = notes.isNotEmpty
        ? notes.map((note) => Note.fromMap(note)).toList()
        : [];
    return noteList;
  }

  // Update a note
  Future<int> updateNote(Note note) async {
    Database db = await database;
    return await db
        .update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  // Delete a note
  Future<int> deleteNote(int id) async {
    Database db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // Count notes for a specific user (to ensure no more than 10)
  Future<int> countNotes(int userId) async {
    Database db = await database;
    return Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM notes WHERE user_id = ?', [userId]))!;
  }

  // Insert a new note into the database
  Future<int> addGoal(Goal goal) async {
    Database db = await database;
    return await db.insert('goals', goal.toMap());
  }

  // Get all notes for a user
  Future<List<Goal>> getGoal(int userId) async {
    Database db = await database;
    var goals =
        await db.query('goals', where: 'user_id = ?', whereArgs: [userId]);
    List<Goal> goalList = goals.isNotEmpty
        ? goals.map((goal) => Goal.fromMap(goal)).toList()
        : [];
    return goalList;
  }

  // Update a note
  Future<int> updateGoal(Goal goal) async {
    Database db = await database;
    return await db
        .update('goals', goal.toMap(), where: 'id = ?', whereArgs: [goal.id]);
  }

  // Delete a note
  Future<int> deleteGoal(int id) async {
    Database db = await database;
    return await db.delete('goals', where: 'id = ?', whereArgs: [id]);
  }

  // Count notes for a specific user (to ensure no more than 10)
  Future<int> countGoal(int userId) async {
    Database db = await database;
    return Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM goals WHERE user_id = ?', [userId]))!;
  }

  // Insert a new note into the database
  Future<int> addwGoal(WGoal goal) async {
    Database db = await database;
    return await db.insert('wgoals', goal.toMap());
  }

  // Get all notes for a user
  Future<List<WGoal>> getwGoal(int userId) async {
    Database db = await database;
    var wgoals =
        await db.query('wgoals', where: 'user_id = ?', whereArgs: [userId]);
    List<WGoal> goalList = wgoals.isNotEmpty
        ? wgoals.map((goal) => WGoal.fromMap(goal)).toList()
        : [];
    return goalList;
  }

  // Update a note
  Future<int> updatewGoal(WGoal goal) async {
    Database db = await database;
    return await db
        .update('wgoals', goal.toMap(), where: 'id = ?', whereArgs: [goal.id]);
  }

  // Delete a note
  Future<int> deletewGoal(int id) async {
    Database db = await database;
    return await db.delete('wgoals', where: 'id = ?', whereArgs: [id]);
  }

  // Count notes for a specific user (to ensure no more than 10)
  Future<int> countwGoal(int userId) async {
    Database db = await database;
    return Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM wgoals WHERE user_id = ?', [userId]))!;
  }
}
