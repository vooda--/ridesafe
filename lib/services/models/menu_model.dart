import 'package:flutter/cupertino.dart';

enum MenuItemType { dashboard, school, quotes, quizzes, about, home, favoriteQuotes }

class MenuModel {
  final String title;
  final IconData icon;
  final String route;
  final MenuItemType id;

  MenuModel({required this.id, required this.title, required this.icon, required this.route});

}