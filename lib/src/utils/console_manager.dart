import 'dart:collection';
import 'package:flutter/cupertino.dart';

class ConsoleManager extends ChangeNotifier {
  final Map<int, String> _lista = {};

  void addLine(String value) {
    _lista.addAll({
      DateTime.now().millisecondsSinceEpoch: value
    });
    notifyListeners();
  }

  List<String> getLines() {
    final list = SplayTreeMap<int, String>.from(_lista, (k1, k2) => k2.compareTo(k1));
    final max = list.values.length < 20 ? list.values.length : 20;
    return list.values.take(max).toList();
  }

  void clear() {
    _lista.clear();
  }
}
