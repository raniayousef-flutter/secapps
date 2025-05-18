import 'package:flutter/material.dart';
import 'ApprovedProductsPage.dart'; // تأكد من إنشاء هذه الصفحة أو نسخ الكود اللي كتبته سابقاً

class CategoriesPage extends StatelessWidget {
  final List<String> mainCategories = [
    'نساء',
    'لانجري وملابس داخلية وبيتيه',
    'الأطفال',
    'الحقائب',
    'الرجال',
    'الأحذية',
    'المجوهرات والاكسسوارات',
    'الصحة والجمال',
    'المطبخ والمعيشة',
    'المنسوجات المنزلية',
    'الألعاب',
    'السيارات',
    'الأجهزة المنزلية',
  ];

  final Map<String, List<String>> subCategories = {
    'الرجال': ['بناطيل', 'قمصان', 'بلايز', 'ملابس داخلية', 'أطقم', 'جاكيتات'],
    // يمكنك إضافة المزيد من الأقسام الفرعية هنا حسب الحاجة.
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الأقسام')),
      body: ListView.builder(
        itemCount: mainCategories.length,
        itemBuilder: (context, index) {
          String mainCategory = mainCategories[index];
          return Column(
            children: [
              ListTile(
                title: Text(mainCategory),
                onTap: () {
                  // عند الضغط على القسم الرئيسي، سنعرض الأقسام الفرعية
                  if (subCategories.containsKey(mainCategory)) {
                    _showSubCategories(context, mainCategory);
                  } else {
                    // إذا لم يكن هناك أقسام فرعية، نعرض المنتجات مباشرةً
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ApprovedProductsPage(
                              mainCategory: mainCategory,
                              subCategory: '',
                            ),
                      ),
                    );
                  }
                },
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }

  // وظيفة لعرض الأقسام الفرعية
  void _showSubCategories(BuildContext context, String mainCategory) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('اختر الفئة الفرعية'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                subCategories[mainCategory]!
                    .map(
                      (subCategory) => ListTile(
                        title: Text(subCategory),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ApprovedProductsPage(
                                    mainCategory: mainCategory,
                                    subCategory: subCategory,
                                  ),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
          ),
        );
      },
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'ApprovedProductsPage.dart';


class CategoriesPage extends StatelessWidget {
  final List<String> mainCategories = [
    'نساء',
    'لانجري وملابس داخلية وبيتيه',
    'الأطفال',
    'الحقائب',
    'الرجال',
    'الأحذية',
    'المجوهرات والاكسسوارات',
    'الصحة والجمال',
    'المطبخ والمعيشة',
    'المنسوجات المنزلية',
    'الألعاب',
    'السيارات',
    'الأجهزة المنزلية',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الأقسام'),
      ),
      body: ListView.builder(
        itemCount: mainCategories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(mainCategories[index]),
            onTap: () {
              // عند النقر على القسم الرئيسي، انتقل إلى صفحة الفئات الفرعية
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategoryPage(
                    category: mainCategories[index],
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

class SubCategoryPage extends StatelessWidget {
  final String category;
  SubCategoryPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('فئات $category'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getApprovedProducts(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("حدث خطأ: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("لا توجد منتجات لهذه الفئة"));
          }

          // عرض المنتجات الموفقة
          List<Map<String, dynamic>> products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              return ListTile(
                title: Text(product['name']),
                subtitle: Text('السعر: ${product['price']} د.ا'),
                leading: Image.network(product['images'][0]['url']),
                onTap: () {
                  // عند النقر على المنتج، يمكن الانتقال لصفحة تفاصيل المنتج
                },
              );
            },
          );
        },
      ),
    );
  }
} */

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String category;

  const CategoryPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: FutureBuilder<QuerySnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('products')
                .where('category', isEqualTo: category)
                .where('approved', isEqualTo: true)
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return const Center(child: Text('لا توجد منتجات حالياً'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Image.network(
                    product['image'],
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product['name']),
                  subtitle: Text("السعر: ${product['price']} د.ك"),
                ),
              );
            },
          );
        },
      ),
    );
  }
} */
