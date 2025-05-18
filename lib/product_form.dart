import 'package:flutter/material.dart';

// في ملف product_form.dart

class ProductForm extends StatelessWidget {
  final List<String> mainCategories;
  final List<String> subCategories;
  final List<String> subSubCategories;
  final Function onProductAdded; // الدالة التي ستستقبل المنتج عند إضافته

  // تعريف الـ constructor مع المعاملات
  ProductForm({
    required this.mainCategories,
    required this.subCategories,
    required this.subSubCategories,
    required this.onProductAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          // هنا تضيف حقول النموذج مثل اسم المنتج، السعر، الوصف، إلخ
          TextFormField(decoration: InputDecoration(labelText: 'اسم المنتج')),
          TextFormField(decoration: InputDecoration(labelText: 'السعر')),
          // إضافة Dropdown لعرض الـ mainCategories
          DropdownButton<String>(
            hint: Text("اختر القسم الرئيسي"),
            items:
                mainCategories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
            onChanged: (String? newCategory) {
              // التعامل مع التغيير في الاختيار
            },
          ),
          // يمكن إضافة المزيد من القوائم المنسدلة للأقسام الفرعية والفرعية الفرعية هنا
          // مثال للقسم الفرعي:
          DropdownButton<String>(
            hint: Text("اختر القسم الفرعي"),
            items:
                subCategories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
            onChanged: (String? newCategory) {
              // التعامل مع التغيير في الاختيار
            },
          ),
          // عندما يتم إضافة المنتج:
          ElevatedButton(
            onPressed: () {
              onProductAdded(); // استدعاء الدالة الممررة
            },
            child: Text("إضافة المنتج"),
          ),
        ],
      ),
    );
  }
}
