import 'package:math_expressions/math_expressions.dart';

class CalculatorEngine {
  String _expr = "";

  String get expression => _expr;

  void add(String s) => _expr += s;

  void clear() => _expr = "";

  void backspace() {
    if (_expr.isNotEmpty) {
      _expr = _expr.substring(0, _expr.length - 1);
    }
  }

  void replace(String s) => _expr = s;

  String evaluate() {
    try {
      final safe = _expr.replaceAll('×', '*').replaceAll('÷', '/');
      // ignore: deprecated_member_use
      Parser p = Parser();
      Expression exp = p.parse(safe);
      ContextModel cm = ContextModel();
      // ignore: deprecated_member_use
      double val = exp.evaluate(EvaluationType.REAL, cm);

      if (val % 1 == 0) return val.toInt().toString();
      return val.toString();
    } catch (e) {
      return "Erreur";
    }
  }
}
