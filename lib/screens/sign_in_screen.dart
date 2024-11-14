// lib/screens/sign_in_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/sign-in';
  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
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
      await context
          .read<AuthService>()
          .signIn(username: _email.trim(), password: _password.trim());
      // Navigate to Home is handled by auth state listener
      if (mounted) {
        // Proceed with further operations like navigating to the next screen
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToSignUp() {
    Navigator.of(context).pushReplacementNamed('/sign-up');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 77, 172, 140),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 85, left: 10),
                  child: Container(
                    padding: EdgeInsets.only(left: 25),
                    alignment:
                        Alignment.centerLeft, // Aligns the Text to the left
                    child: Text(
                      'Welcome Back!',
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
                  height: 100,
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
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          setState(
                            () {
                              _error = null;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              // SizedBox(height: 20),
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
                padding: EdgeInsets.only(
                  top: 30,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 35),
                      alignment:
                          Alignment.centerLeft, // Aligns the Text to the left
                      child: Text(
                        'Log In Now',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 77, 172, 140),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 30,
                          left: 30,
                          right: 30,
                        ),
                        child: Column(
                          children: [
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
                                cursorHeight: 20,
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
                                    return 'Incorrect Username.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _email = value!;
                                },
                              ),
                            ),
                            SizedBox(height: 20),
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
                                cursorHeight: 20,
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
                                      'Sign In',
                                      style: TextStyle(color: Colors.white),
                                    )),
                            TextButton(
                              onPressed: _navigateToSignUp,
                              child: Text(
                                'Create new account',
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
                                    MediaQuery.of(context).size.height * 0.50,
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
                    )
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
