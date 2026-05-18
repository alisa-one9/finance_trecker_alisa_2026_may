import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/dateInputFormatter.dart';

class SearchDateWidget extends StatefulWidget {
  final ValueChanged<DateTime?> onValueChanged;
  const SearchDateWidget({super.key, required this.onValueChanged});
  @override
  State<StatefulWidget> createState() => _SearchDateWidgetState();
}

class _SearchDateWidgetState extends State<SearchDateWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        if (_controller.text.length < 10) {
          widget.onValueChanged(null);
        }
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (value) {
                if (value.length == 10) {
                  try {
                    var parts = value.split('/');
                    var day = int.parse(parts[0]);
                    var month = int.parse(parts[1]);
                    var year = int.parse(parts[2]);
                    widget.onValueChanged(DateTime(year, month, day));
                  } catch (e) {
                    print("Error parsing date: $e");
                    widget.onValueChanged(null);
                  }
                } else {
                  widget.onValueChanged(null);
                }
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                DateInputFormatter(),
              ],
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "ДД/ММ/ГГГГ",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
