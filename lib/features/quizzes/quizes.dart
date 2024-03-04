import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/services/constants.dart';
import 'package:ride_safe/services/helpers.dart';
import 'package:ride_safe/services/providers/ride_safe_provider.dart';

import '../../services/models/quiz.dart';
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
        backgroundColor: AppColors.secondary1,
        title: Text(
          'Let\'s play',
          style: AppTextStyles.headline5,
        ),
      ),
      body: Container(
        child: const Center(
          child: QuizList(),
        ),
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: BottomNavigationMenu(
        controller: controller,
        onSearchClick: () => {},
        searchCallback: (String filter) => {
          Provider.of<RideSafeProvider>(context, listen: false)
              .filterQuizes(filter)
        },
      ),
    );
  }
}

class QuizList extends StatefulWidget {
  const QuizList({super.key});

  @override
  State<QuizList> createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  int selectedCategory = 0;
  List<Quiz> listQuizz = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Consumer<RideSafeProvider>(
      builder: (context, rideSafeProvider, child) {
        final categories = rideSafeProvider.quizCategories;
        final quizzes = rideSafeProvider.quizzes;
        selectedCategory = categories[0].id;
        print('Quizzes length  ${quizzes.length}');

        return Container(
          color: AppColors.secondary1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  height: 40.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: rideSafeProvider.quizCategories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () => {
                            print('Updating set'),
                            setState(() => {
                                  selectedCategory = category.id,
                                  listQuizz.clear(),
                                  listQuizz.addAll(quizzes.where((q) =>
                                      q.quizCategory.id == selectedCategory))
                                }),
                            print(listQuizz.length),
                          },
                          style: OutlinedButton.styleFrom(
                            // maximumSize: Size(100, 30),
                            minimumSize: const Size(100, 24),
                            foregroundColor: MaterialStateColor.resolveWith(
                                (state) => (selectedCategory == category.id)
                                    ? createMaterialColor(
                                        AppColors.secondaryTextColor)
                                    : createMaterialColor(
                                        AppColors.primaryTextColor)),
                            side: BorderSide(
                                color: createMaterialColor(Colors.transparent)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 12.0),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Ubuntu',
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            backgroundColor: selectedCategory == category.id
                                ? createMaterialColor(AppColors.primaryColor)
                                : createMaterialColor(Colors.white),
                          ),
                          child: Text(category.title),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: listQuizz.length,
                      itemBuilder: (context, index) {
                        final quiz = listQuizz.elementAt(index);
                        print('Rendering list quiz: ${quiz} - ${index}');
                        return Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          margin: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/moto/landscape/${quiz.id}.jpg'),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      quiz.title,
                                      style: AppTextStyles.hairlineLarge,
                                    ),
                                    Text(
                                      quiz.description ?? 'description',
                                      style: AppTextStyles.captions,
                                    ),
                                    Text(quiz.tags ?? 'tags')
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                        // return ListTile(
                        //   onTap: () {
                        //     Navigator.pushNamed(context, '/quizes/quiz',
                        //         arguments: quiz);
                        //   },
                        //   contentPadding: const EdgeInsets.all(5),
                        //   leading: Image(
                        //     image: AssetImage(
                        //         'assets/images/moto/landscape/${quiz.id}.jpg'),
                        //     width: 40,
                        //   ),
                        //   title: Text(
                        //     quiz.title,
                        //     style: const TextStyle(fontSize: 18),
                        //   ),
                        //   subtitle: Text(
                        //     quiz.description ?? '',
                        //     style: const TextStyle(fontSize: 14),
                        //   ),
                        //   trailing: const Icon(Icons.arrow_forward_ios),
                        // );
                      }))
            ],
          ),
        );
      },
    );
  }
}
