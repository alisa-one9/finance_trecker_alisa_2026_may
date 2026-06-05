import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final String categoryName;
  final double size;

  const CategoryIcon({
    super.key,
    required this.categoryName,
    this.size = 24.0, // Значение по умолчанию
  });

  @override
  Widget build(BuildContext context) {
    switch (categoryName) {
      case 'Food':
        return Icon(Icons.fastfood_outlined, color: Colors.red, size: size);
      case 'Transport':
        return Icon(
          Icons.emoji_transportation_outlined,
          color: Colors.red,
          size: size,
        );
      case 'Hobby/Fun':
        return Icon(Icons.sports_football_sharp, color: Colors.red, size: size);
      case 'Salary':
        return Icon(
          Icons.currency_bitcoin_sharp,
          color: Colors.green,
          size: size,
        );
      case 'Gift':
        return Icon(Icons.card_giftcard_sharp, color: Colors.green, size: size);
      case 'Bonus':
        return Icon(Icons.star, color: Colors.green, size: size);
      default:
        // Вместо пустого контейнера лучше возвращать иконку по умолчанию
        return Icon(Icons.help_outline, color: Colors.grey, size: size);
    }
  }
}
