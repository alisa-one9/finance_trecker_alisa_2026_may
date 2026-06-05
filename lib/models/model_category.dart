import 'package:flutter/material.dart';

class Model_category {
  String name;
  Icon icon;
  bool isSelected;
  Color color;

  Model_category({
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.color,
  });
  static List<Model_category> getRedCategories() {
    List<Model_category> redCategories = [];
    redCategories.add(
      Model_category(
        name: 'Food',
        icon: (const Icon(Icons.fastfood_outlined, color: Colors.black)),
        color: Colors.red,
        isSelected: false,
      ),
    );
    redCategories.add(
      Model_category(
        name: 'Transport',
        icon: (const Icon(
          Icons.emoji_transportation_outlined,
          color: Colors.black,
        )),
        isSelected: false,
        color: Colors.red,
      ),
    );
    redCategories.add(
      Model_category(
        name: 'Hobby/Fun',
        icon: (const Icon(Icons.sports_football_sharp, color: Colors.black)),
        isSelected: false,
        color: Colors.red,
      ),
    );

    return redCategories;
  }

  static List<Model_category> getGreenCategories() {
    List<Model_category> greenCategories = [];
    greenCategories.add(
      Model_category(
        name: 'Salary',
        icon: (const Icon(Icons.currency_bitcoin_sharp, color: Colors.black)),
        color: Colors.green,
        isSelected: false,
      ),
    );
    greenCategories.add(
      Model_category(
        name: 'Gift',
        icon: (const Icon(Icons.card_giftcard_sharp, color: Colors.black)),
        isSelected: false,
        color: Colors.green,
      ),
    );
    greenCategories.add(
      Model_category(
        name: 'Bonus',
        icon: (const Icon(Icons.star, color: Colors.black)),
        isSelected: false,
        color: Colors.green,
      ),
    );
    return greenCategories;
  }
}
