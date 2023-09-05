import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/models/quote.dart';
import '../../services/providers/quote_provider.dart';
import '../drawer/my_drawer.dart';

class QuotePage extends StatefulWidget {
  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  @override
  void initState() {
    super.initState();
    // Provider.of<QuoteProvider>(context, listen: false).fetchQuotes();
  }

  @override
  Widget build(BuildContext context) {
    final Quote quote = ModalRoute.of(context)!.settings.arguments as Quote;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Quotes'),
        ),
        body: Container(
          child: Center(
            child: SelectedQuote(quote),
          ),
        ),
        drawer: MyDrawer());
  }
}

class SelectedQuote extends StatefulWidget {
  final Quote quote;
  const SelectedQuote(this.quote, {Key? key}) : super(key: key);

  @override
  State<SelectedQuote> createState() => _SelectedQuoteState();
}
class _SelectedQuoteState extends State<SelectedQuote> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: Image(
            image: AssetImage(
                'assets/images/moto/landscape/${widget.quote.id}.jpg'),
            fit: BoxFit.contain,
            width: double.infinity,
            // height: double.infinity,
            alignment: Alignment.center,
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            textAlign: TextAlign.center,
            widget.quote.quoteText,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        // Text(
        //   widget.quote.author,
        //   style: const TextStyle(fontSize: 12),
        // ),
      ],
    );
  }
}