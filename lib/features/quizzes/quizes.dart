import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/services/providers/ride_safe_provider.dart';

import '../bottom_menu/bottom_menu.dart';
import '../drawer/my_drawer.dart';

class QuizesPage extends StatefulWidget {
  const QuizesPage({super.key});

  @override
  State<QuizesPage> createState() => _QuizesPageState();
}

class _QuizesPageState extends State<QuizesPage> {
  @override
  void initState() {
    super.initState();
    // Provider.of<RideSafeProvider>(context, listen: false).fetchArticles();
    // Provider.of<RideSafeProvider>(context, listen: false)
    //     .fetchArticleCategories();
  }

  @override
  Widget build(BuildContext context) {
    var controller = ScrollController();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('Ride Safe quiz'),
        ),
        body: Container(
          child: const Center(
            child: QuizList(),
          ),
        ),
        drawer: const MyDrawer(),
        bottomNavigationBar: BottomNavigationMenu(controller: controller,
        onSearchClick: () => {

        },
        searchCallback: (String filter) => {
          Provider.of<RideSafeProvider>(context, listen: false).filterQuizes(filter)
        },),

    );
  }
}

class QuizList extends StatefulWidget {
  const QuizList({super.key});

  @override
  State<QuizList> createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RideSafeProvider>(
      builder: (context, rideSafeProvider, child) {
        final categories = rideSafeProvider.quizCategories;
        return ListView.builder(
          itemCount: rideSafeProvider.quizCategories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final quizes = rideSafeProvider.quizzes
                .where((element) => element.quizCategory.id == category.id)
                .toList();
            return ExpansionTile(
              title: Text(category.title),
              subtitle: Text(category.description ?? ''),
              children: quizes
                  .map((quiz) => ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/quizes/quiz',
                              arguments: quiz);
                        },
                        contentPadding: const EdgeInsets.all(5),
                        leading: Image(
                          image: AssetImage(
                              'assets/images/moto/landscape/${index + 1}.jpg'),
                          width: 40,
                        ),
                        title: Text(
                          quiz.title,
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          quiz.description ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ))
                  .toList(),
            );
          },
        );
      },
    );
  }
}
