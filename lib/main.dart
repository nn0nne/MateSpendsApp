import 'package:matespendsapp/pages/auth/signin_or_signup.dart';
import 'package:matespendsapp/pages/home_page.dart';
import 'package:matespendsapp/services/expense_provider.dart';
import 'package:matespendsapp/services/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthService(),
      ),
      ChangeNotifierProvider(
        create: (_) => ExpenseProvider(),
      ),
    ],
    child: const RestartWidget(child: MyApp()),
  ));
}

/// Widget to wrap the app and provide restart functionality
class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({super.key, required this.child});

  @override
  RestartWidgetState createState() => RestartWidgetState();

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<RestartWidgetState>()?.restartApp();
  }
}

class RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);

    return MaterialApp(
        title: 'Chor',
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: Color(0xFFFFFFFF));
            }

            final bool isAuthenticated = snapshot.hasData;

            if (!isAuthenticated) {
              return const SignInOrSignUp();
            }

            return const MainAppScaffold();
          },
        ));
  }
}

class MainAppScaffold extends StatefulWidget {
  const MainAppScaffold({super.key});

  @override
  _MainAppScaffoldState createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  Future<String> _getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          return userDoc['username'] ?? 'User';
        } else {
          return 'User';
        }
      } catch (e) {
        print('Error fetching username: $e');
        return 'User';
      }
    } else {
      return 'Guest';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: FutureBuilder<String>(
          future: _getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFFFFFF)));
            }

            if (snapshot.hasData) {
              return Drawer(
                backgroundColor: const Color(0xFF31AA68),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      height: 150,
                      child: DrawerHeader(
                        decoration: const BoxDecoration(
                          color: Color(0xFF31AA68),
                        ),
                        child: Text(
                          'Hello there, ${snapshot.data}',
                          style: const TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Logout',
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                      onTap: () {
                        Provider.of<AuthService>(context, listen: false)
                            .signOut(context);
                      },
                    ),
                  ],
                ),
              );
            }

            return Center(child: Text('Failed to load username'));
          },
        ),
        body: HomePage());
  }
}
