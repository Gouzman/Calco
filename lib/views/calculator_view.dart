import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart';
import '../viewmodels/calculator_viewmodel.dart';
import '../widgets/neumorphic_button.dart';

class CalculatorView extends StatelessWidget {
  final CalcTheme theme;
  const CalculatorView({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalculatorViewModel>(context);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(backgroundColor: theme.background, elevation: 0),
      body: Column(
        children: [
          /// DISPLAY
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.display,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              vm.expression.isEmpty ? "0" : vm.expression,
              style: TextStyle(
                color: theme.textColor,
                fontSize: 44,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.right,
            ),
          ),

          /// ZONE DES BOUTONS
          Expanded(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Taille ajustée selon l'écran
                  final double size = constraints.maxWidth / 5;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildRow(vm, ['7', '8', '9', '÷'], theme, size),
                      buildRow(vm, ['4', '5', '6', '×'], theme, size),
                      buildRow(vm, ['1', '2', '3', '-'], theme, size),
                      buildRow(vm, ['C', '0', '.', '='], theme, size),
                    ],
                  );
                },
              ),
            ),
          ),

          /// ESPACE PUB (footer fixe)
          Container(
            height: 60,
            width: double.infinity,
            color: Colors.transparent,
            child: Center(
              child: Text(
                "Espace Publicité",
                style: TextStyle(color: Colors.white.withOpacity(0.3)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildRow(
  CalculatorViewModel vm,
  List<String> values,
  CalcTheme theme,
  double size,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: values.map((value) {
        final isOp = ['÷', '×', '-', '+', '='].contains(value);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: NeuButton(
            label: value,
            color: isOp ? theme.operatorColor : theme.buttonColor,
            onTap: () {
              if (value == 'C') {
                vm.clear();
              } else if (value == '=') {
                vm.equal();
              } else {
                vm.input(value);
              }
            },
            size: size, // 🔥 ajout taille dynamique
          ),
        );
      }).toList(),
    ),
  );
}
