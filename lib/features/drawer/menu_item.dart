import 'package:flutter/material.dart';
import 'package:ride_safe/services/models/menu_model.dart';

import '../../services/constants.dart';


Widget menuItem(MenuItemType id, String title, Widget icon, bool isSelected,
    Function selectItem) {

  return Material(
    color: isSelected ? Colors.grey[800] : Colors.transparent,
    child: InkWell(
      onTap: () {selectItem(id);},
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10, right: 12),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: icon,
              ),
            ),
            Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(color: AppColors.grayTextColor, fontFamily: 'Ubuntu', fontWeight: FontWeight.w700, fontSize: 16),
                ))
          ],
        ),
      ),
    ),
  );
}
