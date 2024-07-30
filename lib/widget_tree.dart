import 'auth_gate.dart';
import 'home_screen.dart';
import 'login_register_page.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthGate().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MyHomePage(title: '13.Run');
          } else {
            return const LoginPage();
          }
        });
  }
}