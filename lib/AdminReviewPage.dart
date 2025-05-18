import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminReviewPage extends StatefulWidget {
  const AdminReviewPage({Key? key}) : super(key: key);

  @override
  _AdminReviewPageState createState() => _AdminReviewPageState();
}

class _AdminReviewPageState extends State<AdminReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('مراجعة المنتجات')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('products')
                .where('status', isEqualTo: 'قيد المراجعة')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data?.docs ?? [];

          if (products.isEmpty) {
            return Center(child: Text('لا توجد منتجات للمراجعة حالياً.'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final doc = products[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اسم المنتج: ${data['name'] ?? ''}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('السعر: ${data['price'] ?? ''}'),
                      Text('الوصف: ${data['description'] ?? ''}'),
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
                                  .doc(doc.id)
                                  .update({'status': 'تمت الموافقة'});

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('تمت الموافقة على المنتج'),
                                ),
                              );
                            },
                            child: Text('موافقة'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  final reasonController =
                                      TextEditingController();
                                  return AlertDialog(
                                    title: Text('رفض المنتج'),
                                    content: TextField(
                                      controller: reasonController,
                                      decoration: InputDecoration(
                                        labelText: 'سبب الرفض',
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('إلغاء'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                        child: Text('رفض'),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('products')
                                              .doc(doc.id)
                                              .update({
                                                'status': 'مرفوض',
                                                'rejectionReason':
                                                    reasonController.text,
                                              });
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text('تم رفض المنتج'),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('رفض'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
