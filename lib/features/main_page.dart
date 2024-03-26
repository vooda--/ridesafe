import 'package:flutter/material.dart';
import 'package:ride_safe/services/constants.dart';

import 'drawer/my_drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          title: Text('Ride Safe', style: AppTextStyles.headline5,),
        ),
        body: Container(
          child: const Text('Main Page'),
        ),
        drawer: const SafeArea(child: MyDrawer()));
  }
}
