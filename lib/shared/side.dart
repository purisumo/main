import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Future<void> _signOut(BuildContext context) async {
    // Add your sign-out logic here (e.g., Firebase sign-out, clearing tokens, etc.)
    Navigator.of(context).pushReplacementNamed(
        '/sign-in'); // Navigate to login screen or any other screen after logout
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss the dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 166, 226, 173),
          content: Text(
            'Are you sure you want to log out?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 6, 83, 83),
                    maximumSize: Size(85, 35),
                    minimumSize: Size(85, 35),
                    shadowColor: Colors.black,
                    elevation: 5,
                    side: BorderSide(
                      color: Colors.black,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss the dialog
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 6, 83, 83),
                    maximumSize: Size(85, 35),
                    minimumSize: Size(85, 35),
                    shadowColor: Colors.black,
                    elevation: 5,
                    side: BorderSide(
                      color: Colors.black,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss the dialog
                    _signOut(context); // Call the logout function
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromARGB(255, 206, 236, 221),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ), // This gives it a modal-like look
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize:
              MainAxisSize.min, // Makes the dialog as small as possible
          children: <Widget>[
            _buildDrawerButton(context, 'Home', Icons.home, '/home'),
            _buildDrawerButton(context, 'About', Icons.question_mark, '/about'),
            _buildDrawerButton(
                context, 'Settings', Icons.settings, '/change_user'),
            _buildDrawerButton(context, 'Log out', Icons.logout, null,
                onTap: () {
              _showLogoutConfirmationDialog(
                  context); // Show confirmation dialog
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerButton(
      BuildContext context, String text, IconData icon, String? routeName,
      {Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 6, 83, 83),
          elevation: 5,
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: onTap ??
            () {
              Navigator.pop(context); // Close the modal
              if (routeName != null) {
                Navigator.pushNamed(context, routeName);
              }
            },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            SizedBox(width: 20),
            Icon(icon),
          ],
        ),
      ),
    );
  }
}
