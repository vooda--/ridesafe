import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/services/constants.dart';
import 'package:ride_safe/services/models/article.dart';

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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          title: Text(
            article.title ?? 'Article',
            style: AppTextStyles.headline5,
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: SelectedArticle(article),
          ),
        ),
        drawer: const MyDrawer());
  }
}

class SelectedArticle extends StatefulWidget {
  final Article article;

  const SelectedArticle(this.article, {Key? key}) : super(key: key);

  @override
  State<SelectedArticle> createState() => _SelectedArticleState();
}

class _SelectedArticleState extends State<SelectedArticle> {
  late Future<Uint8List> image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var provider = Provider.of<RideSafeProvider>(context, listen: false);
    setState(() {
      image = widget.article.image != null
          ? provider.getImage(context, widget.article.image!.id)
          : provider.loadImageAsUint8List('assets/images/default.jpeg');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.article.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Category: ${widget.article.articleCategory.title}',
                // Replace with actual category
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              FutureImage(image,
                  width: double.infinity, height: 300, fit: BoxFit.cover),
              // Image.network(
              //   widget.article.image?.pathToFile ??
              //       'https://images.unsplash.com/photo-1593309404036-8e39088b6071?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1024&q=80',
              //   // Use the article's main image URL
              //   width: double.infinity, // Set the width as needed
              //   height: 300, // Set the height as needed
              //   fit: BoxFit.cover,
              // ),
              const SizedBox(height: 16),
              Text(
                'Author: ${widget.article.author}',
                // Replace with actual author
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              HtmlWidget(
                widget.article.content ?? '<div>No text yet...</div>',
                textStyle: const TextStyle(
                  fontSize: 16,
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
        ),
      ],
    );
  }
}
