import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.title,
    required this.values,
    required this.onChanged,
  });

  final String title;
  final List<String> values;
  final void Function(String?) onChanged;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? value;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      hint: Text(widget.title),
      selectedItemBuilder: (context) {
        return widget.values.map<Widget>((String item) {
          return Row(
            children: <Widget>[
              Text(item),
            ],
          );
        }).toList();
      },
      items: widget.values.map((String itemValue) {
        return DropdownMenuItem<String>(
          value: itemValue,
          child: Row(
            children: <Widget>[
              if (itemValue == value) const Icon(Icons.check),
              Text(itemValue),
            ],
          ),
        );
      }).toList(),
      onChanged: (String? itemValue) {
        setState(() {
          if (value == itemValue) {
            value = null;
          } else {
            value = itemValue;
          }

          widget.onChanged(value);
        });
      },
    );
  }
}
