// lib/screens/sign_in_screen.dart

import 'package:flutter/material.dart';
import 'package:main/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../screens/sign_in_screen.dart';
import 'package:simple_shadow/simple_shadow.dart';

class Index extends StatefulWidget {
  static const routeName = '/index';

  @override
  IndexState createState() => IndexState();
}

class ShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // draw the shadow
    Paint paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class IndexState extends State<Index> {
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 77, 172, 140),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(30),
                // color: Colors.amber[400],
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: AnimatedContainer(
                          padding: EdgeInsets.only(left: 15),
                          width: _isClicked ? 150 : 250,
                          height: _isClicked ? 150 : 250,
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeInOut,
                          child: SimpleShadow(
                            opacity: 0.4, // Default: 0.5
                            color: Colors.black, // Default: Black
                            offset: Offset(0, 15), // Default: Offset(2, 2)
                            child: Image.asset(
                                'assets/462539313_1598653967735318_1078102689429585755_n.png'), // Default: 2
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // SizedBox(height: 20),
              Spacer(),
              AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                height: _isClicked ? 430 : 280,
                width: double.infinity,
                padding: EdgeInsets.only(top: 25),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          100), // Only top-left corner has a radius
                    ),
                    color: Colors.white),
                child: Column(
                  children: [
                    SizedBox(
                      child: Stack(
                        children: [
                          // First text widget
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 1000),
                            opacity: _isClicked
                                ? 0.0
                                : 1.0, // When not clicked, this is visible
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "FOCUSBOOST",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.black87,
                                      fontFamily: 'Open Sans',
                                      letterSpacing: 5),
                                ),
                              ],
                            ),
                          ),

                          // Second text widget
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 1000),
                            opacity: _isClicked
                                ? 1.0
                                : 0.0, // When clicked, this becomes visible
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello, Welcome!",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 148, 203, 185),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: Stack(
                        children: [
                          AnimatedOpacity(
                            opacity: _isClicked ? 0 : 1,
                            duration: Duration(microseconds: 1000),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "turn distraction into progress -",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  "stay on track with focusboost by your side",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 1000),
                            opacity: _isClicked ? 1 : 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome to FocusBoost, your tool for",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  "Better focus and productivity",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isClicked)
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 1000),
                        opacity: _isClicked ? 1 : 0,
                        child: SizedBox(
                          child: Stack(
                            children: [
                              AnimatedOpacity(
                                opacity: _isClicked ? 1 : 0,
                                duration: Duration(milliseconds: 1000),
                                child: Column(
                                  children: [
                                    SizedBox(height: 30),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 63, 107, 92),
                                        minimumSize: Size(220, 40),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, SignInScreen.routeName);
                                      },
                                      child: Text(
                                        'Log in',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 63, 107, 92),
                                        minimumSize: Size(220, 40),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, SignUpScreen.routeName);
                                      },
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    if (_isClicked != true)
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 1000),
                        opacity: _isClicked ? 0 : 1,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 35,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 63, 107, 92),
                                minimumSize: Size(120, 30),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isClicked =
                                      !_isClicked; // Toggle _isClicked state on button press
                                });
                              },
                              child: Text(
                                'Start',
                                style: TextStyle(
                                    fontSize: 20,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Spacer(),
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 1000),
                      opacity: _isClicked ? 1 : 0,
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
                                    MediaQuery.of(context).size.height * 0.55,
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


// SizedBox(
//                       child: Stack(
//                         children: [
//                           AnimatedOpacity(
//                             opacity: _isClicked ? 1 : 0,
//                             duration: Duration(milliseconds: 1000),
//                             child: Column(
//                               children: [
//                                 SizedBox(height: 50),
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.greenAccent,
//                                     minimumSize: Size(200, 50),
//                                   ),
//                                   onPressed: () {
//                                     Navigator.pushNamed(
//                                         context, SignInScreen.routeName);
//                                   },
//                                   child: Text('Login'),
//                                 ),
//                                 SizedBox(height: 50),
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.greenAccent,
//                                     minimumSize: Size(200, 50),
//                                   ),
//                                   onPressed: () {
//                                     Navigator.pushNamed(
//                                         context, SignInScreen.routeName);
//                                   },
//                                   child: Text('Sign Up'),
//                                 )
//                               ],
//                             ),
//                           ),
//                           AnimatedOpacity(
//                             duration: Duration(milliseconds: 1000),
//                             opacity: _isClicked ? 0 : 1,
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 35,
//                                 ),
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.greenAccent,
//                                     minimumSize: Size(150, 35),
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       _isClicked =
//                                           !_isClicked; // Toggle _isClicked state on button press
//                                     });
//                                   },
//                                   child: Text('Start'),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),