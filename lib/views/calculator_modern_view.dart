import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/calculator_viewmodel.dart';

class CalculatorModernView extends StatelessWidget {
  const CalculatorModernView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalculatorViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF4A4C7A),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4C841),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Column(
        children: [
          // HEADER JAUNE
          Container(
            color: const Color(0xFFF4C841),
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: Column(
              children: [
                const Text(
                  "Basic",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  vm.expression.isEmpty ? "0" : vm.expression,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // BARRE D’OPÉRATEURS DESSOUS
          Container(
            height: 70,
            color: const Color(0xFF4A4C7A),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF374063),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    opButton(vm, "+"),
                    opButton(vm, "-"),
                    specialEqual(vm), // "=" centré style spécial
                    opButton(vm, "×"),
                    opButton(vm, "÷"),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // CLAVIER NUMÉRIQUE
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 25,
                crossAxisSpacing: 25,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                const keys = [
                  "7",
                  "8",
                  "9",
                  "4",
                  "5",
                  "6",
                  "1",
                  "2",
                  "3",
                  ".",
                  "0",
                  "DEL",
                ];
                final value = keys[index];

                return numberButton(vm, value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget opButton(CalculatorViewModel vm, String op) {
    return IconButton(
      onPressed: () => vm.input(op),
      icon: Text(
        op,
        style: const TextStyle(fontSize: 24, color: Colors.white70),
      ),
    );
  }

  Widget specialEqual(CalculatorViewModel vm) {
    return GestureDetector(
      onTap: vm.equal,
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF4C841),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text("=", style: TextStyle(fontSize: 26, color: Colors.black)),
        ),
      ),
    );
  }

  Widget numberButton(CalculatorViewModel vm, String label) {
    return GestureDetector(
      onTap: () {
        if (label == "DEL") {
          vm.backspace();
        } else {
          vm.input(label);
        }
      },
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 32, color: Colors.white70),
        ),
      ),
    );
  }
}
