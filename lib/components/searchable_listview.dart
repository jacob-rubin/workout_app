import 'package:flutter/material.dart';
import 'package:workout_app/components/custom_dropdown.dart';

class SearchableListView<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item) listTile;
  final Map<String, List<String>> dropdowns;

  const SearchableListView({super.key, required this.items, required this.listTile, required this.dropdowns});

  @override
  State<SearchableListView> createState() => _SearchableListViewState<T>();
}

class _SearchableListViewState<T> extends State<SearchableListView<T>> {
  late List<T> items;
  late List<T> filteredItems;
  late Widget Function(T item) listTile;
  late Map<String, List<String>> dropdowns;

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    items = widget.items;
    filteredItems = List<T>.from(items);
    listTile = widget.listTile;
    dropdowns = widget.dropdowns;

    textController.addListener(searchFilter);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void searchFilter() {
    setState(() {
      if (textController.text.isEmpty) {
        filteredItems = List<T>.from(items);
      } else {
        filteredItems = items.where((item) {
          return item.toString().toLowerCase().contains(textController.text.toLowerCase());
        }).toList();
      }
    });
  }

  // TODO: Figure out how to make this work with searchFilter
  void dropdownFilter(String? value) {
    setState(() {
      if (value == null) {
        searchFilter();
      } else {
        filteredItems = items.where((item) {
          return item.toString().toLowerCase().contains(value.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Search',
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            for (String dropdown in dropdowns.keys)
              CustomDropdown(
                title: dropdown,
                values: dropdowns[dropdown]!,
                onChanged: dropdownFilter,
              ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return listTile(filteredItems[index]);
            },
          ),
        ),
      ],
    );
  }
}
