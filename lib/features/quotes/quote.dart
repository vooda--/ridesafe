import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/features/bottom_menu/bottom_menu.dart';

import '../../services/models/quote.dart';
import '../../services/providers/ride_safe_provider.dart';
import '../drawer/my_drawer.dart';

class QuotePage extends StatefulWidget {
  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Quote quote = ModalRoute.of(context)!.settings.arguments as Quote;
    final ScrollController controller = ScrollController();
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
        bottomNavigationBar: BottomNavigationMenu(controller: controller,),
        drawer: MyDrawer());
  }
}

class SelectedQuote extends StatefulWidget {
  final Quote quote;

  SelectedQuote(this.quote, {Key? key}) : super(key: key);

  @override
  State<SelectedQuote> createState() => _SelectedQuoteState();
}

class _SelectedQuoteState extends State<SelectedQuote> {
  late Future<Image> _randomImage;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    _randomImage = Provider.of<RideSafeProvider>(context, listen: false)
        .randomImage(context);
    return FutureBuilder<Image>(
      future: _randomImage,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is still running, you can show a loading indicator.
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there was an error, you can display an error message.
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // If the future completed successfully, display the loaded image.
          return Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: Image(
                  image: snapshot.data!.image,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AutoSizeText(
                    textAlign: TextAlign.center,
                    widget.quote.quoteText,
                    maxLines: 5,
                    minFontSize: 18,
                    maxFontSize: 48,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
              ),
            ],
          );
        } else {
          // Handle other cases as needed.
          return Text('No data available.');
        }
      },
    );
  }
}
