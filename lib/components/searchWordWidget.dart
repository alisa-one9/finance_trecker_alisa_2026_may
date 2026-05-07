import 'package:flutter/material.dart';

class SearchWordWidget extends StatelessWidget {
  final ValueChanged<String> onQueryChanged;
  const SearchWordWidget({super.key, required this.onQueryChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: onQueryChanged,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Поиск по комментарию...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
