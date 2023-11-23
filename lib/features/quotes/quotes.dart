import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttericon/font_awesome_icons.dart';

import '../../services/helpers.dart';
import '../../services/providers/ride_safe_provider.dart';
import '../bottom_menu/bottom_menu.dart';
import '../drawer/my_drawer.dart';

enum QuoteType { all, favorite }

class QuotesPage extends StatefulWidget {
  final QuoteType quoteType;
  const QuotesPage({super.key, required this.quoteType});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.quoteType == QuoteType.all
        ? 'All Quotes'
        : 'Favorite Quotes';
    ScrollController controller = ScrollController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(title),
      ),
      body: Center(
        child: QuoteList(quoteType: widget.quoteType),
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: BottomNavigationMenu(controller: controller,),
    );
  }
}

class QuoteList extends StatefulWidget {
  final QuoteType quoteType;
  const QuoteList({super.key, required this.quoteType});

  @override
  State<QuoteList> createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {

  @override
  Widget build(BuildContext context) {
    return Consumer<RideSafeProvider>(
      builder: (context, quoteProvider, child) {
        final quotes = widget.quoteType == QuoteType.all ? quoteProvider.quotes : quoteProvider.favoriteQuotes;
        return ListView.builder(
          itemCount: quotes.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/quote/selected',
                    arguments: quotes[index]);
              },
              contentPadding: const EdgeInsets.all(5),
              leading: Image(
                image:
                    AssetImage('assets/images/moto/landscape/${index + 1}.jpg'),
                width: 40,
              ),
              trailing: const Icon(FontAwesome.heart, size: 20),
              title: Text(Helpers.trimString(
                  quotes[index].quoteText, 80)),
              // subtitle: Text(quoteProvider.quotes[index].author),
            );
          },
        );
      },
    );
  }
}
