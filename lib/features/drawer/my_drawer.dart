import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/features/main_page.dart';
import 'package:ride_safe/features/quizzes/quiz.dart';
import 'package:ride_safe/features/quotes/quote.dart';
import 'package:ride_safe/services/models/menu_model.dart';

import '../../services/models/app_state_model.dart';
import '../school/school.dart';
import 'menu_item.dart';
import 'my_header_drawer.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late MenuModel currentSelectedMenuItem;

  @override
  void initState() {
    AppStateModel appStateModel =
        Provider.of<AppStateModel>(context, listen: false);
    currentSelectedMenuItem = appStateModel.selectedMenuItem;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [MyHeaderDrawer(), MyDrawerList()],
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(
              MenuItemType.dashboard,
              'Dashboard',
              Icons.dashboard_outlined,
              currentSelectedMenuItem.id == MenuItemType.dashboard,
              selectMenuItem),
          Divider(),
          menuItem(
              MenuItemType.school,
              'School',
              Icons.school_outlined,
              currentSelectedMenuItem.id == MenuItemType.school,
              selectMenuItem),
          menuItem(
              MenuItemType.quizzes,
              'Quizzes',
              Icons.quiz_outlined,
              currentSelectedMenuItem.id == MenuItemType.quizzes,
              selectMenuItem),
          Divider(),
          menuItem(
              MenuItemType.quotes,
              'Quotes',
              Icons.format_quote_outlined,
              currentSelectedMenuItem.id == MenuItemType.quotes,
              selectMenuItem),
          Divider(),
          menuItem(MenuItemType.about, 'About', Icons.question_mark_outlined,
              currentSelectedMenuItem.id == MenuItemType.about, selectMenuItem),
        ],
      ),
    );
  }

  selectMenuItem(MenuItemType id) {
    // Navigator.pop(context);
    print('Selected item: ' + id.toString());
    print('Curr sel: ' + currentSelectedMenuItem.id.toString());
    StatefulWidget nextPage = MainPage();

    switch (id) {
      case MenuItemType.dashboard:
        nextPage = MainPage();
        break;
      case MenuItemType.school:
        nextPage = SchoolPage();
        break;
      case MenuItemType.quotes:
        nextPage = QuotePage();
        break;
      case MenuItemType.quizzes:
        nextPage = QuizPage();
        break;
    }
    Navigator.of(context).push(_createRoute(nextPage));
    context.read<AppStateModel>().setSelectedMenuItem(id);
  }
}

Route _createRoute(StatefulWidget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(-1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
