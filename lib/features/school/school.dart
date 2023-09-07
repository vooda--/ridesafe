import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/services/providers/quote_provider.dart';

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
      builder: (context, quoteProvider, child) {
        return ListView.builder(
          itemCount: quoteProvider.articles.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/school/selected',
                    arguments: quoteProvider.articles[index]);
              },
              contentPadding: const EdgeInsets.all(5),
              leading: Image(
                image:
                    AssetImage('assets/images/moto/landscape/${index + 1}.jpg'),
                width: 40,
              ),
              title: Text(
                quoteProvider.articles[index].title,
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                quoteProvider.articles[index].description??'',
                style: TextStyle(fontSize: 14),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            );
          },
        );
      },
    );
  }
}

