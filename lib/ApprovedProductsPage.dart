import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovedProductsPage extends StatelessWidget {
  final String mainCategory;
  final String subCategory; // إضافة الفئة الفرعية كمتغير

  // إضافة الفئة الفرعية إلى الكونسِتراكتور
  ApprovedProductsPage({required this.mainCategory, required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('منتجات $mainCategory - $subCategory')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('products')
                .where(
                  'mainCategory',
                  isEqualTo: mainCategory,
                ) // الاستعلام للفئة الرئيسية
                .where(
                  'subCategory',
                  isEqualTo: subCategory,
                ) // إضافة الاستعلام للفئة الفرعية
                .where(
                  'status',
                  isEqualTo: 'تمت الموافقة',
                ) // المنتجات المعتمدة فقط
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('لا توجد منتجات حالياً.'));
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final name = product['name'] ?? '';
              final price = product['price'] ?? 0;
              final images = product['images'] as List<dynamic>;
              final imageUrl = images.isNotEmpty ? images[0]['url'] : null;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading:
                      imageUrl != null
                          ? Image.network(
                            imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                          : Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey,
                          ),
                  title: Text(name),
                  subtitle: Text('السعر: $price د.أ'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
