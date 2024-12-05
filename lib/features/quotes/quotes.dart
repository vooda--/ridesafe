import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:ride_safe/services/constants.dart';
import 'package:ride_safe/services/providers/prefetched_images_provider.dart';

import '../../services/helpers.dart';
import '../../services/providers/ride_safe_provider.dart';
import '../bottom_menu/bottom_menu_quotes.dart';
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
    final String title =
        widget.quoteType == QuoteType.all ? 'All Quotes' : 'Favorite Quotes';
    ScrollController controller = ScrollController();
    // ScrollController bodyScrollController = ScrollController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          title: Text(
            title,
            style: AppTextStyles.headline5(),
          ),
        ),
        body: Center(
          child: QuoteList(quoteType: widget.quoteType),
        ),
        drawer: const MyDrawer(),
        // bottomNavigationBar: BottomNavigationMenu(
        //   controller: controller,
        // ),
      ),
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
  late final ScrollController _bodyScrollController;
  late final PrefetchedImagesProvider provider;
  late final RideSafeProvider rideSafeProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    double currentScrollWhenFetched = 0;
    rideSafeProvider = Provider.of<RideSafeProvider>(context, listen: false);
    provider = Provider.of<PrefetchedImagesProvider>(context, listen: false);
    fetchImages();
    _bodyScrollController = ScrollController();
    _bodyScrollController.addListener(() {
      // final maxScroll = _bodyScrollController.position.maxScrollExtent;
      final currentScroll = _bodyScrollController.position.pixels;
      if (currentScroll >
          currentScrollWhenFetched +
              _bodyScrollController.position.viewportDimension * 0.9) {
        if (kDebugMode) {
          print("$currentScroll - $currentScrollWhenFetched");
          print("fetching!");
        }
        currentScrollWhenFetched = currentScroll;
        fetchImages();
      }
    });
  }

  void fetchImages() async {
    var images = await provider.randomImages(context, 20);
    rideSafeProvider.addImagesToQuoteList(images);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RideSafeProvider>(
      builder: (context, quoteProvider, child) {
        final quotes = widget.quoteType == QuoteType.all
            ? quoteProvider.quotes
            : quoteProvider.favoriteQuotes;
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8),
          controller: _bodyScrollController,
          itemCount: quotes.length,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, index) {
            var quote = quotes.elementAt(index);

            return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/quote/selected',
                      arguments: quotes.elementAt(index));
                },
                child: Container(
                  height: (index % 2 == 0) ? 200 : 150,
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  // margin: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Container(
                          // width: 170,
                          alignment: Alignment.center,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: quote.imageBytes == null
                                  ? const Image(
                                      image: AssetImage(
                                          'assets/images/default.png'),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      // width: 170,
                                    )
                                  : Image.memory(
                                      quote.imageBytes!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,

                                      // width: 170,
                                    )
                              // Image(
                              //   image: Image.memory(image).image,
                              //   fit: BoxFit.cover,
                              //   width: double.infinity,
                              //   alignment: Alignment.center,
                              // ),
                              )),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                            child: Container(
                              color: Colors.black.withOpacity(0.25),
                            ),
                          )),
                      Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: AutoSizeText(
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            quote.quoteText,
                            maxLines: 3,
                            minFontSize: 12,
                            maxFontSize: 16,
                            style: AppTextStyles.articleName,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.stretch,
                  //   children: [
                  //     Container(
                  //         alignment: Alignment.centerLeft,
                  //         child: quote.imageBytes == null
                  //             ? const Image(
                  //                 image: AssetImage('assets/images/default.jpeg'),
                  //                 fit: BoxFit.fill,
                  //                 width: 170,
                  //               )
                  //             : Image.memory(
                  //                 quote.imageBytes!,
                  //                 fit: BoxFit.fill,
                  //                 width: 170,
                  //               )
                  //         ),
                  //     Padding(
                  //       padding: const EdgeInsets.all(16.0),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           Text(
                  //               style: AppTextStyles.hairlineLarge,
                  //               Helpers.trimString(quote.quoteText, 80))
                  //         ],
                  //       ),
                ));
          },
        );
      },
    );
  }
}
