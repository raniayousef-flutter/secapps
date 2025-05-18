import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secapps/BagsCategoryPage.dart';
import 'package:secapps/CarsCategoryPage.dart';
import 'package:secapps/DevicesCategoryPage.dart';
import 'package:secapps/FavoritePage.dart';
import 'package:secapps/HealthBeautyCategoryPage.dart';
import 'package:secapps/JewelryCategoryPage.dart';
import 'package:secapps/KidsCategoryPage.dart';
import 'package:secapps/KitchenCategoryPage.dart';
import 'package:secapps/LingerieCategoryPage.dart';
import 'package:secapps/MenCategoryPage.dart';
import 'package:secapps/MenuPage.dart';
import 'package:secapps/PromoPage.dart';
import 'package:secapps/SearchResultPage.dart';
import 'package:secapps/ShoesCategoryPage.dart';
import 'package:secapps/TextilesCategoryPage.dart';
import 'package:secapps/ToysCategoryPage.dart';
import 'package:secapps/WomenCategoryPage.dart';
import 'package:secapps/subcategorypage.dart'; // صفحة الأقسام الفرعية

class HomePage extends StatelessWidget {
  final List<String> promoLabels = ["فلاش", " خصومات ", "عروض"];
  final List<IconData> promoIcons = [
    Icons.local_offer,
    Icons.attach_money,
    Icons.sports_esports,
  ];

  final List<String> categories = [
    "نساء",
    "لانجري",
    "أطفال",
    "حقائب",
    "رجال",
    "أحذية",
    "مجوهرات",
    "صحة وجمال",
    "مطبخ",
    "منسوجات",
    "ألعاب",
    "سيارات",
    "أجهزة",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ======= هيدر الصورة =======
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Image.asset(
                  'assets/header_bg.jpg',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MenuPage()),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FavoritePage()),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                    ),
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
                ),
              ],
            ),
          ),

          // ======= أزرار العروض الترويجية =======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => PromoPage(title: promoLabels[index]),
                            ),
                          );
                        },
                        icon: Icon(promoIcons[index], size: 20),
                        label: Text(
                          promoLabels[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // ======= تسوق حسب القسم =======
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "تسوق حسب القسم",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final category = categories[index];

                return GestureDetector(
                  onTap: () {
                    if (category == 'نساء') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => WomenCategoryPage()),
                      );
                    } else if (category == 'لانجري') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LingerieCategoryPage(),
                        ),
                      );
                    } else if (category == 'أطفال') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => KidsCategoryPage()),
                      );
                    } else if (category == 'حقائب') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => BagsCategoryPage()),
                      );
                    } else if (category == 'رجال') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MenCategoryPage()),
                      );
                    } else if (category == 'أحذية') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ShoesCategoryPage()),
                      );
                    } else if (category == 'مجوهرات') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JewelryCategoryPage(),
                        ),
                      );
                    } else if (category == 'صحة وجمال') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HealthBeautyCategoryPage(),
                        ),
                      );
                    } else if (category == 'مطبخ ') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KitchenCategoryPage(),
                        ),
                      );
                    } else if (category == 'منسوجات ') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TextilesCategoryPage(),
                        ),
                      );
                    } else if (category == 'ألعاب') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ToysCategoryPage()),
                      );
                    } else if (category == 'سيارات') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CarsCategoryPage()),
                      );
                    } else if (category == 'أجهزة ') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DevicesCategoryPage(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SubCategoryPage(category: category),
                        ),
                      );
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.deepPurple.withOpacity(0.1),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/icons/$category.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }, childCount: categories.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 100,
              ),
            ),
          ),

          // ======= المنتجات المميزة =======
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "منتجات مميزة لك",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // StreamBuilder لعرض المنتجات
          SliverToBoxAdapter(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('products')
                      .where('status', isEqualTo: 'تمت الموافقة')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                }

                final products = snapshot.data!.docs;

                if (products.isEmpty) {
                  return const Center(child: Text('لا توجد منتجات حالياً.'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              child: Image.network(
                                product['images'][0]['url'],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text("السعر: ${product['price']} د.ك"),
                                  ],
                                ),
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
      // زر سلة المشتريات الثابت
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
        child: const Icon(Icons.shopping_cart),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secapps/BagsCategoryPage.dart';
import 'package:secapps/CarsCategoryPage.dart';
import 'package:secapps/DevicesCategoryPage.dart';
import 'package:secapps/FavoritePage.dart';
import 'package:secapps/HealthBeautyCategoryPage.dart';
import 'package:secapps/JewelryCategoryPage.dart';
import 'package:secapps/KidsCategoryPage.dart';
import 'package:secapps/KitchenCategoryPage.dart';
import 'package:secapps/LingerieCategoryPage.dart';
import 'package:secapps/MenCategoryPage.dart';
import 'package:secapps/MenuPage.dart';
import 'package:secapps/PromoPage.dart';
import 'package:secapps/SearchResultPage.dart';
import 'package:secapps/CartPage.dart';
import 'package:secapps/ShoesCategoryPage.dart';
import 'package:secapps/TextilesCategoryPage.dart';
import 'package:secapps/ToysCategoryPage.dart';
import 'package:secapps/WomenCategoryPage.dart';
import 'package:secapps/subcategorypage.dart'; // صفحة الأقسام الفرعية

class HomePage extends StatelessWidget {
  final List<String> promoLabels = ["اشترِ 20%", "أقل من ", "العنقطة"];
  final List<IconData> promoIcons = [
    Icons.local_offer,
    Icons.attach_money,
    Icons.sports_esports,
  ];

  final List<String> categories = [
    "نساء",
    "لانجري",
    "أطفال",
    "حقائب",
    "رجال",
    "أحذية",
    "مجوهرات",
    "صحة وجمال",
    "مطبخ",
    "منسوجات",
    "ألعاب",
    "سيارات",
    "أجهزة",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ======= هيدر الصورة =======
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Image.asset(
                  'assets/header_bg.jpg',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MenuPage()),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FavoritePage()),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                    ),
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
                ),
              ],
            ),
          ),

          // ======= أزرار العروض الترويجية =======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => PromoPage(title: promoLabels[index]),
                            ),
                          );
                        },
                        icon: Icon(promoIcons[index], size: 20),
                        label: Text(
                          promoLabels[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // ======= تسوق حسب القسم =======
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "تسوق حسب القسم",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          /*
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return GestureDetector(
                  onTap: () {
                    if (categories[index] == 'رجال') {
                      // افتح صفحة الرجال
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MenCategoryPage(), // افتح صفحة الرجال
                        ),
                      );
                    } else {
                      // افتح صفحة الفئة الفرعية
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => SubCategoryPage(
                                category: categories[index],
                              ), // افتح صفحة الفئة الفرعية مع التمرير للقيمة
                        ),
                      );
                    }
                  },

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.deepPurple.withOpacity(0.1),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/icons/${categories[index]}.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        categories[index],
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }, childCount: categories.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 100,
              ),
            ),
          ), */
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final category = categories[index];

                return GestureDetector(
                  onTap: () {
                    if (category == 'نساء') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => WomenCategoryPage()),
                      );
                    } else if (category == 'لانجري') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LingerieCategoryPage(),
                        ),
                      );
                    } else if (category == 'الأطفال') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => KidsCategoryPage()),
                      );
                    } else if (category == 'الحقائب') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => BagsCategoryPage()),
                      );
                    } else if (category == 'الرجال') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MenCategoryPage()),
                      );
                    } else if (category == 'الأحذية') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ShoesCategoryPage()),
                      );
                    } else if (category == 'المجوهرات والاكسسوارات') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JewelryCategoryPage(),
                        ),
                      );
                    } else if (category == 'الصحة والجمال') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HealthBeautyCategoryPage(),
                        ),
                      );
                    } else if (category == 'المطبخ والمعيشة') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KitchenCategoryPage(),
                        ),
                      );
                    } else if (category == 'المنسوجات المنزلية') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TextilesCategoryPage(),
                        ),
                      );
                    } else if (category == 'الألعاب') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ToysCategoryPage()),
                      );
                    } else if (category == 'السيارات') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CarsCategoryPage()),
                      );
                    } else if (category == 'الأجهزة المنزلية') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DevicesCategoryPage(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SubCategoryPage(category: category),
                        ),
                      );
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.deepPurple.withOpacity(0.1),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/icons/$category.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }, childCount: categories.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 100,
              ),
            ),
          ),

          // ======= منتجات مميزة لك =======
         /* const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "منتجات مميزة لك",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('products')
                        .where('status', isEqualTo: 'تمت الموافقة')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final product = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              product['images'][0]['url'], // تحميل الصورة من Firebase
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("السعر: ${product['price']} د.ك"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }, childCount: 50),
          ),
        ],
      ),*/
      CustomScrollView(
  slivers: [
    const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Text(
          "منتجات مميزة لك",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    ),

    // هنا نستخدم StreamBuilder مرة واحدة فقط
    SliverToBoxAdapter(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('status', isEqualTo: 'تمت الموافقة')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return const Center(child: Text('لا توجد منتجات حالياً.'));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // مهم داخل CustomScrollView
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        child: Image.network(
                          product['images'][0]['url'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text("السعر: ${product['price']} د.ك"),
                            ],
                          ),
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
)


      // زر سلة المشتريات الثابت
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CartPage()),
          );
        },
        child: const Icon(Icons.shopping_cart),
        backgroundColor: Colors.deepOrange,
      ),
      );
  }
}

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secapps/CategoryPage.dart';
import 'package:secapps/FavoritePage.dart';
import 'package:secapps/MenuPage.dart';
import 'package:secapps/PromoPage.dart';
import 'package:secapps/SearchResultPage.dart';
import 'package:secapps/CartPage.dart';
import 'CategoryPage.dart'; // إضافة استيراد صفحة 

class HomePage extends StatelessWidget {
  final List<String> promoLabels = ["اشترِ 20%", "أقل من ", "العنقطة"];
  final List<IconData> promoIcons = [
    Icons.local_offer,
    Icons.attach_money,
    Icons.sports_esports,
  ];

  final List<String> categories = [
    "نساء",
    "لانجري",
    "أطفال",
    "حقائب",
    "رجال",
    "أحذية",
    "مجوهرات",
    "صحة وجمال",
    "مطبخ",
    "منسوجات",
    "ألعاب",
    "سيارات",
    "أجهزة",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ======= هيدر الصورة =======
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Image.asset(
                  'assets/header_bg.jpg',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MenuPage()),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FavoritePage()),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                    ),
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
                ),
              ],
            ),
          ),

          // ======= أزرار العروض الترويجية =======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => PromoPage(title: promoLabels[index]),
                            ),
                          );
                        },
                        icon: Icon(promoIcons[index], size: 20),
                        label: Text(
                          promoLabels[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // ======= تسوق حسب القسم =======
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "تسوق حسب القسم",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => CategoriesPage(category: categories[index]),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.deepPurple.withOpacity(0.1),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/icons/${categories[index]}.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        categories[index],
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }, childCount: categories.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 100,
              ),
            ),
          ),

          // ======= منتجات مميزة لك =======
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "منتجات مميزة لك",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return FutureBuilder<QuerySnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection('products')
                        .where(
                          'status',
                          isEqualTo: 'تمت الموافقة',
                        ) // الاستعلام باستخدام status
                        .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final product = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              product['images'][0]['url'], // تحميل الصورة من Firebase
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("السعر: ${product['price']} د.ك"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }, childCount: 50),
          ),
        ],
      ),

      // زر سلة المشتريات الثابت
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CartPage()),
          );
        },
        child: const Icon(Icons.shopping_cart),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
} 

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secapps/CategoryPage.dart';
import 'package:secapps/FavoritePage.dart';
import 'package:secapps/MenuPage.dart';
import 'package:secapps/PromoPage.dart';
import 'package:secapps/SearchResultPage.dart';

class HomePage extends StatelessWidget {
  final List<String> promoLabels = ["اشترِ 20%", "أقل من ", "العنقطة"];
  final List<IconData> promoIcons = [
    Icons.local_offer,
    Icons.attach_money,
    Icons.sports_esports,
  ];

  final List<String> categories = [
    "نساء",
    "لانجري",
    "أطفال",
    "حقائب",
    "رجال",
    "أحذية",
    "مجوهرات",
    "صحة وجمال",
    "مطبخ",
    "منسوجات",
    "ألعاب",
    "سيارات",
    "أجهزة",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ======= هيدر الصورة =======
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Image.asset(
                  'assets/header_bg.jpg',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MenuPage()),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FavoritePage()),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                    ),
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
                ),
              ],
            ),
          ),

          // ======= أزرار العروض الترويجية =======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => PromoPage(title: promoLabels[index]),
                            ),
                          );
                        },
                        icon: Icon(promoIcons[index], size: 20),
                        label: Text(
                          promoLabels[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // ======= تسوق حسب القسم =======
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "تسوق حسب القسم",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => CategoryPage(category: categories[index]),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.deepPurple.withOpacity(0.1),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/icons/${categories[index]}.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        categories[index],
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }, childCount: categories.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 100,
              ),
            ),
          ),

          // ======= منتجات مميزة لك =======
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "منتجات مميزة لك",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('products').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final product = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              product['image'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("السعر: ${product['price']} د.ك"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }, childCount: 50),
          ),
        ],
      ),
    );
  }
} */

/*

import 'package:flutter/material.dart';
import 'dart:math';

class HomePage extends StatelessWidget {
  final List<String> promoLabels = ["اشترِ 20%", "أقل من ", "العنقطة"];

  final List<IconData> promoIcons = [
    Icons.local_offer,
    Icons.attach_money,
    Icons.sports_esports,
  ];

  final List<String> categories = [
    "نساء",
    "لانجري",
    "أطفال",
    "حقائب",
    "رجال",
    "أحذية",
    "مجوهرات",
    "صحة وجمال",
    "مطبخ",
    "منسوجات",
    "ألعاب",
    "سيارات",
    "أجهزة",
  ];

  final List<Map<String, dynamic>> sampleProducts = List.generate(
    30,
    (index) => {
      "name": "منتج ${index + 1}",
      "price": (Random().nextDouble() * 20 + 1).toStringAsFixed(2),
      "image": "assets/sample_product.jpg",
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ======= هيدر الصورة =======
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Image.asset(
                  'assets/header_bg.jpg',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MenuPage()),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FavoritePage()),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                    ),
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
                ),
              ],
            ),
          ),

          // ======= أزرار العروض الترويجية =======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => PromoPage(title: promoLabels[index]),
                            ),
                          );
                        },
                        icon: Icon(promoIcons[index], size: 20),
                        label: Text(
                          promoLabels[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // ======= زر ملفي الشخصي =======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'ملفي الشخصي',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),

          // ======= تسوق حسب القسم =======
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "تسوق حسب القسم",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => CategoryPage(category: categories[index]),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.deepPurple.withOpacity(0.1),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/icons/${categories[index]}.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        categories[index],
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }, childCount: categories.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 100,
              ),
            ),
          ),

          // ======= منتجات مميزة لك =======
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "منتجات مميزة لك",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = sampleProducts[index % sampleProducts.length];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        child: Image.asset(
                          product['image'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text("السعر: ${product['price']} د.ك"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: 50),
          ),
        ],
      ),
    );
  }
}

// ============= الصفحات الفرعية =============

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("المفضلة")),
      body: const Center(child: Text("صفحة المفضلة")),
    );
  }
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("القائمة")),
      body: const Center(child: Text("صفحة القائمة")),
    );
  }
}

class PromoPage extends StatelessWidget {
  final String title;
  const PromoPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("صفحة العرض: $title")),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String category;
  const CategoryPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: Center(child: Text("منتجات قسم: $category")),
    );
  }
}

class SearchResultPage extends StatelessWidget {
  final String query;
  const SearchResultPage({required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("نتائج البحث")),
      body: Center(child: Text("نتائج البحث لـ: $query")),
    );
  }
}  
*/
*/ */
