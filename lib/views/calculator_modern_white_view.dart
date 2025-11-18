import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/calculator_viewmodel.dart';

class CalculatorModernWhiteView extends StatelessWidget {
  const CalculatorModernWhiteView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalculatorViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6C73D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Column(
        children: [
          // HEADER JAUNE AVEC FORME ARRONDIE
          ClipPath(
            clipper: YellowClipper(),
            child: Container(
              padding: const EdgeInsets.only(
                top: 40,
                bottom: 30,
                left: 20,
                right: 20,
              ),
              width: double.infinity,
              color: const Color(0xFFF6C73D),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vm.expression.isEmpty ? "" : vm.expression,
                    style: const TextStyle(fontSize: 20, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    vm.expression.isEmpty ? "0" : vm.expression,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // CLAVIER NUMÉRIQUE
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  numberRow(vm, ["7", "8", "9"]),
                  numberRow(vm, ["4", "5", "6"]),
                  numberRow(vm, ["1", "2", "3"]),
                  numberRow(vm, ["Del", "0", "."]),
                ],
              ),
            ),
          ),

          // BARRE D’OPÉRATEURS + "=" GRAND BOUTON
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      opBtn(vm, "+"),
                      opBtn(vm, "-"),
                      opBtn(vm, "×"),
                      opBtn(vm, "÷"),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // BOUTON "=" VERTICAL
                GestureDetector(
                  onTap: vm.equal,
                  child: Container(
                    height: 110,
                    width: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC09A2C),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "=",
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- CLAVIER ----------
  Widget numberRow(CalculatorViewModel vm, List<String> keys) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: keys.map((key) {
          return GestureDetector(
            onTap: () {
              if (key == "Del") {
                vm.backspace();
              } else {
                vm.input(key);
              }
            },
            child: Text(
              key,
              style: const TextStyle(fontSize: 32, color: Colors.black87),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget opBtn(CalculatorViewModel vm, String op) {
    return GestureDetector(
      onTap: () => vm.input(op),
      child: Text(
        op,
        style: const TextStyle(fontSize: 36, color: Colors.black87),
      ),
    );
  }
}

// ----------- CLIPPER POUR LA FORME JAUNE ----------
class YellowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 40,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
