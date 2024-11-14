import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/side.dart';

class Motivational extends StatefulWidget {
  const Motivational({super.key});
  static const routeName = '/motivational';

  @override
  State<Motivational> createState() => _MotivationalState();
}

class _MotivationalState extends State<Motivational> {
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
                  '''MOTIVATIONAL 
QUOTES''',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
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
                    color: Color.fromARGB(255, 177, 132, 110),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue)),
                child: Column(
                  children: [
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
                                    '''“Success is the sum of small efforts, repeated day in and day out.”
 – Robert Collier


“Don’t watch the clock; do what it does. Keep going.”
 – Sam Levenson


“The only way to do great work is to love what you do.”
 – Steve Jobs


“Focus on being productive instead of busy.”
 – Tim Ferriss


“Your mind is for having ideas, not holding them.”
 – David Allen


“It’s not about having time. It’s about making time.” 
– Unknown


“You don’t have to be great to start, but you have to start to be great.”
 – Zig Ziglar


“The secret of getting ahead is getting started.”
 – Mark Twain


“You can’t build a reputation on what you are going to do.”
 – Henry Ford


“Discipline is the bridge between goals and accomplishment.”
 – Jim Rohn''',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: 'PlayfairDisplay'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   width: double.infinity,
                          //   margin: EdgeInsets.only(
                          //     top: 15,
                          //     bottom: 20,
                          //     left: 10,
                          //     right: 10,
                          //   ),
                          //   child: Column(
                          //     children: [
                          //       Container(
                          //         alignment: Alignment.centerLeft,
                          //         child: Text(
                          //           'Title',
                          //           style: TextStyle(
                          //             color: Colors.blue[200],
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         height: 20,
                          //       ),
                          //       SizedBox(
                          //         height: 10,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //   width: double.infinity,
                          //   margin: EdgeInsets.only(
                          //     top: 15,
                          //     bottom: 20,
                          //     left: 10,
                          //     right: 10,
                          //   ),
                          //   child: Column(
                          //     children: [
                          //       Container(
                          //         alignment: Alignment.centerLeft,
                          //         child: Text(
                          //           'Title',
                          //           style: TextStyle(
                          //             color: Colors.blue[200],
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         height: 20,
                          //       ),
                          //       SizedBox(
                          //         height: 10,
                          //       ),
                          //     ],
                          //   ),
                          // ),
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
