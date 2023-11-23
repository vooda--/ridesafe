import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as dart_ui;
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ride_safe/services/providers/screenshot_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/features/bottom_menu/bottom_menu.dart';

import '../../services/models/quote.dart';
import '../../services/providers/ride_safe_provider.dart';
import '../drawer/my_drawer.dart';

class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  Future<Uint8List>? _randomImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Quote quote = ModalRoute.of(context)!.settings.arguments as Quote;
    final ScrollController controller = ScrollController();
    if (quote.imageBytes == null) {
      _randomImage = Provider.of<RideSafeProvider>(context, listen: false)
          .randomImage(context);
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('Quotes'),
        ),
        body: Container(
          child: Center(
            child: SelectedQuote(quote, _randomImage),
          ),
        ),
        bottomNavigationBar: BottomNavigationMenu(
          controller: controller,
          onShareClick: () {
            log('Callback share ${quote.quoteText}');
            Provider.of<ScreenshotProvider>(context, listen: false)
                .shareQuoteScreenshot();
          },
          onSearchClick: () {
            log('Callback search ${quote.quoteText}');
          },
          searchCallback: (String filter) {
            log('Callback search $filter');
            Provider.of<RideSafeProvider>(context, listen: false)
                .filterQuotes(filter);
          },
          onAddToFavoriteClick: () {
            log('Callback add favorite ${quote.quoteText}');
            if (_randomImage != null) {
              Provider.of<RideSafeProvider>(context, listen: false)
                  .hiveService
                  .addFavoriteQuote(quote, _randomImage!);
            }
          },
        ),
        drawer: const MyDrawer());
  }
}

class SelectedQuote extends StatefulWidget {
  final Quote quote;
  late Future<Uint8List>? randomImage;

  SelectedQuote(this.quote, this.randomImage, {Key? key}) : super(key: key);

  @override
  State<SelectedQuote> createState() => _SelectedQuoteState();
}

class _SelectedQuoteState extends State<SelectedQuote> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quote.imageBytes != null) {
      return QuoteStack(widget.quote, widget.quote.imageBytes!);
    } else {
      return FutureImage(widget.randomImage!, widget.quote);
    }
  }
}

class FutureImage extends StatelessWidget {
  final Future<Uint8List> randomImage;
  final Quote quote;

  const FutureImage(this.randomImage, this.quote, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: randomImage,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is still running, you can show a loading indicator.
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there was an error, you can display an error message.
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // If the future completed successfully, display the loaded image.
          return QuoteStack(quote, snapshot.data!);
        } else {
          // Handle other cases as needed.
          return const Text('No data available.');
        }
      },
    );
  }
}

class QuoteStack extends StatelessWidget {
  final Quote quote;
  final Uint8List image;
  static GlobalKey screenshotKey = GlobalKey();

  const QuoteStack(this.quote, this.image, {super.key});

  void takeScreenshotAndShare() async {
    RenderRepaintBoundary boundary = screenshotKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    dart_ui.Image screenshot = await boundary.toImage(pixelRatio: 2.0);
    ByteData? byteData =
        await screenshot.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    // Get the directory for saving the image
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/screenshot.png';

    // Write the image data to a file
    File(imagePath).writeAsBytesSync(pngBytes);

    await Share.shareFiles([imagePath],
        text: quote.quoteText,
        subject: quote.author,
        mimeTypes: ['image/png'],
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 10, 10));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenshotProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        provider.addListener(() {
          takeScreenshotAndShare();
        });
        return RepaintBoundary(
          key: screenshotKey,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: Image(
                  image: Image.memory(image).image,
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
                    quote.quoteText,
                    maxLines: 5,
                    minFontSize: 18,
                    maxFontSize: 48,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
