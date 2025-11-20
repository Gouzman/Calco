// lib/views/calculator_scientific_pro_view.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:provider/provider.dart';
import '../viewmodels/calculator_viewmodel.dart';

class CalculatorScientificProView extends StatefulWidget {
  const CalculatorScientificProView({super.key});

  @override
  State<CalculatorScientificProView> createState() =>
      _CalculatorScientificProViewState();
}

class _CalculatorScientificProViewState
    extends State<CalculatorScientificProView> {
  final List<_FuncItem> _functions = [];
  final TextEditingController _inputController = TextEditingController();
  final List<Color> _palette = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.pink,
  ];

  // Graph range and sampling
  double _minX = -10;
  double _maxX = 10;
  double _minY = -10;
  double _maxY = 10;
  double _step = 0.1;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _addFunction(String expr, Color color) {
    if (expr.trim().isEmpty) return;
    setState(() {
      _functions.add(_FuncItem(expr.trim(), color));
      _inputController.clear();
    });
  }

  void _removeFunction(int index) {
    setState(() => _functions.removeAt(index));
  }

  /// Evaluate expression by replacing x with numeric literal (works reliably
  /// across math_expressions versions). We wrap x with parentheses to avoid
  /// string collisions.
  double? _evalAt(String expr, double x) {
    try {
      // Replace occurrences of variable x with numeric value, but avoid replacing
      // parts of other identifiers: use RegExp word boundary for 'x'
      final xStr = "(${x.toString()})";
      final safe = expr.replaceAllMapped(RegExp(r'\bx\b'), (_) => xStr);

      final parser = ShuntingYardParser();
      final parsed = parser.parse(safe);
      final evaluator = RealEvaluator();
      final cm = ContextModel(); // no variables needed because we replaced x
      final res = evaluator.evaluate(parsed);
      if (res is num) return res.toDouble();
      return double.tryParse(res.toString());
    } catch (e) {
      return null;
    }
  }

  List<List<Offset>> _generateAllPoints(
    Size size,
    double pxPerUnitX,
    double pxPerUnitY,
  ) {
    final List<List<Offset>> all = [];

    for (final f in _functions) {
      final List<Offset> pts = [];
      for (double x = _minX; x <= _maxX; x += _step) {
        final y = _evalAt(f.expr, x);
        if (y == null || !y.isFinite) {
          pts.add(const Offset(double.nan, double.nan)); // gap
          continue;
        }
        // Convert to pixel coords later in painter; store logical coords
        pts.add(Offset(x, y));
      }
      all.add(pts);
    }

    return all;
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalculatorViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scientific Graph Pro"),
        backgroundColor: const Color(0xFF2C2C36),
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: Column(
        children: [
          // Top: function list + add input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // input
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: const InputDecoration(
                      labelText: "f(x) =",
                      hintText: "ex: sin(x), x^2 + 3*x - 1",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) {
                      _addFunction(_inputController.text, _palette[0]);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // color picker simple: choose default palette color for new function
                PopupMenuButton<int>(
                  tooltip: "Couleur",
                  icon: const Icon(Icons.palette),
                  onSelected: (i) =>
                      _addFunction(_inputController.text, _palette[i]),
                  itemBuilder: (context) {
                    return List.generate(_palette.length, (i) {
                      return PopupMenuItem(
                        value: i,
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 16,
                              color: _palette[i],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Ajouter en ${_palette[i].toString().split('(').first}",
                            ),
                          ],
                        ),
                      );
                    });
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      _addFunction(_inputController.text, _palette[0]),
                  child: const Text("Add"),
                ),
              ],
            ),
          ),

          // current functions
          if (_functions.isNotEmpty)
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, i) {
                  final f = _functions[i];
                  return Chip(
                    backgroundColor: Colors.white,
                    avatar: CircleAvatar(backgroundColor: f.color),
                    label: Text(f.expr),
                    onDeleted: () => _removeFunction(i),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: _functions.length,
              ),
            ),

          // Controls for range and step
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                const Text("X range:"),
                const SizedBox(width: 8),
                SizedBox(
                  width: 120,
                  child: TextFormField(
                    initialValue: _minX.toString(),
                    decoration: const InputDecoration(labelText: "minX"),
                    onFieldSubmitted: (v) =>
                        setState(() => _minX = double.tryParse(v) ?? _minX),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 120,
                  child: TextFormField(
                    initialValue: _maxX.toString(),
                    decoration: const InputDecoration(labelText: "maxX"),
                    onFieldSubmitted: (v) =>
                        setState(() => _maxX = double.tryParse(v) ?? _maxX),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text("Step:"),
                const SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    initialValue: _step.toString(),
                    decoration: const InputDecoration(labelText: "step"),
                    onFieldSubmitted: (v) =>
                        setState(() => _step = double.tryParse(v) ?? _step),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // GRAPH AREA
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;

                // simply compute pixels per unit for reference (not strictly required now)
                final pxPerUnitX = size.width / (_maxX - _minX);
                final pxPerUnitY = size.height / (_maxY - _minY);

                final allPoints = _generateAllPoints(
                  size,
                  pxPerUnitX,
                  pxPerUnitY,
                );

                return Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    size: size,
                    painter: _GraphPainter(
                      functions: _functions,
                      allLogicalPoints: allPoints,
                      minX: _minX,
                      maxX: _maxX,
                      minY: _minY,
                      maxY: _maxY,
                    ),
                  ),
                );
              },
            ),
          ),

          // footer actions
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _functions.clear();
                    });
                  },
                  icon: const Icon(Icons.clear_all),
                  label: const Text("Clear All"),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    // quick sample functions
                    setState(() {
                      _functions.clear();
                      _functions.add(_FuncItem("sin(x)", Colors.blue));
                      _functions.add(_FuncItem("cos(x)", Colors.red));
                      _functions.add(_FuncItem("0.1*x^3 - x", Colors.green));
                    });
                  },
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text("Sample"),
                ),
                const Spacer(),
                Text("Curves: ${_functions.length}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// small holder for function + color
class _FuncItem {
  final String expr;
  final Color color;
  _FuncItem(this.expr, this.color);
}

/// Custom painter: draws grid, axes and curves.
/// allLogicalPoints: list per function of logical coordinates (x,y)
class _GraphPainter extends CustomPainter {
  final List<_FuncItem> functions;
  final List<List<Offset>> allLogicalPoints;
  final double minX, maxX, minY, maxY;

  _GraphPainter({
    required this.functions,
    required this.allLogicalPoints,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;

    // background
    final bg = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.color = Colors.white;
    canvas.drawRect(bg, paint);

    // grid style
    paint.color = Colors.grey.shade300;
    paint.strokeWidth = 1.0;

    // draw vertical grid lines
    final int vCount = 10;
    for (int i = 0; i <= vCount; i++) {
      final dx = i * size.width / vCount;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }

    // draw horizontal grid lines
    final int hCount = 10;
    for (int j = 0; j <= hCount; j++) {
      final dy = j * size.height / hCount;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }

    // draw axes (x=0,y=0) if inside view
    final axisPaint = Paint()
      ..color = Colors.grey.shade700
      ..strokeWidth = 2.0;

    // mapping functions: logical (x,y) -> pixel (px,py)
    double mapX(double x) => (x - minX) / (maxX - minX) * size.width;
    double mapY(double y) =>
        size.height - (y - minY) / (maxY - minY) * size.height;

    // x axis
    if (minY < 0 && maxY > 0) {
      final y0 = mapY(0);
      canvas.drawLine(Offset(0, y0), Offset(size.width, y0), axisPaint);
    }

    // y axis
    if (minX < 0 && maxX > 0) {
      final x0 = mapX(0);
      canvas.drawLine(Offset(x0, 0), Offset(x0, size.height), axisPaint);
    }

    // draw each function
    for (int fi = 0; fi < allLogicalPoints.length; fi++) {
      final pts = allLogicalPoints[fi];
      if (pts.isEmpty) continue;
      final fPaint = Paint()
        ..color = functions[fi].color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..isAntiAlias = true;

      final path = Path();
      bool started = false;

      for (int i = 0; i < pts.length; i++) {
        final p = pts[i];
        if (p.dx.isNaN || p.dy.isNaN) {
          // gap in curve: finish current subpath
          started = false;
          continue;
        }
        final px = mapX(p.dx);
        final py = mapY(p.dy);

        if (!started) {
          path.moveTo(px, py);
          started = true;
        } else {
          path.lineTo(px, py);
        }
      }

      canvas.drawPath(path, fPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPainter old) {
    return old.allLogicalPoints != allLogicalPoints ||
        old.functions.length != functions.length;
  }
}
