import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SellerHomePage extends StatefulWidget {
  final String sellerPhone;

  const SellerHomePage({Key? key, required this.sellerPhone}) : super(key: key);

  @override
  _SellerHomePageState createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة تحكم البائع'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
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

              final mainCategoryController = TextEditingController(
                text: data['mainCategory'] ?? '',
              );
              final subCategoryController = TextEditingController(
                text: data['subCategory'] ?? '',
              );
              final subSubCategoryController = TextEditingController(
                text: data['subSubCategory'] ?? '',
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
                        TextFormField(
                          controller: mainCategoryController,
                          decoration: InputDecoration(
                            labelText: 'التصنيف الرئيسي',
                          ),
                        ),
                        TextFormField(
                          controller: subCategoryController,
                          decoration: InputDecoration(
                            labelText: 'التصنيف الفرعي',
                          ),
                        ),
                        TextFormField(
                          controller: subSubCategoryController,
                          decoration: InputDecoration(
                            labelText: 'التصنيف الفرعي الفرعي',
                          ),
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
                                      'mainCategory':
                                          mainCategoryController.text,
                                      'subCategory': subCategoryController.text,
                                      'subSubCategory':
                                          subSubCategoryController.text,
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
                        SizedBox(height: 10),

                        // زر إرسال للمراجعة أو عرض الحالة
                        if (data['status'] == null || data['status'] == '') ...[
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(productId)
                                  .update({'status': 'قيد المراجعة'});

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('تم إرسال المنتج للمراجعة'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: Text('إرسال للمراجعة'),
                          ),
                        ] else ...[
                          Text(
                            'الحالة: ${data['status']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  data['status'] == 'تمت الموافقة'
                                      ? Colors.green
                                      : data['status'] == 'مرفوض'
                                      ? Colors.red
                                      : Colors.orange,
                            ),
                          ),
                          if (data['note'] != null &&
                              data['note'].toString().isNotEmpty)
                            Text('ملاحظة: ${data['note']}'),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/add_product',
            arguments: {'sellerPhone': widget.sellerPhone},
          );
        },
      ),
    );
  }
}

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SellerHomePage extends StatefulWidget {
  final String sellerPhone;

  const SellerHomePage({Key? key, required this.sellerPhone}) : super(key: key);

  @override
  _SellerHomePageState createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة تحكم البائع'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/add_product',
            arguments: {'sellerPhone': widget.sellerPhone},
          );
        },
      ),
    );
  }
} */
