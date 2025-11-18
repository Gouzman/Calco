import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:math_expressions/math_expressions.dart';

class GraphView extends StatefulWidget {
  const GraphView({super.key});

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  String expression = "x";

  List<FlSpot> generatePoints() {
    List<FlSpot> points = [];

    try {
      final parser = ShuntingYardParser();
      final exp = parser.parse(expression);
      final evaluator = RealEvaluator();
      final cm = ContextModel();

      for (double x = -10; x <= 10; x += 0.1) {
        cm.bindVariable(Variable('x'), Number(x));
        final result = evaluator.evaluate(exp);

        if (result.isFinite) {
          points.add(FlSpot(x.toDouble(), result.toDouble()));
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Graph Plotter")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "f(x) =",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => expression = v),
            ),
          ),

          Expanded(
            child: LineChart(
              LineChartData(
                minX: -10,
                maxX: 10,
                minY: -10,
                maxY: 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: generatePoints(),
                    isCurved: false,
                    barWidth: 2,
                    color: Colors.blue,
                    dotData: const FlDotData(show: false),
                  ),
                ],
                gridData: const FlGridData(show: true),
                titlesData: const FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
