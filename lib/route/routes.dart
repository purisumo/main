import 'package:flutter/material.dart';
import 'package:main/services/auth_service.dart';
import 'package:main/services/database_service.dart';
import 'package:main/model/user.dart';
import '/screens/sign_in_screen.dart';
import '/screens/sign_up_screen.dart';
import '/screens/home_screen.dart';
import '/screens/time_management.dart';
import '/screens/concentration.dart';
import '/screens/motivational_quote.dart';
import '/screens/change_pass.dart';
import '/screens/index.dart';
import '/screens/about.dart';
import 'package:main/screens/loading_screen.dart';
import 'package:main/screens/user_setting.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return _buildPageRoute(SplashScreen(), settings);
      case Index.routeName:
        return _buildPageRoute(Index(), settings);
      case SignInScreen.routeName:
        return _buildPageRoute(SignInScreen(), settings);
      case SignUpScreen.routeName:
        return _buildPageRoute(SignUpScreen(), settings);
      case HomeScreen.routeName:
        return _buildPageRoute(HomeScreen(), settings);
      case TimeManagement.routeName:
        return _buildPageRoute(TimeManagement(), settings);
      case Concentration.routeName:
        return _buildPageRoute(Concentration(), settings);
      case Motivational.routeName:
        return _buildPageRoute(Motivational(), settings);
      case TaskLists.routeName:
        return _buildPageRoute(TaskLists(), settings);
      case TargetTime.routeName:
        return _buildPageRoute(TargetTime(), settings);
      case FocusSession.routeName:
        return _buildPageRoute(FocusSession(), settings);
      case Notes.routeName:
        return _buildPageRoute(Notes(), settings);
      case Goals.routeName:
        return _buildPageRoute(Goals(), settings);
      case Procrastination.routeName:
        return _buildPageRoute(Procrastination(), settings);
      case ChangePasswordForm.routeName:
        return _buildPageRoute(ChangePasswordForm(), settings);
      case UpdateUserInfoScreen.routeName:
        return _buildPageRoute(UpdateUserInfoScreen(), settings);
      case About.routeName:
        return _buildPageRoute(About(), settings);
      default:
        return _buildPageRoute(Index(), settings);
    }
  }

  // Helper method to build the page with a custom route animation
  static PageRouteBuilder _buildPageRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      settings: settings,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
