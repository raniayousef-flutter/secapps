import 'package:flutter/material.dart';

class PromoPage extends StatelessWidget {
  final String title;

  const PromoPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("تفاصيل العرض: $title")),
    );
  }
}
