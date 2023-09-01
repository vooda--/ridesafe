import 'package:flutter/material.dart';

import '../drawer/my_drawer.dart';

class QuotePage extends StatefulWidget {
  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Ride Safe'),
        ),
        body: Container(
          child: Center(
            child: Text('Quote Page'),
          ),
        ),
        drawer: MyDrawer());
  }
}

