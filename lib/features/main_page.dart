import 'package:flutter/material.dart';

import 'drawer/my_drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('Ride Safe'),
        ),
        body: Container(
          child: const Text('Main Page'),
        ),
        drawer: const MyDrawer());
  }
}
