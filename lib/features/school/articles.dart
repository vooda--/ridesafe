import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/services/providers/ride_safe_provider.dart';

import '../drawer/my_drawer.dart';

class SchoolPage extends StatefulWidget {
  @override
  State<SchoolPage> createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<RideSafeProvider>(context, listen: false).fetchArticles();
    Provider.of<RideSafeProvider>(context, listen: false)
        .fetchArticleCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Ride Safe'),
        ),
        body: Container(
          child: Center(
            child: ArticleList(),
          ),
        ),
        drawer: MyDrawer());
  }
}

class ArticleList extends StatefulWidget {
  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RideSafeProvider>(
      builder: (context, rideSafeProvider, child) {
        final categories = rideSafeProvider.articleCategories;
        return ListView.builder(
          itemCount: rideSafeProvider.articleCategories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final articles = rideSafeProvider.articles
                .where((element) => element.articleCategory.id == category.id)
                .toList();
            return ExpansionTile(
              title: Text(category.title),
              subtitle: Text(category.description ?? ''),
              children: articles
                  .map((article) => ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/school/article',
                              arguments: article);
                        },
                        contentPadding: const EdgeInsets.all(5),
                        leading: Image(
                          image: AssetImage(
                              'assets/images/moto/landscape/${index + 1}.jpg'),
                          width: 40,
                        ),
                        title: Text(
                          article.title,
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          article.description ?? '',
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ))
                  .toList(),
            );
          },
        );
      },
    );
  }
}
