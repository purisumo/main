import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../shared/side.dart';

class About extends StatelessWidget {
  const About({super.key});
  static const routeName = '/about';

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
                  -120, // Adjust the top value to control how much of the container is visible
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
                  -1420, // Adjust the top value to control how much of the container is visible
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
                        'ABOUT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('test'),
                  ),
                  SizedBox(
                    width: double.infinity,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
