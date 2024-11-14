class TaskList {
  int? id;
  int userId;
  String taskText;
  DateTime? created;
  int targetTime;
  bool isComplete;

  TaskList({
    this.id,
    required this.userId,
    required this.taskText,
    this.created,
    required this.targetTime,
    this.isComplete = false,
  });

  TaskList.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        userId = map['user_id'],
        taskText = map['task_text'],
        created =
            map['created'] != null ? DateTime.parse(map['created']) : null,
        targetTime = map['target_time'],
        isComplete = map['is_complete'] == 1; // Convert 0/1 to boolean

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'task_text': taskText,
      'created': created?.toIso8601String(),
      'target_time': targetTime,
      'is_complete': isComplete ? 1 : 0, // Convert boolean to 0/1
    };
  }
}

class FocusSession {
  int? id;
  String focusText;

  FocusSession({this.id, required this.focusText});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'focus_text': focusText,
    };
  }

  factory FocusSession.fromMap(Map<String, dynamic> map) {
    return FocusSession(
      id: map['id'],
      focusText: map['focus_text'],
    );
  }
}

class Note {
  int? id;
  int userId;
  String noteText;

  Note({this.id, required this.userId, required this.noteText});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'note_text': noteText,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      userId: map['user_id'],
      noteText: map['note_text'],
    );
  }
}

class Goal {
  int? id;
  int userId;
  String goalText;
  bool checked;

  Goal(
      {this.id,
      required this.userId,
      required this.goalText,
      this.checked = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'goal_text': goalText,
      'checked': checked ? 1 : 0,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      userId: map['user_id'],
      goalText: map['goal_text'],
      checked: map['checked'] == 1,
    );
  }
}

class WGoal {
  int? id;
  int userId;
  String goalText;
  bool checked;

  WGoal(
      {this.id,
      required this.userId,
      required this.goalText,
      this.checked = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'goal_text': goalText,
      'checked': checked ? 1 : 0,
    };
  }

  factory WGoal.fromMap(Map<String, dynamic> map) {
    return WGoal(
      id: map['id'],
      userId: map['user_id'],
      goalText: map['goal_text'],
      checked: map['checked'] == 1,
    );
  }
}

class Procrastination {
  int? id;
  String procText;

  Procrastination({this.id, required this.procText});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'proc_text': procText,
    };
  }

  factory Procrastination.fromMap(Map<String, dynamic> map) {
    return Procrastination(
      id: map['id'],
      procText: map['proc_text'],
    );
  }
}
