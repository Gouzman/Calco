import 'package:flutter/material.dart';
import '../core/calculator_engine.dart';

class CalculatorViewModel extends ChangeNotifier {
  final CalculatorEngine engine = CalculatorEngine();

  String get expression => engine.expression;

  void input(String value) {
    engine.add(value);
    notifyListeners();
  }

  void clear() {
    engine.clear();
    notifyListeners();
  }

  void backspace() {
    engine.backspace();
    notifyListeners();
  }

  void equal() {
    final result = engine.evaluate();
    engine.replace(result);
    notifyListeners();
  }
}
