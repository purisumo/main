import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../model/user.dart';
import '../model/feature.dart';
import '../shared/side.dart';

class Concentration extends StatefulWidget {
  const Concentration({super.key});
  static const routeName = '/concentration';

  @override
  State<Concentration> createState() => _ConcentrationState();
}

class _ConcentrationState extends State<Concentration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 63, 107, 92),
        foregroundColor: Colors.white,
      ),
      endDrawer: AppDrawer(),
      body: TaskOptionsWidget(),
    );
  }
}

class Notes extends StatefulWidget {
  const Notes({super.key});
  static const routeName = '/notes';

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  List<TextEditingController> _controllers =
      List.generate(10, (index) => TextEditingController());
  bool _isLoading = true;
  DatabaseService dbHelper = DatabaseService();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Load notes from the database
  Future<void> _loadNotes() async {
    User? currentUser = context.read<AuthService>().currentUser;
    int userId = currentUser!.id!;
    List<Note> notes = await dbHelper.getNotes(userId);
    for (int i = 0; i < notes.length; i++) {
      _controllers[i].text = notes[i].noteText;
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Automatically save the note when it's changed
  Future<void> _saveNote(int index, String text) async {
    // Get the count of existing notes for the user
    User? currentUser = context.read<AuthService>().currentUser;
    int userId = currentUser!.id!;
    int noteCount = await dbHelper.countNotes(userId);

    // If text is empty, do not save it
    if (text.trim().isEmpty) return;

    Note note = Note(
      userId: userId,
      noteText: text,
    );

    if (index < noteCount) {
      // Update existing note
      note.id = index + 1; // Assuming ID is 1-based, this can be more dynamic
      await dbHelper.updateNote(note);
    } else {
      // Insert new note
      await dbHelper.addNote(note);
    }
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
                  'Concentration',
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
                        color: Colors.red[400],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(120),
                          bottomRight: Radius.circular(120),
                        ),
                      ),
                      child: Text(
                        'My Notes',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                for (int index = 0; index < 10; index++)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Stack(
                                      children: [
                                        TextField(
                                          controller: _controllers[index],
                                          maxLines: 2,
                                          maxLength: 50,
                                          decoration: InputDecoration(),
                                          onChanged: (text) {
                                            // Auto-save when note is changed
                                            _saveNote(index, text);
                                          },
                                        ),
                                        Positioned(
                                          top:
                                              24.0, // Position of the horizontal line between two text lines
                                          left: 0,
                                          right: 0,
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class Goals extends StatefulWidget {
  const Goals({super.key});
  static const routeName = '/goals';

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  bool _isLoading = false;
  bool _checkboxEnabled = false;
  bool _wcheckboxEnabled = false; // Controls whether checkboxes are enabled
  // List<TextEditingController> _controllers =
  //     List.generate(10, (index) => TextEditingController());
  DatabaseService dbHelper = DatabaseService();

  // Toggle the checkbox enabled/disabled state
  void _toggleCheckboxState() {
    setState(() {
      _checkboxEnabled = !_checkboxEnabled;
    });
  }

  void _wtoggleCheckboxState() {
    setState(() {
      _wcheckboxEnabled = !_wcheckboxEnabled;
    });
  }

  List<TextEditingController> _controllers = [];
  List<TextEditingController> _wcontrollers = []; // Initialize empty list
  List<bool> _checkboxStates = [];
  List<bool> _wcheckboxStates = []; // Initialize empty list

  @override
  void initState() {
    super.initState();
    _loadGoals();
    _wloadGoals();
  }

// Load goals and initialize both _controllers and _checkboxStates
  Future<void> _loadGoals() async {
    User? currentUser = context.read<AuthService>().currentUser;
    int userId = currentUser!.id!;

    // Fetch goals from the database
    List<Goal> goals = await dbHelper.getGoal(userId);

    for (int i = 0; i < goals.length; i++) {
      _controllers.add(TextEditingController(text: goals[i].goalText));
      _checkboxStates.add(goals[i].checked); // Assuming 'checked' field in Goal
    }
    for (int i = _controllers.length; i < 5; i++) {
      _controllers.add(TextEditingController());
      _checkboxStates.add(false); // Default unchecked state
    }
    setState(() {
      _isLoading = false;
    });
  }

// Load goals and initialize both _controllers and _checkboxStates
  Future<void> _wloadGoals() async {
    User? currentUser = context.read<AuthService>().currentUser;
    int userId = currentUser!.id!;

    // Fetch goals from the database
    List<WGoal> wgoals = await dbHelper.getwGoal(userId);

    // Initialize controllers and checkbox states with goal data
    for (int i = 0; i < wgoals.length; i++) {
      _wcontrollers.add(TextEditingController(text: wgoals[i].goalText));
      _wcheckboxStates
          .add(wgoals[i].checked); // Assuming 'checked' field in Goal
    }

    // Initialize remaining controllers and checkbox states with default values
    for (int i = _wcontrollers.length; i < 5; i++) {
      _wcontrollers.add(TextEditingController());
      _wcheckboxStates.add(false); // Default unchecked state
    }
    setState(() {
      _isLoading = false;
    });
  }

// Save checkbox state in the database
  Future<void> _saveCheckboxState(int index, bool isComplete) async {
    User? currentUser = context.read<AuthService>().currentUser;
    int userId = currentUser!.id!;

    // Ensure you have a valid goal to update
    if (index < _controllers.length) {
      Goal goal = Goal(
        id: index +
            1, // Assuming ID is based on index, update with actual goal ID
        userId: userId,
        goalText: _controllers[index].text, // Use the existing text
        checked: isComplete, // Save the new checkbox state
      );

      // Update the goal in the database
      await dbHelper.updateGoal(goal);
    }
  }

// Save checkbox state in the database
  Future<void> _wsaveCheckboxState(int windex, bool wisComplete) async {
    User? currentUser = context.read<AuthService>().currentUser;
    int userId = currentUser!.id!;

    // Ensure you have a valid goal to update
    if (windex < _wcontrollers.length) {
      WGoal wgoal = WGoal(
        id: windex +
            1, // Assuming ID is based on index, update with actual goal ID
        userId: userId,
        goalText: _wcontrollers[windex].text, // Use the existing text
        checked: wisComplete, // Save the new checkbox state
      );

      // Update the goal in the database
      await dbHelper.updatewGoal(wgoal);
    }
  }

// Save the text when changed
  Future<void> _saveNote(int index, String text) async {
    // Get the count of existing notes for the user
    User? currentUser = context.read<AuthService>().currentUser;
    int userId = currentUser!.id!;
    int goalcount = await dbHelper.countGoal(userId);

    // If text is empty, do not save it
    if (text.trim().isEmpty) return;

    Goal goal = Goal(
      userId: userId,
      goalText: text,
      checked: _checkboxStates[index],
    );

    if (index < goalcount) {
      // Update existing note
      goal.id = index + 1; // Assuming ID is 1-based, this can be more dynamic
      await dbHelper.updateGoal(goal);
    } else {
      // Insert new note
      await dbHelper.addGoal(goal);
    }
  }

// Save the text when changed
  Future<void> _wsaveNote(int windex, String wtext) async {
    // Get the count of existing notes for the user
    User? currentUser = context.read<AuthService>().currentUser;
    int userId = currentUser!.id!;
    int wgoalcount = await dbHelper.countwGoal(userId);

    // If text is empty, do not save it
    if (wtext.trim().isEmpty) return;

    WGoal wgoal = WGoal(
      userId: userId,
      goalText: wtext,
      checked: _wcheckboxStates[windex],
    );

    if (windex < wgoalcount) {
      // Update existing note
      wgoal.id = windex + 1; // Assuming ID is 1-based, this can be more dynamic
      await dbHelper.updatewGoal(wgoal);
    } else {
      // Insert new note
      await dbHelper.addwGoal(wgoal);
    }
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
                  'Concentration',
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
                // height: 600,
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
                        'Set Goals',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          child: TextButton(
                              onPressed: _toggleCheckboxState,
                              child: _checkboxEnabled
                                  ? Icon(
                                      Icons.playlist_remove_rounded,
                                      color: Colors.green[300],
                                    )
                                  : Icon(
                                      Icons.playlist_add,
                                      color: Colors.green[300],
                                    )),
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        Expanded(
                            child: Text(
                          ('Daily Goals'),
                        )),
                      ],
                    ),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                            // height: 400,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                for (int index = 0; index < 5; index++)
                                  Container(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Checkbox(
                                            value: _checkboxStates[
                                                index], // Use the tracked checkbox state
                                            onChanged: _checkboxEnabled
                                                ? (value) {
                                                    setState(() {
                                                      _checkboxStates[index] =
                                                          value!; // Update the state
                                                      _saveCheckboxState(index,
                                                          value); // Save the updated state to the database
                                                    });
                                                  }
                                                : null, // Disable checkbox if _checkboxEnabled is false
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: //
                                                Stack(
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                TextField(
                                                  controller:
                                                      _controllers[index],
                                                  maxLines: 2,
                                                  maxLength: 50,
                                                  decoration: InputDecoration(),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  enabled:
                                                      _checkboxEnabled, // Control interaction
                                                  onChanged: (text) {
                                                    // Auto-save when note is changed
                                                    _saveNote(index, text);
                                                  },
                                                ),
                                                Positioned(
                                                  top:
                                                      18.0, // Position of the horizontal line between two text lines
                                                  left: 0,
                                                  right: 0,
                                                  child: Divider(
                                                    color: Colors.grey,
                                                    thickness: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  Container(
                    // height: 600,
                    width: 325,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              child: TextButton(
                                  onPressed: _wtoggleCheckboxState,
                                  child: _wcheckboxEnabled
                                      ? Icon(
                                          Icons.playlist_remove_rounded,
                                          color: Colors.green[300],
                                        )
                                      : Icon(
                                          Icons.playlist_add,
                                          color: Colors.green[300],
                                        )),
                            ),
                            SizedBox(
                              width: 60,
                            ),
                            Expanded(
                                child: Text(
                              ('Weekly Goals'),
                            )),
                          ],
                        ),
                        _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : Container(
                                // height: 400,
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    for (int windex = 0; windex < 5; windex++)
                                      Container(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: Checkbox(
                                                value: _wcheckboxStates[
                                                    windex], // Use the tracked checkbox state
                                                onChanged: _wcheckboxEnabled
                                                    ? (value) {
                                                        setState(() {
                                                          _wcheckboxStates[
                                                                  windex] =
                                                              value!; // Update the state
                                                          _wsaveCheckboxState(
                                                              windex,
                                                              value); // Save the updated state to the database
                                                        });
                                                      }
                                                    : null, // Disable checkbox if _checkboxEnabled is false
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: //
                                                    Stack(
                                                  children: [
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    TextField(
                                                      controller:
                                                          _wcontrollers[windex],
                                                      maxLines: 2,
                                                      maxLength: 50,
                                                      decoration:
                                                          InputDecoration(),
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                      enabled:
                                                          _wcheckboxEnabled, // Control interaction
                                                      onChanged: (text) {
                                                        // Auto-save when note is changed
                                                        _wsaveNote(
                                                            windex, text);
                                                      },
                                                    ),
                                                    Positioned(
                                                      top:
                                                          18.0, // Position of the horizontal line between two text lines
                                                      left: 0,
                                                      right: 0,
                                                      child: Divider(
                                                        color: Colors.grey,
                                                        thickness: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Procrastination extends StatefulWidget {
  const Procrastination({super.key});
  static const routeName = '/procrastination';

  @override
  State<Procrastination> createState() => _ProcrastinationState();
}

class _ProcrastinationState extends State<Procrastination> {
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
                  'Concentration',
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
                      padding: EdgeInsets.only(
                        top: 5,
                        right: 15,
                        left: 15,
                        bottom: 5,
                      ),
                      margin: EdgeInsets.only(top: 0.5),
                      height: 90,
                      width: 320,
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent[400],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(120),
                          bottomRight: Radius.circular(120),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Avoid',
                            style: TextStyle(fontSize: 27, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Procrastination',
                            style: TextStyle(fontSize: 27, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
                                    '1. Just Start',
                                    style: TextStyle(
                                      color: Colors.yellow[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 35),
                                  // alignment: Alignment.centerRight,
                                  child: Text(
                                    '''The hardest part of any task is often getting started. Don’t overthink it—just commit to
working on the task for 5 minutes. Once
you start, it becomes easier to continue.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
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
                                    '2. Set Short, Realistic Deadlines',
                                    style: TextStyle(
                                      color: Colors.yellow[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 35),
                                  // alignment: Alignment.centerRight,
                                  child: Text(
                                    '''Long deadlines can encourage procrastination. Instead, set short,
achievable deadlines to create urgency
and keep yourself accountable.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
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
                                    '3. Forgive Yourself for Past Procrastination',
                                    style: TextStyle(
                                      color: Colors.yellow[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 35),
                                  // alignment: Alignment.centerRight,
                                  child: Text(
                                    '''Beating yourself up over previous procrastination can lead to more delay.
Accept it, let go of the guilt, and focus on
what you can accomplish moving forward.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
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
                                    '4. Plan Breaks to Avoid Burnout',
                                    style: TextStyle(
                                      color: Colors.yellow[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 35),
                                  // alignment: Alignment.centerRight,
                                  child: Text(
                                    '''Working without breaks can lead to fatigue and procrastination. Plan regular 
short breaks to rest your mind and 
maintain productivity.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
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
                                    '5.Visualize the Consequences of Procrastination',
                                    style: TextStyle(
                                      color: Colors.yellow[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 35),
                                  // alignment: Alignment.centerRight,
                                  child: Text(
                                    '''Think about what could go wrong if youkeep putting off tasks. This can motivate
you to take action and avoid negative
outcomes.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
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
                                    '6. Take Responsibility',
                                    style: TextStyle(
                                      color: Colors.yellow[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 35),
                                  // alignment: Alignment.centerRight,
                                  child: Text(
                                    '''Procrastination often happens when we avoid responsibility. Accept full 
responsibility for completing the task 
and take ownership of the outcome.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
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
                                    '7. Set Boundaries for Distractions',
                                    style: TextStyle(
                                      color: Colors.yellow[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 35),
                                  // alignment: Alignment.centerRight,
                                  child: Text(
                                    '''Establish clear boundaries with people, devices, and activities that may distract 
you from work. Let others know when 
you're focusing, and set specific times 
for distractions like social media.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
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
                                    '8. Practice Self-Compassion',
                                    style: TextStyle(
                                      color: Colors.yellow[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 35),
                                  // alignment: Alignment.centerRight,
                                  child: Text(
                                    '''Being overly critical of yourself can lead to stress and procrastination. Instead, 
practice self-compassion. Recognize that 
it's okay to struggle sometimes and focus 
on making progress.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
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
                                    '9. Break Large Tasks into Smaller Steps',
                                    style: TextStyle(
                                      color: Colors.yellow[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 35),
                                  // alignment: Alignment.centerRight,
                                  child: Text(
                                    '''Large tasks can feel daunting and lead to avoidance. Break them down 
into smaller, more manageable steps 
to make them easier to approach.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
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
                                    '10. Reward Progress, Not Just Completion',
                                    style: TextStyle(
                                      color: Colors.yellow[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 35),
                                  // alignment: Alignment.centerRight,
                                  child: Text(
                                    '''Waiting until the end to reward yourself can delay motivation. Reward yourself 
for making progress, even if the task 
isn’t fully completed yet.''',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
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
                  'Concentration',
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
                      Navigator.pushNamed(context, '/notes');
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
                                Icons.note_alt,
                                size: 100,
                                color: Colors.pink,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/notes');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(
                                  16), // Customize padding inside button
                            ),
                            child: Text('My Notes'),
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
                        Navigator.pushNamed(context, '/goals');
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
                                  Icons.flag,
                                  size: 100,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/goals');
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(16),
                              ),
                              child: Text(
                                'Set Goals',
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
                      Navigator.pushNamed(context, '/procrastination');
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
                                Icons.warning,
                                size: 100,
                                color: const Color.fromARGB(255, 213, 255, 59),
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/procrastination');
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(16),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Avoid',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  Text(
                                    'Procrastination',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              )),
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
