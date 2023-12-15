import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({
    required this.child,
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If the user is logged in.
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: const Color(0xfff9f9f9),
              body: SafeArea(
                child: widget.child,
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: _currentIndex,
                onTap:
                  (int index) {
                    setState(() {
                      _currentIndex = index;
                      if (index == 0) {
                        context.push("/home");
                      } else if (index == 1) {
                        context.push("/profile");
                      } else if (index == 2) {
                        context.push("/settings");
                      }
                    });
                  },
                items: const [
                  BottomNavigationBarItem(
                    label: '',
                    icon: Icon(Icons.home),
                  ),
                  BottomNavigationBarItem(
                    label: '',
                    icon: Icon(Icons.person),
                  ),
                  BottomNavigationBarItem(
                    label: '',
                    icon: Icon(Icons.settings),
                  ),
                ],
              ),
            );
          }
          // If the user is not logged in.
          else {
            _currentIndex = 0;
            return Scaffold(
              body: SafeArea(
                child: widget.child,
              ),
            );
          }
        }
      ),
    );
  }
}
