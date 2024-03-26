import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/services/constants.dart';
import 'package:ride_safe/services/helpers.dart';
import 'package:ride_safe/services/providers/ride_safe_provider.dart';

import '../../services/models/article.dart';
import '../bottom_menu/bottom_menu.dart';
import '../drawer/my_drawer.dart';

class SchoolPage extends StatefulWidget {
  const SchoolPage({super.key});

  @override
  State<SchoolPage> createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  @override
  Widget build(BuildContext context) {
    var controller = ScrollController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: Text(
          'Ride Safe',
          style: AppTextStyles.headline5,
        ),
      ),
      body: Container(
        child: const Center(
          child: ArticleList(),
        ),
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: BottomNavigationMenu(
        controller: controller,
        onSearchClick: () => {},
        searchCallback: (String filter) => {
          Provider.of<RideSafeProvider>(context, listen: false)
              .filterArticles(filter)
        },
      ),
    );
  }
}

class ArticleList extends StatefulWidget {
  const ArticleList({super.key});

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  late int selectedCategory;
  List<Article> listArticle = List.empty(growable: true);

  void updateArticleList(articles) {
    listArticle.clear();
    listArticle.addAll(articles
        .where((Article a) => a.articleCategory.id == selectedCategory));
  }

  @override
  void initState() {
    super.initState();
    var provider = Provider.of<RideSafeProvider>(context, listen: false);
    setState(() {
      selectedCategory = provider.articleCategories.first.id ?? 0;
      updateArticleList(provider.articles);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RideSafeProvider>(
      builder: (context, rideSafeProvider, child) {
        final categories = rideSafeProvider.articleCategories;
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: rideSafeProvider.articleCategories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final articles = rideSafeProvider.articles
                .where((element) => element.articleCategory.id == category.id)
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () => {
                    print('Updating set'),
                    setState(() {
                      selectedCategory = category.id;
                      updateArticleList(articles);
                      print(articles.length);
                      print(selectedCategory);
                    })
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryTextColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 12.0),
                    textStyle: AppTextStyles.bodyNormalBold,
                  ),
                  child: Wrap(
                      spacing: 10,
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        Text(category.title, style: AppTextStyles.bodyNormalBold),
                        SvgPicture.asset('assets/icons/vector.svg',
                            fit: BoxFit.contain, height: 18, width: 18)
                      ]),
                ),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: articles.length,
                      // padding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/school/article',
                                arguments: article);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Stack(
                                // alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 183,
                                    width: 153,
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                          width: 153,
                                          height: 183,
                                          alignment: Alignment.center,
                                          fit: BoxFit.fill,
                                          cacheKey: Helpers.getImageUrlById(
                                            article.image?.id,
                                          ),
                                          imageUrl: Helpers.getImageUrlById(
                                            article.image?.id,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Image(
                                                image: AssetImage(
                                                    'assets/images/default.jpeg'),
                                                width: 153,
                                                height: 183,
                                                fit: BoxFit.cover,
                                              )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 153,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 0.5, sigmaY: 0.5),
                                        child: Container(
                                          color: Colors.black.withOpacity(0.25),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.bottomCenter,
                                      width: 153,
                                      padding: const EdgeInsets.all(5.0),
                                      child: AutoSizeText(
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        article.title,
                                        maxLines: 2,
                                        minFontSize: 8,
                                        maxFontSize: 12,
                                        style: AppTextStyles.articleName,
                                      )),
                                ]),
                          ),
                        );
                      }),
                ),
              ],
            );
            // return ExpansionTile(
            //   title: Text(category.title),
            //   subtitle: Text(category.description ?? ''),
            //   children: articles
            //       .map((article) => ListTile(
            //             onTap: () {
            //               Navigator.pushNamed(context, '/school/article',
            //                   arguments: article);
            //             },
            //             contentPadding: const EdgeInsets.all(5),
            //             leading: Image(
            //               image: AssetImage(
            //                   'assets/images/moto/landscape/${index + 1}.jpg'),
            //               width: 40,
            //             ),
            //             title: Text(
            //               article.title,
            //               style: const TextStyle(fontSize: 18),
            //             ),
            //             subtitle: Text(
            //               article.description ?? '',
            //               style: const TextStyle(fontSize: 14),
            //             ),
            //             trailing: const Icon(Icons.arrow_forward_ios),
            //           ))
            //       .toList(),
            // );
          },
        );
      },
    );
  }
}
