import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/side.dart';
import '../model/feature.dart';
import '../model/user.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class TimeManagement extends StatefulWidget {
  const TimeManagement({super.key});
  static const routeName = '/time_management';

  @override
  State<TimeManagement> createState() => _TimeManagementState();
}

class _TimeManagementState extends State<TimeManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 63, 107, 92),
        foregroundColor: Colors.white,
      ),
      endDrawer: AppDrawer(), // Drawer added here too
      body: TaskOptionsWidget(),
    );
  }
}

class TaskLists extends StatefulWidget {
  const TaskLists({super.key});
  static const routeName = '/task_list';

  @override
  State<TaskLists> createState() => _TaskListsState();
}

class _TaskListsState extends State<TaskLists> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskTextController = TextEditingController();
  DatabaseService _dbHelper = DatabaseService();
  TextEditingController _targetTimeController =
      TextEditingController(); // default value, change it as needed
  bool _isCompleteCheckBoxValue = false;
  TaskList? _editingTask; // This will hold the task that is being edited.
  bool _isClicked = false;
  bool _checkboxEnabled = false;

  @override
  void initState() {
    super.initState();
    _refreshTaskList(); // Load initial task list.
  }

  @override
  void dispose() {
    _taskTextController.dispose();
    super.dispose();
  }

  List<TaskList> _tasks = [];

  // Fetch the task list from the database and refresh the UI.
  Future<void> _refreshTaskList() async {
    User? currentUser = context.read<AuthService>().currentUser;
    if (currentUser != null) {
      int userId = currentUser.id!;
      List<TaskList> tasks = await _dbHelper.getTasksuid(userId);
      List<TaskList> completedTasks =
          tasks.where((task) => !task.isComplete).toList();
      setState(() {
        _tasks = completedTasks;
      });
    } else {
      print('No user is logged in');
    }
  }

  // Handle form submission for adding or updating a task.
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String taskText = _taskTextController.text;
      int targetTime = int.parse(_targetTimeController.text); // new
      bool isComplete = _isCompleteCheckBoxValue; // new

      User? currentUser = context.read<AuthService>().currentUser;

      if (currentUser == null) {
        // Show error if no user is logged in
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Error: No user is logged in! Please log in first.')),
          );
        }
        return; // Exit the function if no user is logged in
      }

      int userId = currentUser.id!; // Now safely use the logged-in user's ID
      // Check the count of incomplete tasks

      if (_editingTask == null) {
        int incompleteTaskCount = await _dbHelper.getUncheckedTaskCount(userId);
        if (incompleteTaskCount >= 10) {
          // Block submission if there are already 10 unchecked tasks
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'You cannot add more tasks until you complete some of the existing ones.')),
            );
          }
          return; // Exit the function without adding a new task
        }
        // Insert new task for the logged-in user
        TaskList newTask = TaskList(
          userId: userId,
          taskText: taskText,
          targetTime: targetTime, // new
          isComplete: isComplete, // new
          created: DateTime.now(),
        );

        await _dbHelper.insertTask(newTask);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Task added successfully!')),
          );
        }
      } else {
        // Update the existing task for the logged-in user
        _editingTask!.taskText = taskText;
        _editingTask!.targetTime = targetTime; // new
        _editingTask!.isComplete = isComplete; // new
        await _dbHelper.updateTask(_editingTask!);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Task updated successfully!')),
          );
        }

        _editingTask = null;
      }

      // Refresh the task list and clear the form
      _refreshTaskList();
      _taskTextController.clear();
      _targetTimeController.clear(); // new
    }
  }

  void _editTask(TaskList task) {
    setState(() {
      _editingTask = task;
      _taskTextController.text = task.taskText;
    });
  }

  // Delete a task
  Future<void> _deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task deleted successfully!')),
      );
      _refreshTaskList();
    }
  }

  Future<void> _saveAllTaskStates() async {
    for (var task in _tasks) {
      await _saveTaskState(task); // Save each task's state
    }
    _refreshTaskList();
  }

  Future<void> _saveTaskState(TaskList task) async {
    try {
      // Call the database helper to update the task completion status
      await _dbHelper.updateTaskCompletionStatus(task.id!, task.isComplete);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Task "${task.taskText}" saved successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving task "${task.taskText}".')),
        );
      }
    }
    _refreshTaskList();
  }

  void _toggleCheckboxState() {
    setState(() {
      _checkboxEnabled = !_checkboxEnabled; // Toggle between true and false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 77, 172, 140),
        foregroundColor: Colors.white,
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      endDrawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.green[100]),
          child: Column(
            children: <Widget>[
              Container(
                height: 85,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 77, 172, 140),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(85),
                    bottomRight: Radius.circular(85),
                  ),
                ),
                child: Text(
                  'Time Management',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: Size(50, 50),
                      ),
                      onPressed: () {
                        setState(
                          () {
                            _isClicked =
                                !_isClicked; // Toggle _isClicked state on button press
                          },
                        );
                      },
                      child: Icon(
                        Icons.playlist_add_circle_rounded,
                        size: 30,
                        color: Color.fromARGB(255, 0, 101, 53),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: _saveAllTaskStates,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 76, 153, 99)),
                      child: Text(
                        "Save",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  SizedBox(
                    height: 30,
                    width: 110,
                    child: ElevatedButton(
                      onPressed: _toggleCheckboxState,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 76, 153,
                              99)), // Toggle checkbox enabled/disabled
                      child: _checkboxEnabled
                          ? Text(
                              'Disselect',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            )
                          : Text(
                              'Select',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: _isClicked
                    ? (_tasks.isEmpty ? 500 : min(_tasks.length, 10) * 60 + 700)
                    : (_tasks.isEmpty
                        ? 500
                        : min(_tasks.length, 10) * 70 + 700),
                width: 325,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(top: 0.5),
                      height: 90,
                      width: 320,
                      decoration: BoxDecoration(
                        color: Colors.pink[400],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(120),
                          bottomRight: Radius.circular(120),
                        ),
                      ),
                      child: Text(
                        'Task',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.elasticInOut,
                      opacity: _isClicked ? 1 : 0,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Form(
                          key: _formKey,
                          child: AnimatedContainer(
                            height: _isClicked ? 300 : 0,
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.easeInOut,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: _taskTextController,
                                  decoration: InputDecoration(
                                    labelText: 'Task Text',
                                    border:
                                        OutlineInputBorder(), // Optional: Add a border for clarity
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a task';
                                    }
                                    return null;
                                  },
                                  minLines:
                                      1, // Minimum number of lines (initial height)
                                  maxLines: 5,
                                  maxLength:
                                      200, // Expands dynamically with user input
                                  keyboardType: TextInputType
                                      .multiline, // Allow multiline input
                                ),
                                TextFormField(
                                  controller: _targetTimeController, // new
                                  decoration:
                                      InputDecoration(labelText: 'Target Time'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a target time';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                ElevatedButton(
                                  onPressed: _submitForm,
                                  child: Text(_editingTask == null
                                      ? 'Add Task'
                                      : 'Update Task'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _tasks.isEmpty
                          ? Center(child: Text('No tasks available.'))
                          : SizedBox(
                              // Make the Column scrollable
                              child: Column(
                                children: List.generate(
                                  min(_tasks.length, 10), // Limit to 10 tasks
                                  (index) {
                                    TaskList task = _tasks[index];
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // Checkbox
                                          Checkbox(
                                            value: task.isComplete,
                                            onChanged: _checkboxEnabled
                                                ? (value) {
                                                    setState(() {
                                                      task.isComplete = value!;
                                                    });
                                                  }
                                                : null, // Disable checkbox if _checkboxEnabled is false
                                          ), // Spacing between checkbox and text

                                          // Task text and details (Column)
                                          Expanded(
                                            child: Container(
                                              height: 100,
                                              // color: Colors.amber,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Task text
                                                  Stack(
                                                    children: [
                                                      Text(
                                                        task.taskText,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom:
                                                            1, // Adjust the spacing by modifying this value
                                                        left: 0,
                                                        right: 0,
                                                        child: Container(
                                                          height:
                                                              1, // Thickness of the underline
                                                          color: Colors
                                                              .black, // Color of the underline
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  SizedBox(
                                                      height:
                                                          4), // Spacing between title and subtitle
                                                  // Task target time
                                                  Text(
                                                    "Target Time: ${task.targetTime.toString()} hrs",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.teal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Trailing actions (Edit and Delete buttons)
                                          Container(
                                            // color: Colors.amber,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: Colors.green[300],
                                                  ),
                                                  onPressed: () {
                                                    _editTask(
                                                        task); // Edit the task
                                                    _isClicked = true;
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red[400],
                                                  ),
                                                  onPressed: () {
                                                    _deleteTask(task
                                                        .id!); // Delete the task
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TargetTime extends StatefulWidget {
  const TargetTime({super.key});
  static const routeName = '/target_time';

  @override
  State<TargetTime> createState() => _TargetTimeState();
}

class _TargetTimeState extends State<TargetTime> {
  DatabaseService _dbHelper = DatabaseService();
  String? _selectedItem = 'Today';
  bool _isClicked = true;

  // List of items in the dropdown
  List<String> _dropdownItems = [
    'Today',
    'Yesterday',
    '1 Week',
    'More',
  ];

  List<TaskList> filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _refreshTaskList(); // Fetch tasks and then filter them
  }

  List<TaskList> _tasks = [];
// Fetch the task list from the database and refresh the UI.
  Future<void> _refreshTaskList() async {
    User? currentUser = context.read<AuthService>().currentUser;
    if (currentUser != null) {
      int userId = currentUser.id!;
      List<TaskList> tasks = await _dbHelper.getTasksuid(userId);

      setState(() {
        _tasks = tasks; // Assign all tasks, not just completed
      });

      _filterTasks();
    } else {
      print('No user is logged in');
    }
  }

  void _filterTasks() {
    DateTime now = DateTime.now();
    setState(() {
      if (_selectedItem == 'Today') {
        filteredTasks = _tasks.where((task) {
          return task.created != null &&
              task.created!.year == now.year &&
              task.created!.month == now.month &&
              task.created!.day == now.day &&
              task.isComplete;
        }).toList();
      } else if (_selectedItem == 'Yesterday') {
        filteredTasks = _tasks.where((task) {
          return task.created != null &&
              task.created!.year == now.year &&
              task.created!.month == now.month &&
              task.created!.day == now.subtract(Duration(days: 1)).day &&
              task.isComplete;
        }).toList();
      } else if (_selectedItem == '1 Week') {
        filteredTasks = _tasks.where((task) {
          return task.created != null &&
              task.created!.isAfter(now.subtract(Duration(days: 7))) &&
              task.created!.isBefore(now) &&
              task.isComplete;
        }).toList();
      } else if (_selectedItem == 'More') {
        filteredTasks = _tasks.where((task) {
          return task.created != null &&
              task.created!.isAfter(now.subtract(Duration(days: 7))) &&
              task.isComplete;
        }).toList();
      }
    });
  }

  String _formatToDouble(DateTime dateTime) {
    // Extract the hour and minute
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    // Convert minute to a decimal and add to the hour
    double timeAsDouble = hour + (minute / 60.0);

    // Format the double to 2 decimal places and return as a string
    return timeAsDouble.toStringAsFixed(2);
  }

  void _toggleCheckboxState() {
    setState(() {
      _isClicked = !_isClicked; // Toggle between true and false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 77, 172, 140),
        foregroundColor: Colors.white,
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      endDrawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.green[100]),
          child: Column(
            children: <Widget>[
              Container(
                height: 85,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 77, 172, 140),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(85),
                    bottomRight: Radius.circular(85),
                  ),
                ),
                child: Text(
                  'Time Management',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  // SizedBox(
                  //   height: 30,
                  //   width: 120,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       _toggleCheckboxState();
                  //     },
                  //     child: Text("Completed"),
                  //   ),
                  // ),

                  Container(
                    height: 31,
                    width: 120,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(
                          255, 76, 153, 99), // Background color of the button
                      borderRadius:
                          BorderRadius.circular(100), // Rounded corners

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          offset:
                              Offset(0, 1), // Offset in the x and y direction
                        ),
                      ], // Border color
                    ),
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      dropdownColor: Colors.green[300],
                      underline: SizedBox.shrink(),
                      icon: Icon(
                        Icons.playlist_add_circle_rounded,
                        color: Colors.white,
                      ),
                      value: _selectedItem, // The currently selected item
                      hint: Text(
                        'Filter',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      items: _dropdownItems.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),

                      // When the user selects an item
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedItem = newValue; // Update selected item
                          _filterTasks(); // Apply the filter
                        });
                      },
                    ),
                  ),
                ],
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: 500,
                ),
                width: 325,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(top: 0.5),
                      height: 90,
                      width: 320,
                      decoration: BoxDecoration(
                        color: Colors.orange[400],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(120),
                          bottomRight: Radius.circular(120),
                        ),
                      ),
                      child: Text(
                        'Completed Task',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: 500,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Expanded(
                            child: filteredTasks.isEmpty
                                ? Center(child: Text('No tasks available.'))
                                : SizedBox(
                                    // Make the Column scrollable
                                    child: Column(
                                      children: List.generate(
                                        min(filteredTasks.length,
                                            10), // Limit to 10 tasks
                                        (index) {
                                          TaskList task = filteredTasks[index];
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            // decoration: BoxDecoration(
                                            //   border: Border(
                                            //     bottom:
                                            //         BorderSide(color: Colors.grey),
                                            //     top: BorderSide(color: Colors.black),
                                            //   ),
                                            // ),
                                            child: ListTile(
                                              title: Text(
                                                task.taskText,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    color: const Color.fromARGB(
                                                        255, 6, 98, 9)),
                                              ),
                                              subtitle: Text(
                                                "Target Time: ${task.targetTime.toString()} hrs",
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.teal),
                                              ),
                                              trailing: Text(
                                                task.created != null
                                                    ? DateFormat.Md()
                                                        .add_jm()
                                                        .format(task.created!)
                                                    : '',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FocusSession extends StatefulWidget {
  const FocusSession({super.key});
  static const routeName = '/focus';

  @override
  State<FocusSession> createState() => _FocusSessionState();
}

class _FocusSessionState extends State<FocusSession> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 77, 172, 140),
        foregroundColor: Colors.white,
        elevation: 0.0,
        shadowColor: Colors.transparent,
      ),
      endDrawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.green[100]),
          child: Column(
            children: <Widget>[
              Container(
                height: 85,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 77, 172, 140),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(85),
                    bottomRight: Radius.circular(85),
                  ),
                ),
                child: Text(
                  'Time Management',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 325,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(top: 0.5),
                      height: 90,
                      width: 320,
                      decoration: BoxDecoration(
                        color: Colors.purple[400],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(120),
                          bottomRight: Radius.circular(120),
                        ),
                      ),
                      child: Text(
                        'Focus Session',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: 15,
                              bottom: 20,
                              left: 10,
                              right: 10,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Focus Session 1: Kickstart Your Day with Clear Goals',
                                    style: TextStyle(
                                      color: Colors.purple[200],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 50),
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '''Begin your day by setting 3 clear, achievable goals. Prioritize your most important task
first, and visualize the sense of accomplishment you'll feel once it's completed.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '''Action: Write down your goals and focus on tackling the first one.''',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: 15,
                              bottom: 20,
                              left: 10,
                              right: 10,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Focus Session 2: The Power of the Pomodoro Technique',
                                    style: TextStyle(
                                      color: Colors.purple[200],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 50),
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '''Work in short bursts for maximum productivity. Focus for 25 minutes, then reward yourself with a 5-minute break. This prevents burnout and keeps your mind fresh.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '''Action: Set a timer and dive into your task''',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: 15,
                              bottom: 20,
                              left: 10,
                              right: 10,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Focus Session 3: Declutter Your Workspace',
                                    style: TextStyle(
                                      color: Colors.purple[200],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 50),
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '''A clutter-free environment boosts mentalclarity. Take a few minutes to organize your workspace and eliminate distractions.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '''Action: Clear your desk, close unnecessary 
tabs on your computer, and turn off notifications.''',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: 15,
                              bottom: 20,
                              left: 10,
                              right: 10,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Focus Session 4: Stay Mindful',
                                    style: TextStyle(
                                      color: Colors.purple[200],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 50),
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '''Before diving into work, engage in a mindful breathing exercise. Focus on your breathing for a few moments to calm your mind and prepare for concentration.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '''Action: Close your eyes, take deep breaths, and focus on your breathing for 3 minutes before starting work''',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: 15,
                              bottom: 20,
                              left: 10,
                              right: 10,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Focus Session 5: Reflect and Recharge',
                                    style: TextStyle(
                                      color: Colors.purple[200],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 50),
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '''After working for an extended period, take time to reflect on what you've accomplished. Gratitude and acknowledgment can boost morale and motivation.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '''Action: Write down the tasks you completed and
reward yourself with a short, enjoyable break.''',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: 15,
                              bottom: 20,
                              left: 10,
                              right: 10,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '''Focus Session 6: Use Time Blocks
for Specific Tasks''',
                                    style: TextStyle(
                                      color: Colors.purple[200],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 50),
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '''Allocate specific time blocks to different tasks. During this session, focus on one specific task without interruptions.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '''Action: Identify one task and set a timer for 45 minutes. Work exclusively on this task until the time is up.''',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: 15,
                              bottom: 20,
                              left: 10,
                              right: 10,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Focus Session 7: Midday Focus Reset',
                                    style: TextStyle(
                                      color: Colors.purple[200],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 50),
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '''If your energy is lagging midday, a short focus reset can help. Practice mindful  breathing or take a quick walk to refresh your mind.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '''Action: Step away from your desk, stretch, or walk for 5 minutes. Return with renewed energy for the next 15 minutes of concentrated work.''',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: 15,
                              bottom: 20,
                              left: 10,
                              right: 10,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '''Focus Session 8: Optimize Your
Workspace Lighting''',
                                    style: TextStyle(
                                      color: Colors.purple[200],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 50),
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '''Adjust your workspace lighting to avoid eye strain and maintain focus. Natural lighting or cool-toned lights can help improve concentration.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '''Action: Assess your workspace lighting and make
necessary adjustments to brighten the area.''',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: 15,
                              bottom: 20,
                              left: 10,
                              right: 10,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '''Focus Session 9: Brainstorm and
Creative Break''',
                                    style: TextStyle(
                                      color: Colors.purple[200],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 50),
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '''For creative tasks, it’s beneficial to take breaks to let your mind wander productively. This helps generate new ideas and improves problem-solving.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '''Action: Work for 20 minutes, then take 10 minutes to move away from the task. Engage in a light activity (such as doodling or walking) to boost creativity.''',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: 15,
                              bottom: 20,
                              left: 10,
                              right: 10,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '''Focus Session 10: Focus and
Hydration Boost''',
                                    style: TextStyle(
                                      color: Colors.purple[200],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 50),
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '''Staying hydrated helps your brain focus better. Use this session to refocus and drink a glass of water before starting work.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '''Action: Drink water, then sit down for a short
10-minute focused sprint.''',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: 15,
                              bottom: 20,
                              left: 10,
                              right: 10,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Focus Session 1: Kickstart Your Day with Clear Goals',
                                    style: TextStyle(
                                      color: Colors.purple[200],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 50),
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '''Begin your day by setting 3 clear, achievable goals. Prioritize your most important task first, and visualize the sense of accomplishment you'll feel once it's completed.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '''Action: Write down your goals and focus on tackling the first one.''',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskOptionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 206, 236, 221),
      child: Stack(
        children: [
          Positioned(
            top:
                -1650, // Adjust the top value to control how much of the container is visible
            left: 0,
            right: 0,
            child: Container(
              height: 2000, // Even taller for a more elongated vertical oval
              width: 500, // Narrower width
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 77, 172, 140),
                borderRadius: BorderRadius.all(
                  Radius.elliptical(300,
                      250), // Adjust radii to match the new height and width
                ),
              ),
            ),
          ),
          Positioned(
            top:
                -1320, // Adjust the top value to control how much of the container is visible
            left: 0,
            right: 0,
            child: Container(
              height: 1500, // Even taller for a more elongated vertical oval
              width: 500, // Narrower width
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 63, 107, 92),
                borderRadius: BorderRadius.all(
                  Radius.elliptical(300,
                      250), // Adjust radii to match the new height and width
                ),
              ),
            ),
          ),
          SizedBox(
            height: 100,
            // width: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 10),
              child: Container(
                padding: EdgeInsets.only(left: 10),
                alignment: Alignment.center, // Aligns the Text to the left
                child: Text(
                  'Time Management',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 300,
              padding: EdgeInsets.all(5),
              decoration:
                  BoxDecoration(color: const Color.fromARGB(0, 84, 70, 27)),
              child: Row(
                // Shrink the row to fit its children
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Center horizontally
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Center vertically // Aligns vertically at the center
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/task_list');
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.all(0), // Customize padding inside button
                    ),
                    child: Container(
                      height: 200,
                      width: 110,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Icon(
                                Icons.list_alt,
                                size: 100,
                                color: Colors.pink,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/task_list');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(
                                  16), // Customize padding inside button
                            ),
                            child: Text(
                              'Set Task List',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Spacing between buttons
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/target_time');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(
                            0), // Customize padding inside button
                      ),
                      child: Container(
                        height: 200,
                        width: 110,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: 150,
                                height: 150,
                                child: Icon(
                                  Icons.access_time_outlined,
                                  size: 100,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/target_time');
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(16),
                              ),
                              child: Text(
                                'Completed Task',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/focus');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(0),
                    ),
                    child: Container(
                      height: 200,
                      width: 110,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Icon(
                                Icons.message,
                                size: 100,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/focus');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16),
                            ),
                            child: Text(
                              'Focus Session',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
