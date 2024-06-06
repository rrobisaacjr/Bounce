// package imports

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

// file imports
import 'firebase_options.dart';
import './providers/friend_provider.dart';
import './providers/auth_provider.dart';
import './providers/task_provider.dart';
import './screens/pages/login_page.dart';
import './screens/pages/dashboard_page.dart';
import './screens/pages/friends_page.dart';
import './screens/pages/profile_page.dart';
import './screens/pages/tasks_page.dart';
import './screens/pages/notifications_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => TaskProvider())),
        ChangeNotifierProvider(create: ((context) => FriendListProvider())),
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bounce',
      initialRoute: '/',
      routes: {'/': (context) => const AuthWrapper()},
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        fontFamily: GoogleFonts.robotoMono().fontFamily,
        primarySwatch:
            buildMaterialColor(const Color.fromARGB(255, 198, 255, 27)),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.user; // Access the user directly

    if (authProvider.isAuthenticated) {
      return DashboardPage(
        title: 'Bounce',
        user: currentUser,
      );
    } else {
      return const LoginPage();
    }
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    final currentUser = args as User?;

    switch (settings.name) {
      case '/dashboard':
        return MaterialPageRoute(
            builder: (context) =>
                DashboardPage(user: currentUser, title: 'BOUNCE'));
      case '/profile':
        return MaterialPageRoute(
            builder: (context) =>
                ProfilePage(user: currentUser, title: 'BOUNCE'));
      case '/friends':
        return MaterialPageRoute(
          builder: (context) => FriendPage(user: currentUser, title: 'BOUNCE'),
        );
      case '/tasks':
        return MaterialPageRoute(
          builder: (context) => TasksPage(user: currentUser, title: 'BOUNCE'),
        );
      case '/notifications':
        return MaterialPageRoute(
          builder: (context) =>
              NotificationsPage(user: currentUser, title: 'BOUNCE'),
        );
      default:
        return MaterialPageRoute(
            builder: (context) =>
                DashboardPage(user: currentUser, title: 'BOUNCE'));
    }
  }
}
