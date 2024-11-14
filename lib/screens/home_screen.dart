// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../shared/side.dart';
import 'time_management.dart';
import 'concentration.dart';
import 'motivational_quote.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // final user = context.read<AuthService>().currentUser;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 206, 236, 221),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 77, 172, 140),
        foregroundColor: Colors.white,
        title: GestureDetector(),
        leading: IconButton(
          icon: Icon(Icons.home), // Change this to any icon
          onPressed: () {},
        ),
      ),
      endDrawer: AppDrawer(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        child: Center(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center the buttons vertically
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 77, 172, 140),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100),
                      ),
                    ),
                    child: Text(
                      'FOCUSBOOST',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  // Text(
                  //   'Welcome, ${user?.username ?? 'User'}!',
                  //   style: TextStyle(fontSize: 20),
                  // ),
                  // SizedBox(
                  //     height: 20), // Add some space between the text and the buttons
                  Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.15,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 121, 160, 141),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                margin: EdgeInsets.all(10),
                                child: Icon(Icons.timer),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  minimumSize: Size(200, 60),
                                  backgroundColor:
                                      Color.fromARGB(255, 63, 107, 92),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, TimeManagement.routeName);
                                },
                                child: Text(
                                  'Time Management',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 121, 160, 141),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                margin: EdgeInsets.all(10),
                                child: Icon(Icons.hearing_outlined),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  minimumSize: Size(200, 60),
                                  backgroundColor:
                                      Color.fromARGB(255, 63, 107, 92),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Concentration.routeName);
                                },
                                child: Text(
                                  'Concentration',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 121, 160, 141),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                margin: EdgeInsets.all(10),
                                child: Icon(Icons.comment),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  minimumSize: Size(200, 60),
                                  backgroundColor:
                                      Color.fromARGB(255, 63, 107, 92),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Motivational.routeName);
                                },
                                child: Text(
                                  'Motivational Quotes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).size.height *
                    0.65, // You can position it relative to the parent
                right: -25, // Adjust position as needed
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.6, //
                          // decoration: BoxDecoration(
                          //   color: const Color.fromARGB(255, 255, 0, 0),
                          //   borderRadius: BorderRadius.all(
                          //     Radius.circular(100),
                          //   ),
                          // ),
                          child: Stack(
                            children: [
                              Positioned(
                                // Move the container 20% from the right and 20% from the bottom
                                right: MediaQuery.of(context).size.width * -0.1,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.18,
                                child: Container(
                                  height: 175,
                                  width: 175,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 148, 203, 185),
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
                                    0.15, // adjust as needed
                                bottom: MediaQuery.of(context).size.height *
                                    0.16, // adjust as needed
                                child: Container(
                                  height: 150, // adjust as needed
                                  width: 150, // adjust as needed
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 121, 160, 141),
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
      ),
    );
  }
}
