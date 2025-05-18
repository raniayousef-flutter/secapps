import 'package:flutter/material.dart';

class CouponPage extends StatelessWidget {
  const CouponPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("خصم 20%")),
      body: const Center(child: Text("صفحة الكوبون")),
    );
  }
}
