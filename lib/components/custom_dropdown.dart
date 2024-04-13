import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({super.key, required this.title, required this.list, required this.onChanged});
  final String title;
  final List<String> list;
  final void Function(String?) onChanged;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      hint: Text(widget.title),
      selectedItemBuilder: (context) {
        return widget.list.map<Widget>((String item) {
          return Row(
            children: <Widget>[
              Text(item),
            ],
          );
        }).toList();
      },
      items: widget.list.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: <Widget>[
              if (dropdownValue == value) const Icon(Icons.check),
              Text(value),
            ],
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          if (dropdownValue == value) {
            dropdownValue = null;
          } else {
            dropdownValue = value!;
          }
          widget.onChanged(value);
        });
      },
    );
  }
}
