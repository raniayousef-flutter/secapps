import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageProductsPage extends StatefulWidget {
  final String sellerPhone;

  ManageProductsPage({required this.sellerPhone});

  @override
  _ManageProductsPageState createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إدارة منتجاتي')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('products')
                .where('sellerPhone', isEqualTo: widget.sellerPhone)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data?.docs ?? [];

          if (products.isEmpty) {
            return Center(child: Text('لا توجد منتجات حالياً.'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final doc = products[index];
              final data = doc.data() as Map<String, dynamic>;
              final productId = doc.id;

              final nameController = TextEditingController(text: data['name']);
              final priceController = TextEditingController(
                text: data['price']?.toString() ?? '',
              );
              final qtyController = TextEditingController(
                text: data['quantity']?.toString() ?? '',
              );
              final sizeController = TextEditingController(
                text: data['size'] ?? '',
              );
              final descController = TextEditingController(
                text: data['description'] ?? '',
              );

              return ExpansionTile(
                title: Text(data['name'] ?? 'منتج'),
                subtitle: Text('السعر: ${data['price'] ?? 'غير متوفر'}'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: 'اسم المنتج'),
                        ),
                        TextFormField(
                          controller: priceController,
                          decoration: InputDecoration(labelText: 'السعر'),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: qtyController,
                          decoration: InputDecoration(
                            labelText: 'الكمية المتوفرة',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: sizeController,
                          decoration: InputDecoration(
                            labelText: 'المقاس / الرقم',
                          ),
                        ),
                        TextFormField(
                          controller: descController,
                          decoration: InputDecoration(labelText: 'الوصف'),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: List.generate(
                            data['images']?.length ?? 0,
                            (i) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  data['images'][i]['url'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                                Text(data['images'][i]['color'] ?? ''),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('products')
                                    .doc(productId)
                                    .update({
                                      'name': nameController.text,
                                      'price':
                                          double.tryParse(
                                            priceController.text,
                                          ) ??
                                          0,
                                      'quantity':
                                          int.tryParse(qtyController.text) ?? 0,
                                      'size': sizeController.text,
                                      'description': descController.text,
                                    });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('تم تحديث المنتج')),
                                );
                              },
                              child: Text('حفظ التعديلات'),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: Text('حذف المنتج'),
                                        content: Text(
                                          'هل أنت متأكد أنك تريد حذف هذا المنتج؟',
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text('إلغاء'),
                                            onPressed:
                                                () => Navigator.pop(
                                                  context,
                                                  false,
                                                ),
                                          ),
                                          TextButton(
                                            child: Text('حذف'),
                                            onPressed:
                                                () => Navigator.pop(
                                                  context,
                                                  true,
                                                ),
                                          ),
                                        ],
                                      ),
                                );

                                if (confirm == true) {
                                  await FirebaseFirestore.instance
                                      .collection('products')
                                      .doc(productId)
                                      .delete();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text('حذف'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
