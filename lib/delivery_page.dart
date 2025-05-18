import 'package:flutter/material.dart';

class DeliveryPage extends StatelessWidget {
  const DeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("توصيل أقل من KWD 0.8")),
      body: const Center(child: Text("صفحة التوصيل")),
    );
  }
}
