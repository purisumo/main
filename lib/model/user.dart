class User {
  final int? id;
  final String fullname;
  final String username;
  final String passwordHash;

  User(
      {this.id,
      required this.fullname,
      required this.username,
      required this.passwordHash});

  // Convert a User into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'username': username,
      'passwordHash': passwordHash,
    };
  }

  // Implement toString to make it easier to see information about each user.
  @override
  String toString() {
    return 'User{id: $id, username: $username}';
  }
}
