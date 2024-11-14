// import 'database_service.dart';
// import '../model/feature.dart';

// void performCRUDOperations() async {
//   DatabaseService dbHelper = DatabaseService();

//   // Insert a new task
//   TaskList newTask = TaskList(userId: 1, taskText: 'Complete Flutter app');
//   int newTaskId = await dbHelper.insertTask(newTask);
//   print('Inserted Task ID: $newTaskId');

//   // Get all tasks
//   List<TaskList> tasks = await dbHelper.getTasks();
//   print('All Tasks:');
//   for (var task in tasks) {
//     print('${task.id}: ${task.taskText}');
//   }

//   // Get a task by ID
//   TaskList? task = await dbHelper.getTaskById(newTaskId);
//   if (task != null) {
//     print('Fetched Task: ${task.taskText}');
//   }

//   // Update the task
//   task?.taskText = 'Update task text';
//   if (task != null) {
//     await dbHelper.updateTask(task);
//     print('Updated Task: ${task.taskText}');
//   }

//   // Delete the task
//   await dbHelper.deleteTask(newTaskId);
//   print('Deleted Task with ID: $newTaskId');
// }
