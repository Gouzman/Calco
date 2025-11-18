import 'package:flutter/material.dart';
import '../themes/dark_neu_theme.dart';
import 'calculator_view.dart';
import 'calculator_white_soft_view.dart';
import './calculator_scientific_view.dart';
import 'calculator_modern_view.dart';
import 'calculator_modern_white_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Widget modelItem({
    required String title,
    required String img,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.all(12),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(img, width: 60, height: 60, fit: BoxFit.cover),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choisir un modèle"), elevation: 0),
      body: ListView(
        children: [
          modelItem(
            title: "calco 1",
            img: "assets/images/image1.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CalculatorView(theme: darkNeuTheme),
                ),
              );
            },
          ),

          const Divider(height: 1),

          modelItem(
            title: "Calco 2",
            img: "assets/images/image2.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CalculatorWhiteSoftView(),
                ),
              );
            },
          ),

          const Divider(height: 1),

          modelItem(
            title: "Calco 3",
            img: "assets/images/image3.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CalculatorScientificView(),
                ),
              );
            },
          ),

          const Divider(height: 1),
          modelItem(
            title: "Modern Yellow",
            img: "assets/images/image4.png", // Mets ton image
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalculatorModernView()),
              );
            },
          ),
          const Divider(height: 1),

          modelItem(
            title: "Modern White & Yellow",
            img: "assets/images/image5.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CalculatorModernWhiteView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
