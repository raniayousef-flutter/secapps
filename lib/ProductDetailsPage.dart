import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = product.data() as Map<String, dynamic>;

    // الحصول على الرابط الصحيح للصورة
    final imageUrl =
        (data['images'] != null && data['images'].isNotEmpty)
            ? data['images'][0]['url']
            : 'https://via.placeholder.com/150';

    return Scaffold(
      appBar: AppBar(title: Text(data['name'] ?? 'تفاصيل المنتج')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عرض الصورة
            Image.network(
              imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              "الاسم: ${data['name'] ?? 'غير متوفر'}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("السعر: ${data['price'] ?? 'غير محدد'} JD"),
            const SizedBox(height: 8),
            Text("اللون: ${data['color'] ?? 'غير محدد'}"),
            const SizedBox(height: 8),
            Text("الوصف: ${data['description'] ?? 'لا يوجد'}"),
          ],
        ),
      ),
    );
  }
}
