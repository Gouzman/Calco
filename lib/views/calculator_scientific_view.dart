import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/calculator_viewmodel.dart';

class CalculatorScientificView extends StatelessWidget {
  const CalculatorScientificView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalculatorViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE3E3E3),
      appBar: AppBar(
        title: const Text("Scientific Calculator"),
        backgroundColor: const Color(0xFFE3E3E3),
        elevation: 0,
      ),

      body: Column(
        children: [
          // ÉCRAN
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFD5E0D5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black54, width: 1),
            ),
            child: Text(
              vm.expression.isEmpty ? "0" : vm.expression,
              style: const TextStyle(fontSize: 24),
            ),
          ),

          // TOUTES LES TOUCHES CASIO-LIKE
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  scientificRow(context, vm, [
                    "sin",
                    "cos",
                    "tan",
                    "log",
                    "ln",
                  ]),
                  scientificRow(context, vm, ["π", "e", "^", "√", "x⁻¹"]),
                  scientificRow(context, vm, ["(", ")", "abs", "|x|", "mod"]),
                  scientificRow(context, vm, ["7", "8", "9", "/", "DEL"]),
                  scientificRow(context, vm, ["4", "5", "6", "*", "-"]),
                  scientificRow(context, vm, ["1", "2", "3", "+", "="]),
                  scientificRow(context, vm, ["0", ".", "EXP", "Ans", "GRAPH"]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Corrigé ici : ajout du BuildContext
  Widget scientificRow(
    BuildContext context,
    CalculatorViewModel vm,
    List<String> values,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: values.map((value) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: const Size(60, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            onPressed: () {
              if (value == "DEL") {
                vm.backspace();
              } else if (value == "=") {
                vm.equal();
              } else if (value == "GRAPH") {
                // Navigation vers la page graphique
                Navigator.pushNamed(context, "/graph");
              } else {
                vm.input(value);
              }
            },
            child: Text(value, style: const TextStyle(fontSize: 18)),
          );
        }).toList(),
      ),
    );
  }
}
