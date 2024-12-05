import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/features/bottom_menu/bottom_menu_quotes.dart';
import 'package:ride_safe/features/quotes/quote.dart';
import 'package:ride_safe/services/constants.dart';
import 'package:ride_safe/services/providers/download_provider.dart';
import 'package:ride_safe/services/providers/screenshot_provider.dart';

import '../../services/models/quote.dart';
import '../../services/providers/ride_safe_provider.dart';
import '../drawer/my_drawer.dart';

class RandomQuotePage extends StatefulWidget {
  const RandomQuotePage({super.key});

  @override
  State<RandomQuotePage> createState() => _RandomQuotePageState();
}

class _RandomQuotePageState extends State<RandomQuotePage> {
  late final Quote? _randomQuote;
  late Future<Uint8List> image;
  var controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    var provider = Provider.of<RideSafeProvider>(context, listen: false);
    _randomQuote = provider.randomQuote();
    image = provider.randomImage(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            title: Text('Quotes', style: AppTextStyles.headline5()),
          ),
          body: Container(
            child: Center(
              child: SelectedQuote(_randomQuote!, image),
            ),
          ),
          drawer: const SafeArea(child: MyDrawer()),
        bottomNavigationBar: BottomNavigationMenu(
            controller: controller,
            onShareClick: () {
              log('Callback share ${_randomQuote?.quoteText}');
              Provider.of<ScreenshotProvider>(context, listen: false)
                  .shareQuoteScreenshot();
            },
            onSearchClick: () {
              log('Callback search ${_randomQuote?.quoteText}');
            },
            onDownloadClick: () {
              log('Download click ${_randomQuote?.quoteText}');
              Provider.of<DownloadProvider>(context, listen: false)
                  .downloadQuote();
            },
            searchCallback: (String filter) {
              log('Callback search $filter');
              Provider.of<RideSafeProvider>(context, listen: false)
                  .filterQuotes(filter);
            },
            onAddToFavoriteClick: () {
              log('Callback add favorite ${_randomQuote?.quoteText}');
              // if (_randomImage != null) {
              //   Provider.of<RideSafeProvider>(context, listen: false)
              //       .hiveService
              //       .addFavoriteQuote(quote);
              // } else {
              Provider.of<RideSafeProvider>(context, listen: false)
                  .hiveService
                  .setFavorite(_randomQuote!);
            }
        ),
      ),
    );
  }
}
