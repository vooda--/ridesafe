import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/features/main_page.dart';
import 'package:ride_safe/features/quotes/quotes.dart';
import 'package:ride_safe/features/quotes/random_quote.dart';
import 'package:ride_safe/services/constants.dart';
import 'package:ride_safe/services/models/menu_model.dart';

import '../../services/models/app_state_model.dart';
import '../quizzes/quizes.dart';
import '../school/articles.dart';
import 'menu_item.dart';
import 'my_header_drawer.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

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
      width: 358.0,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const MyHeaderDrawer(),
          Expanded(child: MyDrawerList()),
          const Text(
            'Developed by VoodaLab LLC. Copyright 2024',
            style: TextStyle(
                color: AppColors.neutrals5,
                fontWeight: FontWeight.normal,
                fontSize: 12),
          )
        ],
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          menuItem(
              MenuItemType.dashboard,
              'Random Quote',
              SvgPicture.asset('assets/icons/random.svg',
                  height: 20, width: 20, semanticsLabel: 'Random Quote'),
              currentSelectedMenuItem.id == MenuItemType.dashboard,
              selectMenuItem),
          // const Divider(),
          menuItem(
              MenuItemType.school,
              'School',
              SvgPicture.asset('assets/icons/school.svg',
                  height: 20, width: 20, semanticsLabel: 'School'),
              currentSelectedMenuItem.id == MenuItemType.school,
              selectMenuItem),
          menuItem(
              MenuItemType.quizzes,
              'Quizzes',
              SvgPicture.asset('assets/icons/quizzes.svg',
                  height: 20, width: 20, semanticsLabel: 'Quizzes'),
              currentSelectedMenuItem.id == MenuItemType.quizzes,
              selectMenuItem),
          // const Divider(),
          menuItem(
              MenuItemType.quotes,
              'Quotes',
              SvgPicture.asset('assets/icons/quotes.svg',
                  height: 20, width: 20, semanticsLabel: 'Quotes'),
              currentSelectedMenuItem.id == MenuItemType.quotes,
              selectMenuItem),
          menuItem(
              MenuItemType.favoriteQuotes,
              'Favorite Quotes',
              SvgPicture.asset('assets/icons/favorite.svg',
                  height: 20, width: 20, semanticsLabel: 'Favorite'),
              currentSelectedMenuItem.id == MenuItemType.favoriteQuotes,
              selectMenuItem),
          menuItem(
              MenuItemType.subscription,
              'My Subscription',
              SvgPicture.asset('assets/icons/subscription.svg',
                  height: 20, width: 20, semanticsLabel: 'Subscription'),
              currentSelectedMenuItem.id == MenuItemType.subscription,
              selectMenuItem),
          // const Divider(),
          menuItem(
              MenuItemType.about,
              'About',
              SvgPicture.asset('assets/icons/about.svg',
                  height: 20, width: 20, semanticsLabel: 'Random Quote'),
              currentSelectedMenuItem.id == MenuItemType.about,
              selectMenuItem),
        ],
      ),
    );
  }

  selectMenuItem(MenuItemType id) {
    // Navigator.pop(context);
    print('Selected item: $id');
    print('Curr sel: ${currentSelectedMenuItem.id}');
    StatefulWidget nextPage = const MainPage();

    switch (id) {
      case MenuItemType.dashboard:
        nextPage = const RandomQuotePage();
        break;
      case MenuItemType.school:
        nextPage = const SchoolPage();
        break;
      case MenuItemType.quotes:
        nextPage = const QuotesPage(quoteType: QuoteType.all);
        break;
      case MenuItemType.favoriteQuotes:
        nextPage = const QuotesPage(quoteType: QuoteType.favorite);
        break;
      case MenuItemType.quizzes:
        nextPage = const QuizesPage();
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
