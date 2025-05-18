import 'package:flutter/material.dart';
import 'package:secapps/ApprovedProductsPage.dart';

class SubSubCategoryPage extends StatelessWidget {
  final String mainCategory;
  final String subCategory;

  SubSubCategoryPage({required this.mainCategory, required this.subCategory});

  // قائمة الفئات الفرعية الفرعية لكل قسم رئيسي وفئة فرعية
  final Map<String, Map<String, List<String>>> subSubCategoriesMap = {
    'الرجال': {
      'قمصان': ['قميص رسمي', 'قميص كاجوال'],
      'بناطيل': ['جينز', 'بناطيل قماش'],
      'تيشيرتات': ['تيشيرت كاجوال', 'تيشيرت رياضي'],
    },
    'النساء': {
      'فساتين': ['فستان سهرة', 'فستان صيفي'],
      'بلايز': ['بلوزة قصيرة', 'بلوزة طويلة'],
      'تنورات': ['تنورة قصيرة', 'تنورة طويلة'],
    },
    'الأطفال': {
      'أولاد': ['قميص بولو', 'تيشيرت'],
      'بنات': ['فستان أطفال', 'بلوزة'],
      'رضع': ['ملابس نوم', 'بدلة أطفال'],
    },
    // أضف المزيد حسب الحاجة
  };

  @override
  Widget build(BuildContext context) {
    final subSubCategories =
        subSubCategoriesMap[mainCategory]?[subCategory] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('الفئات الفرعية لـ $subCategory')),
      body: ListView.builder(
        itemCount: subSubCategories.length,
        itemBuilder: (context, index) {
          final subSubCategory = subSubCategories[index];
          return ListTile(
            title: Text(subSubCategory),
            onTap: () {
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
            },
          );
        },
      ),
    );
  }
}
