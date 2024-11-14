import 'dart:io';

import 'package:flutter/material.dart';
import 'package:main/shared/side.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../model/user.dart';
import '../services/database_service.dart';
import 'dart:async';

class UpdateUserInfoScreen extends StatefulWidget {
  static const routeName = '/change_user';

  @override
  // ignore: library_private_types_in_public_api
  _UpdateUserInfoScreenState createState() => _UpdateUserInfoScreenState();
}

class _UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  User? _currentUser;
  late int userId;

  void _signOut(BuildContext context) {
    context.read<AuthService>().signOut();
    if (mounted) {
      // Proceed with further operations like navigating to the next screen
      Navigator.of(context).pushReplacementNamed('/sign-in');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    userId = _currentUser!.id!;
  }

  Future<void> _loadUserInfo() async {
    User? currentUser = context.read<AuthService>().currentUser;
    if (currentUser != null) {
      setState(() {
        _fullnameController.text = currentUser.fullname;
        _usernameController.text = currentUser.username;
      });
    } else {
      print('No user is logged in');
    }
    _currentUser = currentUser;
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      String fullname = _fullnameController.text;
      String username = _usernameController.text;
      String password = _passwordController.text;

      await AuthService().updateUserInfoacc(
        userId: userId,
        fullname: fullname,
        username: username,
        password: password.isNotEmpty
            ? password
            : null, // Only update password if entered
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Update Success, Please Login again'),
        ));
        sleep(Duration(seconds: 2));
        _signOut(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 90, 140, 123),
        foregroundColor: Colors.white,
      ),
      endDrawer: AppDrawer(),
      body: Container(
        color: Color.fromARGB(255, 90, 140, 123),
        child: Stack(
          children: [
            Positioned(
              bottom:
                  -140, // Adjust the top value to control how much of the container is visible
              left: 0,
              right: 0,
              child: Container(
                height: 600, // Even taller for a more elongated vertical oval
                width: 500, // Narrower width
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 196, 215, 205),
                  borderRadius: BorderRadius.all(
                    Radius.elliptical(300,
                        320), // Adjust radii to match the new height and width
                  ),
                ),
              ),
            ),
            Positioned(
              bottom:
                  -1380, // Adjust the top value to control how much of the container is visible
              left: 0,
              right: 0,
              child: Container(
                height: 1500, // Even taller for a more elongated vertical oval
                width: 500, // Narrower width
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 6, 83, 83),
                  borderRadius: BorderRadius.all(
                    Radius.elliptical(500,
                        250), // Adjust radii to match the new height and width
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      // color: Colors.amber,
                      child: Text(
                        'Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.all(35),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment
                                  .centerLeft, // Aligns the Text to the left
                              child: Text(
                                'Full Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: TextFormField(
                                controller: _fullnameController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment
                                  .centerLeft, // Aligns the Text to the left
                              child: Text(
                                'Username',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment
                                  .centerLeft, // Aligns the Text to the left
                              child: Text(
                                'Password',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    labelText:
                                        'Password (Leave blank for same password)'),
                                obscureText: true,
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _saveChanges,
                              style: ElevatedButton.styleFrom(
                                elevation: 3,
                                minimumSize: Size(75, 35),
                                backgroundColor:
                                    Color.fromARGB(255, 63, 107, 92),
                              ),
                              child: Text(
                                'Save Changes',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
