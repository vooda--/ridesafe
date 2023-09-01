import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/services/providers/quote_provider.dart';

import '../drawer/my_drawer.dart';

class SchoolPage extends StatefulWidget {
  @override
  State<SchoolPage> createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<QuoteProvider>(context, listen: false).fetchQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Ride Safe'),
        ),
        body: Container(
          child: Center(
            child: QuoteList(),
          ),
        ),
        drawer: MyDrawer());
  }
}

class QuoteList extends StatefulWidget {
  @override
  State<QuoteList> createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuoteProvider>(
      builder: (context, quoteProvider, child) {
        return ListView.builder(
          itemCount: quoteProvider.quotes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(quoteProvider.quotes[index].quoteText),
            );
          },
        );
      },
    );
  }
}
