import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/features/quotes/quote.dart';
import 'package:ride_safe/services/constants.dart';

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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          title: Text('Quotes', style: AppTextStyles.headline5),
        ),
        body: Container(
          child: Center(
            child: SelectedQuote(_randomQuote!, image),
          ),
        ),
        drawer: const SafeArea(child: MyDrawer()));
  }
}
