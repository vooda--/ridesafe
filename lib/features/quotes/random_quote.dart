import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/features/quotes/quote.dart';

import '../../services/models/quote.dart';
import '../../services/providers/ride_safe_provider.dart';
import '../drawer/my_drawer.dart';

class RandomQuotePage extends StatefulWidget {

  @override
  State<RandomQuotePage> createState() => _RandomQuotePageState();
}

class _RandomQuotePageState extends State<RandomQuotePage> {
  late final Quote? _randomQuote;

  @override
  void initState() {
    _randomQuote =
        Provider.of<RideSafeProvider>(context, listen: false).randomQuote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Quotes'),
        ),
        body: Container(
          child: Center(
            child: SelectedQuote(_randomQuote!),
          ),
        ),
        drawer: MyDrawer());
  }
}
