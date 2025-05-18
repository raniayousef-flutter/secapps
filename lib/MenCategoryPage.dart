import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secapps/ProductDetailsPage.dart';
import 'package:secapps/SearchResultPage.dart';

class MenCategoryPage extends StatefulWidget {
  @override
  _MenCategoryPageState createState() => _MenCategoryPageState();
}

class _MenCategoryPageState extends State<MenCategoryPage> {
  final List<Map<String, dynamic>> subCategories = [
    {'label': 'بناطيل', 'image': 'assets/pants.jpg'},
    {'label': 'قمصان', 'image': 'assets/shirt.jpg'},
    {'label': 'بلايز', 'image': 'assets/tshirt.jpg'},
    {'label': 'ملابس داخلية', 'image': 'assets/underwear.png'},
    {'label': 'اطقم', 'image': 'assets/seta.jpg'},
    {'label': 'جاكيتات', 'image': 'assets/jacket.jpg'},
  ];

  Future<void> addToCart(
    BuildContext context,
    Map<String, dynamic> product,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('يجب تسجيل الدخول أولاً')));
      return;
    }

    final cartItemId = '${user.uid}_${product['id'] ?? product['productId']}';
    final cartItemRef = FirebaseFirestore.instance
        .collection('cartItems')
        .doc(cartItemId);
    final cartItemSnapshot = await cartItemRef.get();

    if (cartItemSnapshot.exists) {
      final currentQuantity = cartItemSnapshot['quantity'] ?? 1;
      await cartItemRef.update({
        'quantity': currentQuantity + 1,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      final cartItemData = {
        'userId': user.uid,
        'productId': product['id'] ?? product['productId'],
        'name': product['name'],
        'price': product['price'],
        'image':
            product['images'] != null && product['images'].isNotEmpty
                ? product['images'][0]['url']
                : '',
        'quantity': 1,
        'timestamp': FieldValue.serverTimestamp(),
      };
      await cartItemRef.set(cartItemData);
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('تمت إضافة المنتج إلى السلة')));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('قسم الرجال'),
          backgroundColor: Colors.deepOrange,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "ابحث عن منتج...",
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                    ),
                    onSubmitted: (query) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SearchResultPage(query: query),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: subCategories.length,
                    itemBuilder: (context, index) {
                      final item = subCategories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.orange.shade100,
                              backgroundImage: AssetImage(item['image']),
                            ),
                            const SizedBox(height: 5),
                            Text(item['label'], style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('products')
                            .where('mainCategory', isEqualTo: 'الرجال')
                            .where('status', isEqualTo: 'تمت الموافقة')
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('حدث خطأ: ${snapshot.error}'),
                        );
                      }

                      final products = snapshot.data!.docs;

                      if (products.isEmpty) {
                        return const Center(
                          child: Text('لا توجد منتجات متاحة حالياً'),
                        );
                      }

                      int crossAxisCount = 2;
                      if (screenWidth > 900) {
                        crossAxisCount = 4;
                      } else if (screenWidth > 600) {
                        crossAxisCount = 3;
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final imageUrl =
                              product['images'] != null &&
                                      product['images'].isNotEmpty
                                  ? product['images'][0]['url']
                                  : 'https://via.placeholder.com/150';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          ProductDetailsPage(product: product),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      imageUrl,
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      product['name'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'السعر: ${product['price']} د.ك',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_shopping_cart,
                                            size: 20,
                                            color: Colors.deepOrange,
                                          ),
                                          onPressed: () async {
                                            await addToCart(context, {
                                              ...product.data()
                                                  as Map<String, dynamic>,
                                              'id': product.id,
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/*
import 'package\:cloud\_firestore/cloud\_firestore.dart';
import 'package\:firebase\_auth/firebase\_auth.dart';
import 'package\:flutter/material.dart';
import 'package\:secapps/ProductDetailsPage.dart';
import 'package\:secapps/SearchResultPage.dart';

class MenCategoryPage extends StatefulWidget {
@override
_MenCategoryPageState createState() => _MenCategoryPageState();
}

class _MenCategoryPageState extends State<MenCategoryPage> {
final List<Map<String, dynamic>> subCategories = [
{'label': 'بناطيل', 'image': 'assets/pants.jpg'},
{'label': 'قمصان', 'image': 'assets/shirt.jpg'},
{'label': 'بلايز', 'image': 'assets/tshirt.jpg'},
{'label': 'ملابس داخلية', 'image': 'assets/underwear.png'},
{'label': 'اطقم', 'image': 'assets/seta.jpg'},
{'label': 'جاكيتات', 'image': 'assets/jacket.jpg'},
];

@override
Widget build(BuildContext context) {
final screenWidth = MediaQuery.of(context).size.width;

return Directionality(
  textDirection: TextDirection.rtl,
  child: Scaffold(
    appBar: AppBar(
      title: const Text('قسم الرجال'),
      backgroundColor: Colors.deepOrange,
    ),
    body: LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "ابحث عن منتج...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
                onSubmitted: (query) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchResultPage(query: query),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subCategories.length,
                itemBuilder: (context, index) {
                  final item = subCategories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.orange.shade100,
                          backgroundImage: AssetImage(item['image']),
                        ),
                        const SizedBox(height: 5),
                        Text(item['label'], style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('products')
                        .where('mainCategory', isEqualTo: 'الرجال')
                        .where('status', isEqualTo: 'تمت الموافقة')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('حدث خطأ: ${snapshot.error}'),
                    );
                  }

                  final products = snapshot.data!.docs;

                  if (products.isEmpty) {
                    return const Center(
                      child: Text('لا توجد منتجات متاحة حالياً'),
                    );
                  }

                  int crossAxisCount = 2;
                  if (screenWidth > 900) {
                    crossAxisCount = 4;
                  } else if (screenWidth > 600) {
                    crossAxisCount = 3;
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final imageUrl =
                          product['images'] != null &&
                                  product['images'].isNotEmpty
                              ? product['images'][0]['url']
                              : 'https://via.placeholder.com/150';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      ProductDetailsPage(product: product),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  imageUrl,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product['name'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'السعر: ${product['price']} د.ك',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_shopping_cart,
                                        size: 20,
                                        color: Colors.deepOrange,
                                      ),
                                      onPressed: () async {
                                        final user =
                                            FirebaseAuth
                                                .instance
                                                .currentUser;

                                        if (user == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'يرجى تسجيل الدخول أولاً',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        final cartItemId =
                                            '${user.uid}_${product.id}';

                                        final cartItemData = {
                                          'userId': user.uid,
                                          'productId': product.id,
                                          'name': product['name'],
                                          'price': product['price'],
                                          'image':
                                              product['images'] != null &&
                                                      product['images']
                                                          .isNotEmpty
                                                  ? product['images'][0]['url']
                                                  : '',
                                          'quantity': 1,
                                          'timestamp':
                                              FieldValue.serverTimestamp(),
                                        };

                                        await FirebaseFirestore.instance
                                            .collection('cartItems')
                                            .doc(cartItemId)
                                            .set(cartItemData);

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'تمت إضافة المنتج إلى السلة',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    ),
  ),
);

}
}*/



                                  /*
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['name'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'السعر: ${product['price']} د.ك',
                                          style: TextStyle(
                                            color: Colors.deepOrange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),*/
                                

                          /*
                         return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          ProductDetailsPage(product: product),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      imageUrl,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      product['name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      'السعر: ${product['price']} د.ك',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );*/
                       

/* SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: subCategories.length,
                    itemBuilder: (context, index) {
                      final item = subCategories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.orange.shade100,
                              child: Icon(
                                item['icon'],
                                color: Colors.deepOrange,
                              ),
                              radius: 25,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item['label'],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ), */

/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secapps/ProductDetailsPage.dart';

class MenCategoryPage extends StatefulWidget {
  @override
  _MenCategoryPageState createState() => _MenCategoryPageState();
}

class _MenCategoryPageState extends State<MenCategoryPage> {
  final List<Map<String, dynamic>> subCategories = [
    {'label': 'بناطيل', 'icon': Icons.work},
    {'label': 'قمصان', 'icon': Icons.checkroom},
    {'label': 'بلايز', 'icon': Icons.emoji_people},
    {'label': 'ملابس داخلية', 'icon': Icons.bedroom_baby},
    {'label': 'اطقم', 'icon': Icons.shopping_bag},
    {'label': 'جاكيتات', 'icon': Icons.ac_unit},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قسم الرجال'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن منتج...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subCategories.length,
              itemBuilder: (context, index) {
                final item = subCategories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.orange.shade100,
                        child: Icon(item['icon'], color: Colors.deepOrange),
                        radius: 25,
                      ),
                      SizedBox(height: 5),
                      Text(item['label'], style: TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('products')
                      .where('mainCategory', isEqualTo: 'الرجال')
                      .where('status', isEqualTo: 'تمت الموافقة')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.hasError)
                  return Center(child: Text('حدث خطأ: ${snapshot.error}'));

                final products = snapshot.data!.docs;

                if (products.isEmpty)
                  return Center(child: Text('لا توجد منتجات متاحة حالياً'));

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final imageUrl =
                        product['images'] != null &&
                                product['images'].isNotEmpty
                            ? product['images'][0]['url']
                            : 'https://via.placeholder.com/150';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ProductDetailsPage(product: product),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.network(
                                imageUrl,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                product['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                'السعر: ${product['price']} د.ك',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} */

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secapps/ProductDetailsPage.dart';
import 'package:secapps/productdetailspage.dart';


class MenCategoryPage extends StatefulWidget {
  @override
  _MenCategoryPageState createState() => _MenCategoryPageState();
}

class _MenCategoryPageState extends State<MenCategoryPage> {
  final List<Map<String, dynamic>> subCategories = [
    {'label': 'بناطيل', 'icon': Icons.work},
    {'label': 'قمصان', 'icon': Icons.checkroom},
    {'label': 'بلايز', 'icon': Icons.emoji_people},
    {'label': 'ملابس داخلية', 'icon': Icons.bedroom_baby},
    {'label': 'اطقم', 'icon': Icons.shopping_bag},
    {'label': 'جاكيتات', 'icon': Icons.ac_unit},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قسم الرجال'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          // ✅ شريط البحث
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن منتج...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),

          // ✅ الأقسام الفرعية بشكل دائري
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subCategories.length,
              itemBuilder: (context, index) {
                final item = subCategories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.orange.shade100,
                        child: Icon(item['icon'], color: Colors.deepOrange),
                        radius: 25,
                      ),
                      SizedBox(height: 5),
                      Text(item['label'], style: TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
          ),

          // ✅ المنتجات المعتمدة من قسم الرجال
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('products')
                      .where('mainCategory', isEqualTo: 'الرجال')
                      .where('status', isEqualTo: 'تمت الموافقة')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.hasError)
                  return Center(child: Text('حدث خطأ: ${snapshot.error}'));

                final products = snapshot.data!.docs;

                if (products.isEmpty)
                  return Center(child: Text('لا توجد منتجات متاحة حالياً'));

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final imageUrl = product['images'][0]['url'];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ProductDetailsPage(),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.network(
                                imageUrl,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                product['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                'السعر: ${product['price']} د.ك',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}*/
