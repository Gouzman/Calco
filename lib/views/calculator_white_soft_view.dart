import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/white_soft_theme.dart';
import '../viewmodels/calculator_viewmodel.dart';
import '../widgets/soft_neu_button.dart';

class CalculatorWhiteSoftView extends StatelessWidget {
  const CalculatorWhiteSoftView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalculatorViewModel>(context);

    return Scaffold(
      backgroundColor: whiteSoftTheme.background,
      appBar: AppBar(
        title: const Text("Soft Calc"),
        elevation: 0,
        backgroundColor: whiteSoftTheme.background,
      ),

      body: Column(
        children: [
          // Display
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: whiteSoftTheme.display,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 6,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  offset: const Offset(4, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Text(
              vm.expression.isEmpty ? "0" : vm.expression,
              style: const TextStyle(fontSize: 36, color: Colors.black87),
              textAlign: TextAlign.right,
            ),
          ),

          const SizedBox(height: 6),

          // Button Grid
          Expanded(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double size = constraints.maxWidth / 5.2;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      row(vm, ['7', '8', '9', '+'], size),
                      row(vm, ['4', '5', '6', '-'], size),
                      row(vm, ['1', '2', '3', '×'], size),
                      row(vm, ['C', '0', '=', '÷'], size),
                    ],
                  );
                },
              ),
            ),
          ),

          // SPACE FOR ADS
          Container(height: 60, color: Colors.transparent),
        ],
      ),
    );
  }

  Widget row(CalculatorViewModel vm, List<String> labels, double size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: labels.map((value) {
          bool isOperator = ['+', '-', '×', '÷', '='].contains(value);
          bool isDelete = value == 'C';

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SoftNeuButton(
              label: value,
              color: isDelete
                  ? whiteSoftTheme
                        .accent // bouton rouge
                  : whiteSoftTheme.buttonColor,
              textColor: isDelete
                  ? Colors
                        .white // "C" en blanc sur rouge
                  : isOperator
                  ? Colors
                        .black87 // opérateurs en NOIR
                  : Colors.black87,
              size: size,
              onTap: () {
                if (value == 'C') {
                  vm.clear();
                } else if (value == '=') {
                  vm.equal();
                } else {
                  vm.input(value);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
