import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('سلة المشتريات')),
        body: Center(child: Text('يجب تسجيل الدخول لعرض السلة')),
      );
    }

    final cartItemsStream =
        FirebaseFirestore.instance
            .collection('cartItems')
            .where('userId', isEqualTo: user.uid)
            .snapshots();

    return Scaffold(
      appBar: AppBar(title: Text('سلة المشتريات')),
      body: StreamBuilder<QuerySnapshot>(
        stream: cartItemsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('حدث خطأ في تحميل السلة');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;

          if (items.isEmpty) {
            return Center(child: Text('السلة فارغة'));
          }

          // ✅ حساب المجموع الكلي
          double totalPrice = 0;
          for (var doc in items) {
            final data = doc.data() as Map<String, dynamic>;
            final price = (data['price'] ?? 0).toDouble();
            final quantity = (data['quantity'] ?? 1).toInt();
            totalPrice += price * quantity;
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children:
                      items.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final quantity = data['quantity'] ?? 1;
                        final price = data['price'] ?? 0;

                        return ListTile(
                          leading: Image.network(
                            data['image'],
                            width: 50,
                            height: 50,
                          ),
                          title: Text(data['name']),
                          subtitle: Text('السعر: $price د.ك'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  if (quantity > 1) {
                                    doc.reference.update({
                                      'quantity': quantity - 1,
                                    });
                                  } else {
                                    doc.reference.delete();
                                  }
                                },
                              ),
                              Text('$quantity'),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  doc.reference.update({
                                    'quantity': quantity + 1,
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'المجموع الكلي: ${totalPrice.toStringAsFixed(2)} د.ك',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
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

class CartPage extends StatelessWidget {
  final DocumentSnapshot product;

  const CartPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        product['images'] != null && product['images'].isNotEmpty
            ? product['images'][0]['url']
            : 'https://via.placeholder.com/150';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('عربة التسوق'),
          backgroundColor: Colors.deepOrange,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(imageUrl, height: 200),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product['name'] ?? 'بدون اسم',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('الوصف: ${product['description'] ?? 'لا يوجد وصف'}'),
              const SizedBox(height: 8),
              Text('السعر: ${product['price']} د.ك'),
              const SizedBox(height: 8),
              Text('المقاس: ${product['size'] ?? 'غير محدد'}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('يرجى تسجيل الدخول أولاً')),
                    );
                    return;
                  }

                  final cartItemId = '${user.uid}_${product.id}';

                  final cartItemData = {
                    'userId': user.uid,
                    'productId': product.id,
                    'name': product['name'],
                    'price': product['price'],
                    'image':
                        product['images'] != null &&
                                product['images'].isNotEmpty
                            ? product['images'][0]['url']
                            : '',
                    'quantity': 1,
                    'timestamp': FieldValue.serverTimestamp(),
                  };

                  await FirebaseFirestore.instance
                      .collection('cartItems')
                      .doc(cartItemId)
                      .set(cartItemData);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تمت إضافة المنتج إلى السلة')),
                  );
                },
                child: const Text('تأكيد الإضافة إلى السلة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('يرجى تسجيل الدخول لعرض السلة')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة المشتريات'),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('cartItems')
                .where('userId', isEqualTo: user.uid)
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('السلة فارغة'));
          }

          final cartItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return ListTile(
                leading: Image.network(
                  item['image'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(item['name']),
                subtitle: Text('السعر: ${item['price']} د.ك'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await item.reference.delete();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}*/

/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // قم بتغيير هذا لاحقًا ليستخدم بيانات المستخدم الحقيقي
    final String currentUserPhone = '0799999999';

    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة المشتريات'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('carts')
                .doc(currentUserPhone)
                .collection('items')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('السلة فارغة'));
          }

          final cartItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return ListTile(
                leading: Image.network(
                  item['imageUrl'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(item['name']),
                subtitle: Text('السعر: ${item['price']} د.ك'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await item.reference.delete();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
} */
