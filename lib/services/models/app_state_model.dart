import 'package:flutter/material.dart';
import 'package:ride_safe/services/models/menu_model.dart';

class AppStateModel with ChangeNotifier {

  List<MenuModel> navigationMenuItems = [
    MenuModel(id: MenuItemType.home, title: 'Home', icon: Icons.home, route: '/'),
    MenuModel(id: MenuItemType.school, title: 'School', icon: Icons.school, route: '/school'),
    MenuModel(id: MenuItemType.quizzes, title: 'Quizzes', icon: Icons.quiz, route: '/quiz'),
    MenuModel(id: MenuItemType.quotes, title: 'Quotes', icon: Icons.format_quote, route: '/quote'),
    MenuModel(id: MenuItemType.quotes, title: 'Favorite Quotes', icon: Icons.favorite_rounded, route: '/favorites'),
    MenuModel(id: MenuItemType.about, title: 'About', icon: Icons.info, route: '/about'),
  ];

  MenuModel _selectedMenuItem = MenuModel(id: MenuItemType.home, title: 'Home', icon: Icons.home, route: '/');

  MenuModel get selectedMenuItem => _selectedMenuItem;
  void setSelectedMenuItem(MenuItemType type) {
    _selectedMenuItem = navigationMenuItems.firstWhere((element) => element.id == type);
    notifyListeners();
  }

}