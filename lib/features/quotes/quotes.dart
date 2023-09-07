import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttericon/font_awesome_icons.dart';

import '../../services/helpers.dart';
import '../../services/providers/quote_provider.dart';
import '../drawer/my_drawer.dart';

class QuotesPage extends StatefulWidget {
  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<RideSafeProvider>(context, listen: false).fetchQuotes();
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
    return Consumer<RideSafeProvider>(
      builder: (context, quoteProvider, child) {
        return ListView.builder(
          itemCount: quoteProvider.quotes.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/quote/selected',
                    arguments: quoteProvider.quotes[index]);
              },
              contentPadding: const EdgeInsets.all(5),
              leading: Image(
                image:
                    AssetImage('assets/images/moto/landscape/${index + 1}.jpg'),
                width: 40,
              ),
              trailing: const Icon(FontAwesome.heart, size: 20),
              title: Text(Helpers.trimString(
                  quoteProvider.quotes[index].quoteText, 80)),
              // subtitle: Text(quoteProvider.quotes[index].author),
            );
          },
        );
      },
    );
  }
}
