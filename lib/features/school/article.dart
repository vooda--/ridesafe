import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/services/constants.dart';
import 'package:ride_safe/services/models/article.dart';

import '../../services/helpers.dart';
import '../../services/providers/ride_safe_provider.dart';
import '../drawer/my_drawer.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../futureImage.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var article = ModalRoute.of(context)!.settings.arguments as Article;
    print('selected article: $article');
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          // appBar: AppBar(
          //   backgroundColor: AppColors.whiteColor,
          //   title: Text(
          //     article.title ?? 'Article',
          //     style: AppTextStyles.headline5(),
          //   ),
          // ),
          body: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: SelectedArticle(article),
              ),
            ),
          ),
          drawer: const SafeArea(child: MyDrawer())),
    );
  }
}

class SelectedArticle extends StatefulWidget {
  final Article article;

  const SelectedArticle(this.article);

  @override
  State<SelectedArticle> createState() => _SelectedArticleState();
}

class _SelectedArticleState extends State<SelectedArticle> {
  // late Future<Uint8List> image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // var provider = Provider.of<RideSafeProvider>(context, listen: false);
    // setState(() {
    //   image = widget.article.image != null
    //       ? provider.getImage(context, widget.article.image!.id)
    //       : provider.loadImageAsUint8List('assets/images/default.jpeg');
    // });
  }

  @override
  Widget build(BuildContext context) {
    final author = widget.article.author!.isEmpty ? 'Vooda' : widget.article.author!;
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // height: 300,
                      cacheKey: Helpers.getImageUrlById(
                        widget.article.image?.id,
                      ),
                      imageUrl: Helpers.getImageUrlById(
                        widget.article.image?.id,
                      ),
                      errorWidget: (context, url, error) => const Image(
                        image: AssetImage('assets/images/default.png'),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                  child: Container(
                    color: Colors.black.withOpacity(0.25),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            widget.article.title,
                            style: AppTextStyles.headline5(color: AppColors.neutrals8)
                          ),
                        Text(
                            author,
                          style: AppTextStyles.captions
                        ),
                        // Text(
                        //     widget.article.articleCategory.title ?? 'Category',
                        //     style: AppTextStyles.captions
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HtmlWidget(
                widget.article.content ?? '<div>No text yet...</div>',
                textStyle: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            // Text(
            //   widget.article.content ?? 'No text yet...',
            //   // Replace with actual article content
            //   style: const TextStyle(
            //     fontSize: 16,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
