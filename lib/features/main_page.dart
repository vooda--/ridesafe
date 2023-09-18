import 'package:flutter/material.dart';

import '../services/models/app_state_model.dart';
import 'drawer/my_drawer.dart';
import 'home/home_page.dart';

class MainPage extends StatefulWidget {
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
        drawer: MyDrawer());
  }
}
