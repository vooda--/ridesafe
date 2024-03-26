import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/services/constants.dart';
import 'package:ride_safe/services/helpers.dart';
import 'package:ride_safe/services/providers/ride_safe_provider.dart';

import '../../services/models/quiz.dart';
import '../bottom_menu/bottom_menu.dart';
import '../drawer/my_drawer.dart';
import '../futureImage.dart';

class QuizesPage extends StatefulWidget {
  const QuizesPage({super.key});

  @override
  State<QuizesPage> createState() => _QuizesPageState();
}

class _QuizesPageState extends State<QuizesPage> {
  @override
  void initState() {
    super.initState();
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
  late int selectedCategory;
  List<Quiz> listQuizz = List.empty(growable: true);

  Color getColor(int currentCategory) {
    // print('getColor');
    // print(currentCategory);
    // print(selectedCategory);
    if (selectedCategory == currentCategory) {
      return AppColors.primaryColor;
    }
    return Colors.white;
  }

  void updateQuizList(quizzes) {
    listQuizz.clear();
    listQuizz
        .addAll(quizzes.where((q) => q.quizCategory.id == selectedCategory));
  }

  @override
  void initState() {
    super.initState();
    var provider = Provider.of<RideSafeProvider>(context, listen: false);
    setState(() {
      selectedCategory = provider.quizCategories.first.id ?? 0;
      updateQuizList(provider.quizzes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RideSafeProvider>(
      builder: (context, rideSafeProvider, child) {
        final quizzes = rideSafeProvider.quizzes;

        return Container(
          color: AppColors.secondary1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  height: 45.0, //40 doesn't fit to android devices
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: rideSafeProvider.quizCategories.length,
                    itemBuilder: (context, index) {
                      final category = rideSafeProvider.quizCategories[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        height: 45,
                        child: OutlinedButton(
                          onPressed: () => {
                            print('Updating set'),
                            setState(() {
                                  selectedCategory = category.id;
                                  updateQuizList(quizzes);
                                  print(listQuizz.length);
                                  print(selectedCategory);
                                })
                          },
                          style: OutlinedButton.styleFrom(
                              // maximumSize: Size(100, 30),
                              minimumSize: const Size(100, 26),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (state) => (selectedCategory == category.id)
                                      ? createMaterialColor(
                                          AppColors.secondaryTextColor)
                                      : createMaterialColor(
                                          AppColors.primaryTextColor)),
                              side: BorderSide(
                                  color:
                                      createMaterialColor(Colors.transparent)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 12.0),
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Ubuntu',
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (state) => getColor(category.id))),
                          child: Text(category.title),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: listQuizz.length,
                      itemBuilder: (context, index) {
                        final quiz = listQuizz.elementAt(index);
                        print('Rendering list quiz: ${quiz} - ${index}');
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/quizes/quiz',
                                arguments: quiz);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
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
                                  child: CachedNetworkImage(
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    cacheKey: Helpers.getImageUrlById(
                                      quiz.image?.id ?? 0,
                                    ),
                                    imageUrl: Helpers.getImageUrlById(
                                      quiz.image?.id ?? 0,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Image(
                                      image: AssetImage(
                                          'assets/images/default.jpeg'),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    // child: FutureImage(id: int.parse(widget.question.imageId),
                                    //     width: double.infinity, fit: BoxFit.cover),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                          ),
                        );
                      }))
            ],
          ),
        );
      },
    );
  }
}
