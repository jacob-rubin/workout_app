import 'package:flutter/foundation.dart';

class SearchProvider extends ChangeNotifier {
  String _searchText = '';
  int? _chipIndex;

  String get searchText => _searchText;
  set searchText(String searchText) {
    _searchText = searchText;
    notifyListeners();
  }

  int? get chipIndex => _chipIndex;
  set chipIndex(int? chipIndex) {
    print('chipIndex: $chipIndex');
    _chipIndex = chipIndex;
    notifyListeners();
  }
}
