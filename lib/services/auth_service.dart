// lib/services/auth_service.dart

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'database_service.dart';
import '../model/user.dart';

class AuthService {
  final DatabaseService _databaseService = DatabaseService();

  // Stream to manage authentication state
  // Since we're using a local database, we'll manage auth state manually
  User? _currentUser;
  User? get currentUser => _currentUser;

  bool isLoggedIn() {
    return _currentUser != null;
  }

  // Sign Up with Email & Password
  Future<void> signUp(
      {required String fullname,
      required String username,
      required String password}) async {
    // Check if user already exists
    User? existingUser = await _databaseService.getUserByEmail(username);
    if (existingUser != null) {
      throw Exception('User already exists.');
    }

    // Hash the password
    String passwordHash = _hashPassword(password);

    // Create a new user
    User newUser = User(
        fullname: fullname, username: username, passwordHash: passwordHash);
    await _databaseService.insertUser(newUser);
  }

  // Sign In with Email & Password
  Future<void> signIn(
      {required String username, required String password}) async {
    User? user = await _databaseService.getUserByEmail(username);
    if (user == null) {
      throw Exception('No user found for that Username.');
    }

    String passwordHash = _hashPassword(password);
    if (user.passwordHash != passwordHash) {
      throw Exception('Incorrect password.');
    }

    // Set the current user
    _currentUser = user;
  }

  // Sign Out
  void signOut() {
    _currentUser = null;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) {
      throw Exception('No user is currently logged in.');
    }

    // Verify current password
    String currentPasswordHash = _hashPassword(currentPassword);
    if (_currentUser!.passwordHash != currentPasswordHash) {
      throw Exception('Current password is incorrect.');
    }

    // Hash the new password
    String newPasswordHash = _hashPassword(newPassword);

    // Update the password in the database
    User updatedUser = User(
      id: _currentUser!.id,
      fullname: _currentUser!.fullname,
      username: _currentUser!.username,
      passwordHash: newPasswordHash,
    );

    await _databaseService.updateUser(updatedUser);

    // Update the current user in memory with the new password
    _currentUser = updatedUser;

    // Optionally, show success message
    print('Password changed successfully.');
  }

  // Hash the password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password); // data being hashed
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> updateUserInfo({
    required int userId,
    String? fullname,
    String? username,
    String? password,
  }) async {
    // Retrieve the current user information
    User? existingUser = await _databaseService.getUserById(userId);
    if (existingUser == null) {
      throw Exception('User not found.');
    }

    // Hash the password if a new password is provided, otherwise keep the old hash
    String passwordHash = existingUser.passwordHash;
    if (password != null && password.isNotEmpty) {
      passwordHash = _hashPassword(password);
    }

    // Update the user's information (use the existing values if no new values are provided)
    User updatedUser = User(
      id: userId,
      fullname: fullname ?? existingUser.fullname,
      username: username ?? existingUser.username,
      passwordHash: passwordHash,
    );

    // Update the user in the database
    await _databaseService.updateUser(updatedUser);
  }

  Future<void> updateUserInfoacc({
    required int userId,
    String? fullname,
    String? username,
    String? password,
  }) async {
    // Retrieve the current user information
    User? existingUser = await _databaseService.getUserById(userId);
    if (existingUser == null) {
      throw Exception('User not found.');
    }

    // Hash the password if a new password is provided, otherwise keep the old hash
    String passwordHash = existingUser.passwordHash;
    if (password != null && password.isNotEmpty) {
      passwordHash = _hashPassword(password);
    }

    // Update the user's information (use the existing values if no new values are provided)
    User updatedUser = User(
      id: userId,
      fullname: fullname ?? existingUser.fullname,
      username: username ?? existingUser.username,
      passwordHash: passwordHash,
    );

    // Update the user in the database
    await _databaseService.updateUser(updatedUser);
  }
}
