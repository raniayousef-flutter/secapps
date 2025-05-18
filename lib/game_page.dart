import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إلعب واربح")),
      body: const Center(child: Text("صفحة اللعبة")),
    );
  }
}
