import 'package:flutter/material.dart';
import 'ApprovedProductsPage.dart';

class SubCategoryPage extends StatelessWidget {
  final String category;

  SubCategoryPage({required this.category});

  // قائمة الفئات الفرعية لكل قسم رئيسي
  final Map<String, List<String>> subCategoriesMap = {
    'الرجال': ['قمصان', 'بناطيل', 'تيشيرتات'],
    'النساء': ['فساتين', 'بلايز', 'تنورات'],
    'الأطفال': ['أولاد', 'بنات', 'رضع'],
    // أضف المزيد حسب الحاجة
  };

  @override
  Widget build(BuildContext context) {
    final subCategories = subCategoriesMap[category] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('الفئات الفرعية لـ $category')),
      body: ListView.builder(
        itemCount: subCategories.length,
        itemBuilder: (context, index) {
          final subCategory = subCategories[index];
          return ListTile(
            title: Text(subCategory),
            onTap: () {
              // عند النقر على الفئة الفرعية، انتقل إلى صفحة المنتجات المعتمدة
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ApprovedProductsPage(
                        mainCategory: category,
                        subCategory: subCategory, // إرسال الفئة الفرعية
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
