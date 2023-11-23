import 'package:flutter/material.dart';
import 'package:ride_safe/services/models/menu_model.dart';


Widget menuItem(MenuItemType id, String title, IconData icon, bool isSelected,
    Function selectItem) {

  return Material(
    color: isSelected ? Colors.grey[800] : Colors.transparent,
    child: InkWell(
      onTap: () {selectItem(id);},
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              child: Icon(
                icon,
                size: 20,
                color: Colors.white,
              ),
            ),
            Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ))
          ],
        ),
      ),
    ),
  );
}
