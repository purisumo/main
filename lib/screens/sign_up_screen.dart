// lib/screens/sign_up_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _error;

  void _submit() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) return;

    _formKey.currentState?.save();

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get the AuthService instance before any async calls
      final authService = context.read<AuthService>();

      // Perform the sign-up process
      await authService.signUp(
        fullname: _name.trim(),
        username: _email.trim(),
        password: _password.trim(),
      );

      // Check if the widget is still mounted before continuing
      if (!mounted) return;

      // After successful sign-up, sign in the user
      await authService.signIn(
        username: _email.trim(),
        password: _password.trim(),
      );

      // Additional logic after sign-in (e.g., navigation)
      if (mounted) {
        // Proceed with further operations like navigating to the next screen
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        // Show the error alert box
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(e.toString()), // Display the error message
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
        print(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToSignIn() {
    Navigator.of(context).pushReplacementNamed('/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 77, 172, 140),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Container(
                color: Color.fromARGB(255, 77, 172, 140),
                child: Padding(
                  padding: const EdgeInsets.only(top: 85, left: 10),
                  child: Container(
                    padding: EdgeInsets.only(left: 25),
                    alignment:
                        Alignment.centerLeft, // Aligns the Text to the left
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Open Sans'),
                    ),
                  ),
                ),
              ),
              if (_error != null)
                Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.redAccent,
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.white),
                      SizedBox(width: 8),
                      Expanded(
                          child: Text(
                        _error!,
                        style: TextStyle(color: Colors.white),
                      )),
                      IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _error = null;
                            });
                          })
                    ],
                  ),
                ),
              Spacer(),
              Container(
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(75),
                    topRight: Radius.circular(75),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 25,
                        right: 25,
                        top: 30,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment
                                  .centerLeft, // Aligns the Text to the left
                              child: Text(
                                'Sign Up Now',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 77, 172, 140),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment
                                  .centerLeft, // Aligns the Text to the left
                              child: Text(
                                'Fullname',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            ),
                            SizedBox(
                              height: 45,
                              child: TextFormField(
                                key: ValueKey('fullname'),
                                style: TextStyle(height: 1),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 206, 236, 221),
                                      width: 1.0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                  ),
                                  fillColor: Color.fromARGB(255, 206, 236, 221),
                                  filled: true,
                                ),
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter valid name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _email = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 5,
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
                              height: 45,
                              child: TextFormField(
                                key: ValueKey('username'),
                                style: TextStyle(height: 1),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 206, 236, 221),
                                      width: 1.0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                  ),
                                  fillColor: Color.fromARGB(255, 206, 236, 221),
                                  filled: true,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Valid Username';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _email = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 5,
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
                              height: 45,
                              child: TextFormField(
                                key: ValueKey('password'),
                                style: TextStyle(height: 1),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 206, 236, 221),
                                      width: 1.0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                  ),
                                  fillColor: Color.fromARGB(255, 206, 236, 221),
                                  filled: true,
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.length < 6) {
                                    return 'Password must be at least 6 characters long.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _password = value!;
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            _isLoading
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 3,
                                      minimumSize: Size(75, 35),
                                      backgroundColor:
                                          Color.fromARGB(255, 63, 107, 92),
                                    ),
                                    onPressed: _submit,
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(color: Colors.white),
                                    )),
                            TextButton(
                              onPressed: _navigateToSignIn,
                              child: Text(
                                'Already have an account? Sign In',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                // Wrapping Stack with SizedBox to provide constraints
                                width: MediaQuery.of(context).size.width * 0.6,
                                height:
                                    MediaQuery.of(context).size.height * 0.48,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      // Move the container 20% from the right and 20% from the bottom
                                      right: MediaQuery.of(context).size.width *
                                          -0.1,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      child: Container(
                                        height: 175,
                                        width: 175,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 148, 203, 185),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(100),
                                            topRight: Radius.circular(100),
                                            bottomLeft: Radius.circular(100),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: MediaQuery.of(context).size.width *
                                          0.1, // adjust as needed
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.2, // adjust as needed
                                      child: Container(
                                        height: 150, // adjust as needed
                                        width: 150, // adjust as needed
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 121, 160, 141),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(100),
                                            topRight: Radius.circular(100),
                                            bottomLeft: Radius.circular(100),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
