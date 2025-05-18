import 'dart:core';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UploadProductPage extends StatefulWidget {
  final String sellerPhone;

  const UploadProductPage({super.key, required this.sellerPhone});

  @override
  UploadProductPageState createState() => UploadProductPageState();
}

class UploadProductPageState extends State<UploadProductPage> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productSizeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? mainCategory;
  String? subCategory;
  String? subSubCategory;

  List<Map<String, dynamic>> selectedImages = [];
  List<String> selectedSizes = [];

  List<String> mainCategories = [
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

  Map<String, List<String>> subCategories = {
    'نساء': [
      'ملابس عربية',
      'ملابس علوية',
      'فساتين',
      'بناطيل وتنانير',
      'ملابس داخلية',
      'أطقم كاملة',
      'رياضية',
      'ملابس نوم',
      'ملابس موسمية',
    ],
    'لانجري وملابس داخلية وبيتيه': [
      'حمالات صدر',
      'سراويل داخلية',
      'لانجري',
      'بيجامات',
      'أطقم داخلية',
    ],
    'الأطفال': ['أولاد', 'بنات', 'بيبي'],
    'الحقائب': ['يدوية', 'ظهر', 'كتف', 'أحزمة وسط'],
    'الرجال': ['بناطيل', 'قمصان', 'بلايز', 'ملابس داخلية', 'أطقم', 'جاكيتات'],
    'الأحذية': ['نساء', 'رجال', 'أطفال'],
    'المجوهرات والاكسسوارات': ['مجوهرات', 'اكسسوارات', 'حقائب صغيرة'],
    'الصحة والجمال': ['مكياج', 'عناية بالبشرة', 'شعر', 'أدوات تجميل'],
    'المطبخ والمعيشة': ['أواني', 'أدوات', 'ديكور', 'منظمات'],
    'المنسوجات المنزلية': ['مفروشات', 'مناشف', 'ستائر', 'سجاد'],
    'الألعاب': ['تعليمية', 'تسلية', 'الكترونية'],
    'السيارات': ['اكسسوارات', 'تنظيف', 'أجهزة'],
    'الأجهزة المنزلية': ['مطبخية', 'تنظيف', 'تدفئة وتبريد'],
  };

  Map<String, List<String>> subSubCategories = {
    // نساء
    'ملابس عربية': [
      'فساتين عربية',
      'قفاطين',
      'جلابيات',
      'عبايات',
      'ملابس صلاة',
    ],
    'ملابس علوية': ['بلايز نسائية', 'تي شيرت', 'سترات نسائية'],
    'فساتين': ['سهرة', 'صيفية', 'رسمية', 'كاجوال'],
    'بناطيل وتنانير': ['بناطيل قماش', 'جينز', 'تنانير'],
    'ملابس داخلية': ['حمالات صدر', 'سراويل داخلية', 'بيجامات', 'لانجري'],
    'أطقم كاملة': ['أطقم رسمية', 'أطقم يومية'],
    'رياضية': ['بناطيل رياضية', 'بلايز رياضية', 'أطقم رياضية'],
    'ملابس نوم': ['بيجامات طويلة', 'بيجامات قصيرة'],
    'ملابس موسمية': ['معاطف', 'جاكيتات', 'كنزات صوف', 'ملابس صيفية'],

    // لانجري
    'حمالات صدر': ['بأسلاك', 'من غير أسلاك', 'رياضية', 'للرضاعة'],
    'سراويل داخلية': ['قصة عالية', 'قصة منخفضة', 'بكيني', 'شورت'],
    'لانجري': ['بودي', 'ستاتين', 'طقم لانجري'],
    'بيجامات': ['شورت', 'بناطيل طويلة', 'فساتين نوم'],
    'أطقم داخلية': ['2 قطعة', '3 قطعة'],

    // الأطفال
    'أولاد': ['تيشيرت', 'بنطال', 'شورت', 'بدلة', 'بيجاما'],
    'بنات': ['فساتين', 'بيجامات', 'بلايز', 'بناطيل', 'أطقم'],
    'بيبي': ['ملابس مواليد', 'أطقم حديثي الولادة', 'ملابس داخلية للأطفال'],

    // الحقائب
    'يدوية': ['صغيرة', 'كبيرة'],
    'ظهر': ['مدرسية', 'رياضية'],
    'كتف': ['جلد', 'قماش'],
    'أحزمة وسط': ['أنيقة', 'رياضية'],

    // الرجال
    'بناطيل': ['جينز', 'قماش', 'رياضية', 'شورت'],
    'قمصان': ['رسمية', 'كاجوال'],
    'بلايز': ['تي شيرت', 'كنزات', 'سترات'],
    'ملابس داخلية': ['سراويل داخلية', 'بيجاما', 'فانيلة'],
    'أطقم': ['بدلة رسمية', 'أطقم رياضية'],
    'جاكيتات': ['شتوية', 'خريفية'],
    // الأحذية
    'نساء': ['كعب عالي', 'مسطحة', 'صنادل', 'رياضية'],
    'رجال': ['رسمية', 'رياضية', 'كاجوال'],
    'أطفال': ['مدرسية', 'رياضية', 'صنادل'],

    // المجوهرات والاكسسوارات
    'مجوهرات': ['خواتم', 'سلاسل', 'أقراط', 'أساور'],
    'اكسسوارات': ['نظارات شمسية', 'ساعات', 'قبعات', 'أوشحة'],
    'حقائب صغيرة': ['محفظة', 'حقيبة يد صغيرة'],

    // الصحة والجمال
    'مكياج': ['أحمر شفاه', 'كحل', 'بودرة', 'مكياج عيون'],
    'عناية بالبشرة': ['مرطبات', 'منظفات', 'واقي شمس'],
    'شعر': ['شامبو', 'بلسم', 'زيوت', 'أجهزة تصفيف'],
    'أدوات تجميل': ['فرش', 'مقص أظافر', 'مرايا'],

    // المطبخ والمعيشة
    'أواني': ['قدور', 'مقالي', 'صحون'],
    'أدوات': ['ملاعق', 'سكاكين', 'مقاشط'],
    'ديكور': ['شموع', 'مزهرية', 'إضاءة'],
    'منظمات': ['منظمات أدراج', 'صناديق تخزين'],

    // المنسوجات المنزلية
    'مفروشات': ['شراشف', 'بطانيات', 'مخدات'],
    'مناشف': ['مناشف حمام', 'مناشف مطبخ'],
    'ستائر': ['غرف نوم', 'صالونات'],
    'سجاد': ['صغير', 'متوسط', 'كبير'],

    // الألعاب
    'تعليمية': ['ألعاب تركيب', 'كتب تلوين'],
    'تسلية': ['عرائس', 'سيارات', 'كرات'],
    'الكترونية': ['ألعاب فيديو', 'أجهزة لعب'],

    // السيارات
    'اكسسوارات': ['حامل جوال', 'فرش أرضية', 'ستائر شمسية'],
    'تنظيف': ['منظف داخلي', 'خارجي', 'مماسح'],
    'أجهزة': ['شاحن سيارة', 'كاميرا أمامية', 'حساسات'],

    // الأجهزة المنزلية
    'مطبخية': ['خلاط', 'مايكرويف', 'محضرة طعام'],
    'تنظيف': ['مكنسة كهربائية', 'آلة تنظيف بالبخار'],
    'تدفئة وتبريد': ['دفاية', 'مروحة', 'مكيف متنقل'],
  };

  final List<String> clothingSizes = ['S', 'M', 'L', 'XL', 'XXL'];
  final List<String> shoeSizes = ['38', '39', '40', '41', '42', '43'];
  final List<String> onesize = ['one size (مقاس واحد)'];

  Future<void> pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      for (var file in result.files) {
        selectedImages.add({
          'fileBytes': file.bytes,
          'fileName': file.name,
          'color': null,
        });
      }
      setState(() {});
    }
  }

  // دالة لتحميل المنتج إلى Firebase
  Future<void> uploadProduct() async {
    if (mainCategory == null ||
        subCategory == null ||
        subSubCategory == null ||
        selectedImages.isEmpty ||
        productNameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        stockController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('الرجاء ملء جميع الحقول')));
      return;
    }

    if (selectedImages.any((image) => image['color'] == null)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('يرجى اختيار لون لكل صورة')));
      return;
    }

    try {
      String productId = Uuid().v4();
      List<Map<String, dynamic>> imageUrlsWithColors = [];

      for (var image in selectedImages) {
        String fileName = '${Uuid().v4()}_${image['fileName']}';
        Reference ref = storage.ref().child(
          'product_images/$productId/$fileName',
        );

        // استخرج امتداد الصورة
        String extension = fileName.split('.').last.toLowerCase();

        // حدد contentType بناءً على الامتداد
        String contentType = 'image/jpeg'; // افتراضي

        if (extension == 'png') {
          contentType = 'image/png';
        } else if (extension == 'jpg' || extension == 'jpeg') {
          contentType = 'image/jpeg';
        } else if (extension == 'gif') {
          contentType = 'image/gif';
        }

        UploadTask uploadTask = ref.putData(
          image['fileBytes'] as Uint8List,
          SettableMetadata(contentType: contentType),
        );
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();

        imageUrlsWithColors.add({'url': imageUrl, 'color': image['color']});
      }

      /*for (var image in selectedImages) {
        String fileName = '${Uuid().v4()}_${image['fileName']}';
        Reference ref = storage.ref().child(
          'product_images/$productId/$fileName',
        );
        UploadTask uploadTask = ref.putData(image['fileBytes'] as Uint8List);
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();

        imageUrlsWithColors.add({'url': imageUrl, 'color': image['color']});
      }*/

      await firestore.collection('products').doc(productId).set({
        'productId': productId,
        'sellerPhone': widget.sellerPhone,
        'productName': productNameController.text.trim(),
        'price': double.parse(priceController.text.trim()),
        'description': descriptionController.text.trim(),
        'stock': int.parse(stockController.text.trim()),
        'sizes': selectedSizes,
        'mainCategory': mainCategory,
        'subCategory': subCategory,
        'subSubCategory': subSubCategory,
        'images': imageUrlsWithColors,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'قيد المراجعة',
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تم رفع المنتج بنجاح')));

      // إعادة تعيين الحقول
      productNameController.clear();
      priceController.clear();
      descriptionController.clear();
      stockController.clear();
      selectedImages.clear();
      selectedSizes.clear();
      setState(() {
        mainCategory = null;
        subCategory = null;
        subSubCategory = null;
      });
    } catch (e) {
      print('خطأ في رفع المنتج: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء رفع المنتج')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إضافة منتج')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: productNameController,
              decoration: InputDecoration(labelText: 'اسم المنتج'),
            ),
            TextFormField(
              controller: productSizeController,
              decoration: InputDecoration(labelText: 'المقاس الأساسي'),
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'السعر (بالدينار)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'وصف المنتج'),
              maxLines: 3,
            ),
            TextFormField(
              controller: stockController,
              decoration: InputDecoration(labelText: 'الكمية المتوفرة'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: mainCategory,
              decoration: InputDecoration(labelText: 'الفئة الرئيسية'),
              items:
                  mainCategories
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
              onChanged: (val) {
                setState(() {
                  mainCategory = val;
                  subCategory = null;
                  subSubCategory = null;
                  selectedSizes.clear();
                });
              },
            ),
            if (mainCategory != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    value: subCategory,
                    decoration: InputDecoration(labelText: 'الفئة الفرعية'),
                    items:
                        subCategories[mainCategory]!
                            .map(
                              (sub) => DropdownMenuItem(
                                value: sub,
                                child: Text(sub),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      setState(() {
                        subCategory = val;
                        subSubCategory = null;
                      });
                    },
                  ),
                  if (subCategory != null)
                    DropdownButtonFormField<String>(
                      value: subSubCategory,
                      decoration: InputDecoration(
                        labelText: 'الفئة الفرعية الثانية',
                      ),
                      items:
                          subSubCategories[subCategory]!
                              .map(
                                (subSub) => DropdownMenuItem(
                                  value: subSub,
                                  child: Text(subSub),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (val) => setState(() {
                            subSubCategory = val;
                          }),
                    ),

                  SizedBox(height: 10),
                  Text('المقاسات المتوفرة'),
                  Wrap(
                    spacing: 8,
                    children:
                        ([
                                  'نساء',
                                  'لانجري وملابس داخلية وبيتيه',
                                  'الأطفال',
                                  'الرجال',
                                ].contains(mainCategory)
                                ? clothingSizes
                                : [
                                  'المجوهرات والاكسسوارات',
                                  'الصحة والجمال',
                                  'الحقائب',

                                  'المطبخ والمعيشة',
                                  'المنسوجات المنزلية',
                                  'الألعاب',
                                  'السيارات',
                                  'الأجهزة المنزلية',
                                ].contains(mainCategory)
                                ? onesize
                                : mainCategory == 'أحذية'
                                ? shoeSizes
                                : [])
                            .map(
                              (size) => FilterChip(
                                label: Text(size),
                                selected: selectedSizes.contains(size),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedSizes.add(size);
                                    } else {
                                      selectedSizes.remove(size);
                                    }
                                  });
                                },
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: pickImages, child: Text('اختيار الصور')),
            SizedBox(height: 10),
            ...selectedImages.map((img) {
              int index = selectedImages.indexOf(img);
              return Row(
                children: [
                  Image.memory(
                    img['fileBytes'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: img['color'],
                      decoration: InputDecoration(labelText: 'اللون'),
                      items:
                          ['أحمر', 'أزرق', 'أخضر', 'أسود', 'أبيض']
                              .map(
                                (color) => DropdownMenuItem(
                                  value: color,
                                  child: Text(color),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedImages[index]['color'] = value;
                        });
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(onPressed: uploadProduct, child: Text('رفع المنتج')),
          ],
        ),
      ),
    );
  }
}
/*

import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class UploadProductPage extends StatefulWidget {
  final String sellerPhone;

  const UploadProductPage({super.key, required this.sellerPhone});

  @override
  UploadProductPageState createState() => UploadProductPageState();
}

class UploadProductPageState extends State<UploadProductPage> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productSizeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? mainCategory;
  String? subCategory;
  String? subSubCategory;

  List<Map<String, dynamic>> selectedImages = [];

  List<String> selectedSizes = [];

  List<String> mainCategories = [
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

  Map<String, List<String>> subCategories = {
    'نساء': [
      'ملابس عربية',
      'ملابس علوية',
      'فساتين',
      'بناطيل وتنانير',
      'ملابس داخلية',
      'أطقم كاملة',
      'رياضية',
      'ملابس نوم',
      'ملابس موسمية',
    ],
    'لانجري وملابس داخلية وبيتيه': [
      'حمالات صدر',
      'سراويل داخلية',
      'لانجري',
      'بيجامات',
      'أطقم داخلية',
    ],
    'الأطفال': ['أولاد', 'بنات', 'بيبي'],
    'الحقائب': ['يدوية', 'ظهر', 'كتف', 'أحزمة وسط'],
    'الرجال': ['بناطيل', 'قمصان', 'بلايز', 'ملابس داخلية', 'أطقم', 'جاكيتات'],
    'الأحذية': ['نساء', 'رجال', 'أطفال'],
    'المجوهرات والاكسسوارات': ['مجوهرات', 'اكسسوارات', 'حقائب صغيرة'],
    'الصحة والجمال': ['مكياج', 'عناية بالبشرة', 'شعر', 'أدوات تجميل'],
    'المطبخ والمعيشة': ['أواني', 'أدوات', 'ديكور', 'منظمات'],
    'المنسوجات المنزلية': ['مفروشات', 'مناشف', 'ستائر', 'سجاد'],
    'الألعاب': ['تعليمية', 'تسلية', 'الكترونية'],
    'السيارات': ['اكسسوارات', 'تنظيف', 'أجهزة'],
    'الأجهزة المنزلية': ['مطبخية', 'تنظيف', 'تدفئة وتبريد'],
  };

  Map<String, List<String>> subSubCategories = {
    // نساء
    'ملابس عربية': [
      'فساتين عربية',
      'قفاطين',
      'جلابيات',
      'عبايات',
      'ملابس صلاة',
    ],
    'ملابس علوية': ['بلايز نسائية', 'تي شيرت', 'سترات نسائية'],
    'فساتين': ['سهرة', 'صيفية', 'رسمية', 'كاجوال'],
    'بناطيل وتنانير': ['بناطيل قماش', 'جينز', 'تنانير'],
    'ملابس داخلية': ['حمالات صدر', 'سراويل داخلية', 'بيجامات', 'لانجري'],
    'أطقم كاملة': ['أطقم رسمية', 'أطقم يومية'],
    'رياضية': ['بناطيل رياضية', 'بلايز رياضية', 'أطقم رياضية'],
    'ملابس نوم': ['بيجامات طويلة', 'بيجامات قصيرة'],
    'ملابس موسمية': ['معاطف', 'جاكيتات', 'كنزات صوف', 'ملابس صيفية'],

    // لانجري
    'حمالات صدر': ['بأسلاك', 'من غير أسلاك', 'رياضية', 'للرضاعة'],
    'سراويل داخلية': ['قصة عالية', 'قصة منخفضة', 'بكيني', 'شورت'],
    'لانجري': ['بودي', 'ستاتين', 'طقم لانجري'],
    'بيجامات': ['شورت', 'بناطيل طويلة', 'فساتين نوم'],
    'أطقم داخلية': ['2 قطعة', '3 قطعة'],

    // الأطفال
    'أولاد': ['تيشيرت', 'بنطال', 'شورت', 'بدلة', 'بيجاما'],
    'بنات': ['فساتين', 'بيجامات', 'بلايز', 'بناطيل', 'أطقم'],
    'بيبي': ['ملابس مواليد', 'أطقم حديثي الولادة', 'ملابس داخلية للأطفال'],

    // الحقائب
    'يدوية': ['صغيرة', 'كبيرة'],
    'ظهر': ['مدرسية', 'رياضية'],
    'كتف': ['جلد', 'قماش'],
    'أحزمة وسط': ['أنيقة', 'رياضية'],

    // الرجال
    'بناطيل': ['جينز', 'قماش', 'رياضية', 'شورت'],
    'قمصان': ['رسمية', 'كاجوال'],
    'بلايز': ['تي شيرت', 'كنزات', 'سترات'],
    'ملابس داخلية': ['سراويل داخلية', 'بيجاما', 'فانيلة'],
    'أطقم': ['بدلة رسمية', 'أطقم رياضية'],
    'جاكيتات': ['شتوية', 'خريفية'],
    // الأحذية
    'نساء': ['كعب عالي', 'مسطحة', 'صنادل', 'رياضية'],
    'رجال': ['رسمية', 'رياضية', 'كاجوال'],
    'أطفال': ['مدرسية', 'رياضية', 'صنادل'],

    // المجوهرات والاكسسوارات
    'مجوهرات': ['خواتم', 'سلاسل', 'أقراط', 'أساور'],
    'اكسسوارات': ['نظارات شمسية', 'ساعات', 'قبعات', 'أوشحة'],
    'حقائب صغيرة': ['محفظة', 'حقيبة يد صغيرة'],

    // الصحة والجمال
    'مكياج': ['أحمر شفاه', 'كحل', 'بودرة', 'مكياج عيون'],
    'عناية بالبشرة': ['مرطبات', 'منظفات', 'واقي شمس'],
    'شعر': ['شامبو', 'بلسم', 'زيوت', 'أجهزة تصفيف'],
    'أدوات تجميل': ['فرش', 'مقص أظافر', 'مرايا'],

    // المطبخ والمعيشة
    'أواني': ['قدور', 'مقالي', 'صحون'],
    'أدوات': ['ملاعق', 'سكاكين', 'مقاشط'],
    'ديكور': ['شموع', 'مزهرية', 'إضاءة'],
    'منظمات': ['منظمات أدراج', 'صناديق تخزين'],

    // المنسوجات المنزلية
    'مفروشات': ['شراشف', 'بطانيات', 'مخدات'],
    'مناشف': ['مناشف حمام', 'مناشف مطبخ'],
    'ستائر': ['غرف نوم', 'صالونات'],
    'سجاد': ['صغير', 'متوسط', 'كبير'],

    // الألعاب
    'تعليمية': ['ألعاب تركيب', 'كتب تلوين'],
    'تسلية': ['عرائس', 'سيارات', 'كرات'],
    'الكترونية': ['ألعاب فيديو', 'أجهزة لعب'],

    // السيارات
    'اكسسوارات': ['حامل جوال', 'فرش أرضية', 'ستائر شمسية'],
    'تنظيف': ['منظف داخلي', 'خارجي', 'مماسح'],
    'أجهزة': ['شاحن سيارة', 'كاميرا أمامية', 'حساسات'],

    // الأجهزة المنزلية
    'مطبخية': ['خلاط', 'مايكرويف', 'محضرة طعام'],
    'تنظيف': ['مكنسة كهربائية', 'آلة تنظيف بالبخار'],
    'تدفئة وتبريد': ['دفاية', 'مروحة', 'مكيف متنقل'],
  };

  final List<String> clothingSizes = ['S', 'M', 'L', 'XL', 'XXL'];
  final List<String> shoeSizes = ['38', '39', '40', '41', '42', '43'];
  final List<String> onesize = ['one size (مقاس واحد)'];

  Future<void> pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withData: true, // مهم للويب: يخلي الملف يرجع بداخل file.bytes
    );

    if (result != null && result.files.isNotEmpty) {
      selectedImages.clear();

      for (var file in result.files) {
        Uint8List? fileData;

        if (kIsWeb) {
          // للويب، نستخدم bytes
          fileData = file.bytes;
        } else {
          // للموبايل، نستخدم bytes أو نقرأ من path
          if (file.bytes != null) {
            fileData = file.bytes;
          } else if (file.path != null) {
            fileData = await File(file.path!).readAsBytes();
          }
        }

        if (fileData != null) {
          selectedImages.add({
            'fileBytes': fileData,
            'fileName': file.name,
            'color': null, // يختارها المستخدم لاحقًا
          });
        }
      }

      // حدث الواجهة
      if (!kIsWeb) {
        // Web عادة ما يستخدم StatefulWidgets مباشرة بدون setState خارجي
        // أما في الموبايل نحتاج setState داخل StatefulWidget
        // تأكد أنك داخل StatefulWidget
        setState(() {});
      }
    }
  }

  /* Future<void> pickImages() async {
    // اطلب إذن التخزين على Android فقط
    if (!kIsWeb && Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        print('تم رفض إذن التخزين');
        return;
      }
    }

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withData: true, // للويب
    );

    if (result != null && result.files.isNotEmpty) {
      selectedImages.clear();

      for (var file in result.files) {
        Uint8List? fileData;

        if (kIsWeb) {
          fileData = file.bytes;
        } else {
          if (file.bytes != null) {
            fileData = file.bytes;
          } else if (file.path != null) {
            fileData = await File(file.path!).readAsBytes();
          }
        }

        if (fileData != null) {
          selectedImages.add({
            'fileBytes': fileData,
            'fileName': file.name,
            'color': null,
          });
        }
      }

      if (!kIsWeb) {
        setState(() {}); // فقط لو داخل StatefulWidget
      }
    }
  } */

  Future<void> uploadProduct() async {
    if (productNameController.text.isEmpty ||
        productSizeController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        stockController.text.isEmpty ||
        mainCategory == null ||
        subCategory == null ||
        subSubCategory == null ||
        selectedImages.isEmpty ||
        selectedImages.any((img) => img['color'] == null) ||
        selectedSizes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى تعبئة جميع الحقول واختيار المقاسات والألوان'),
        ),
      );
      return;
    }

    final productId =
        FirebaseFirestore.instance.collection('products').doc().id;
    List<String> imageUrls = [];
    List<Map<String, dynamic>> uploadedImages = [];

    for (int i = 0; i < selectedImages.length; i++) {
      final image = selectedImages[i];
      final imageId = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance
          .ref()
          .child('products')
          .child('$productId/$imageId-${image['fileName']}');

      // final imageUrl = await ref.getDownloadURL(); //

      try {
        await ref.putData(image['fileBytes']);
        // مباشر لأننا نستخدم Uint8List
        final imageUrl = await ref.getDownloadURL();

        uploadedImages.add({'url': imageUrl, 'color': image['color']});
        imageUrls.add(imageUrl);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في رفع الصور')));
        return;
      }
    }

    await FirebaseFirestore.instance.collection('products').doc(productId).set({
      'productId': productId,
      'name': productNameController.text,
      'description': descriptionController.text,
      'price': double.parse(priceController.text),
      'stock': int.parse(stockController.text),
      'size': productSizeController.text,
      'availableSizes': selectedSizes,
      'mainCategory': mainCategory,
      'subCategory': subCategory,
      'subSubCategory': subSubCategory,
      'images': uploadedImages, // مع الألوان
      'imageUrls': imageUrls,
      'createdAt': FieldValue.serverTimestamp(),
      'sellerPhone': widget.sellerPhone,
      'status': 'pending',
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('تم رفع المنتج بنجاح')));

    setState(() {
      productNameController.clear();
      productSizeController.clear();
      priceController.clear();
      descriptionController.clear();
      stockController.clear();
      mainCategory = null;
      subCategory = null;
      subSubCategory = null;
      selectedImages.clear();
      selectedSizes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إضافة منتج')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: productNameController,
              decoration: InputDecoration(labelText: 'اسم المنتج'),
            ),
            TextFormField(
              controller: productSizeController,
              decoration: InputDecoration(labelText: 'المقاس الأساسي'),
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'السعر (بالدينار)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'وصف المنتج'),
              maxLines: 3,
            ),
            TextFormField(
              controller: stockController,
              decoration: InputDecoration(labelText: 'الكمية المتوفرة'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: mainCategory,
              decoration: InputDecoration(labelText: 'الفئة الرئيسية'),
              items:
                  mainCategories
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
              onChanged: (val) {
                setState(() {
                  mainCategory = val;
                  subCategory = null;
                  subSubCategory = null;
                  selectedSizes.clear();
                });
              },
            ),
            if (mainCategory != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    value: subCategory,
                    decoration: InputDecoration(labelText: 'الفئة الفرعية'),
                    items:
                        subCategories[mainCategory]!
                            .map(
                              (sub) => DropdownMenuItem(
                                value: sub,
                                child: Text(sub),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      setState(() {
                        subCategory = val;
                        subSubCategory = null;
                      });
                    },
                  ),
                  if (subCategory != null)
                    DropdownButtonFormField<String>(
                      value: subSubCategory,
                      decoration: InputDecoration(
                        labelText: 'الفئة الفرعية الثانية',
                      ),
                      items:
                          subSubCategories[subCategory]!
                              .map(
                                (subSub) => DropdownMenuItem(
                                  value: subSub,
                                  child: Text(subSub),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (val) => setState(() {
                            subSubCategory = val;
                          }),
                    ),

                  SizedBox(height: 10),
                  Text('المقاسات المتوفرة'),
                  Wrap(
                    spacing: 8,
                    children:
                        ([
                                  'نساء',
                                  'لانجري وملابس داخلية وبيتيه',
                                  'الأطفال',
                                  'الرجال',
                                ].contains(mainCategory)
                                ? clothingSizes
                                : [
                                  'المجوهرات والاكسسوارات',
                                  'الصحة والجمال',
                                  'الحقائب',

                                  'المطبخ والمعيشة',
                                  'المنسوجات المنزلية',
                                  'الألعاب',
                                  'السيارات',
                                  'الأجهزة المنزلية',
                                ].contains(mainCategory)
                                ? onesize
                                : mainCategory == 'أحذية'
                                ? shoeSizes
                                : [])
                            .map(
                              (size) => FilterChip(
                                label: Text(size),
                                selected: selectedSizes.contains(size),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedSizes.add(size);
                                    } else {
                                      selectedSizes.remove(size);
                                    }
                                  });
                                },
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: pickImages, child: Text('اختيار الصور')),
            SizedBox(height: 10),
            ...selectedImages.map((img) {
              int index = selectedImages.indexOf(img);
              return Row(
                children: [
                  Image.memory(
                    img['fileBytes'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: img['color'],
                      decoration: InputDecoration(labelText: 'اللون'),
                      items:
                          ['أحمر', 'أزرق', 'أخضر', 'أسود', 'أبيض']
                              .map(
                                (color) => DropdownMenuItem(
                                  value: color,
                                  child: Text(color),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedImages[index]['color'] = value;
                        });
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(onPressed: uploadProduct, child: Text('رفع المنتج')),
          ],
        ),
      ),
    );
  }
} */

// الكود الاصلي ----------------------
/*import 'dart:core';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UploadProductPage extends StatefulWidget {
  final String sellerPhone;

  const UploadProductPage({super.key, required this.sellerPhone});

  @override
  UploadProductPageState createState() => UploadProductPageState();
}

class UploadProductPageState extends State<UploadProductPage> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productSizeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? mainCategory;
  String? subCategory;
  String? subSubCategory;

  List<Map<String, dynamic>> selectedImages = [];
  List<String> selectedSizes = [];

  List<String> mainCategories = [
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

  Map<String, List<String>> subCategories = {
    'نساء': [
      'ملابس عربية',
      'ملابس علوية',
      'فساتين',
      'بناطيل وتنانير',
      'ملابس داخلية',
      'أطقم كاملة',
      'رياضية',
      'ملابس نوم',
      'ملابس موسمية',
    ],
    'لانجري وملابس داخلية وبيتيه': [
      'حمالات صدر',
      'سراويل داخلية',
      'لانجري',
      'بيجامات',
      'أطقم داخلية',
    ],
    'الأطفال': ['أولاد', 'بنات', 'بيبي'],
    'الحقائب': ['يدوية', 'ظهر', 'كتف', 'أحزمة وسط'],
    'الرجال': ['بناطيل', 'قمصان', 'بلايز', 'ملابس داخلية', 'أطقم', 'جاكيتات'],
    'الأحذية': ['نساء', 'رجال', 'أطفال'],
    'المجوهرات والاكسسوارات': ['مجوهرات', 'اكسسوارات', 'حقائب صغيرة'],
    'الصحة والجمال': ['مكياج', 'عناية بالبشرة', 'شعر', 'أدوات تجميل'],
    'المطبخ والمعيشة': ['أواني', 'أدوات', 'ديكور', 'منظمات'],
    'المنسوجات المنزلية': ['مفروشات', 'مناشف', 'ستائر', 'سجاد'],
    'الألعاب': ['تعليمية', 'تسلية', 'الكترونية'],
    'السيارات': ['اكسسوارات', 'تنظيف', 'أجهزة'],
    'الأجهزة المنزلية': ['مطبخية', 'تنظيف', 'تدفئة وتبريد'],
  };

  Map<String, List<String>> subSubCategories = {
    // نساء
    'ملابس عربية': [
      'فساتين عربية',
      'قفاطين',
      'جلابيات',
      'عبايات',
      'ملابس صلاة',
    ],
    'ملابس علوية': ['بلايز نسائية', 'تي شيرت', 'سترات نسائية'],
    'فساتين': ['سهرة', 'صيفية', 'رسمية', 'كاجوال'],
    'بناطيل وتنانير': ['بناطيل قماش', 'جينز', 'تنانير'],
    'ملابس داخلية': ['حمالات صدر', 'سراويل داخلية', 'بيجامات', 'لانجري'],
    'أطقم كاملة': ['أطقم رسمية', 'أطقم يومية'],
    'رياضية': ['بناطيل رياضية', 'بلايز رياضية', 'أطقم رياضية'],
    'ملابس نوم': ['بيجامات طويلة', 'بيجامات قصيرة'],
    'ملابس موسمية': ['معاطف', 'جاكيتات', 'كنزات صوف', 'ملابس صيفية'],

    // لانجري
    'حمالات صدر': ['بأسلاك', 'من غير أسلاك', 'رياضية', 'للرضاعة'],
    'سراويل داخلية': ['قصة عالية', 'قصة منخفضة', 'بكيني', 'شورت'],
    'لانجري': ['بودي', 'ستاتين', 'طقم لانجري'],
    'بيجامات': ['شورت', 'بناطيل طويلة', 'فساتين نوم'],
    'أطقم داخلية': ['2 قطعة', '3 قطعة'],

    // الأطفال
    'أولاد': ['تيشيرت', 'بنطال', 'شورت', 'بدلة', 'بيجاما'],
    'بنات': ['فساتين', 'بيجامات', 'بلايز', 'بناطيل', 'أطقم'],
    'بيبي': ['ملابس مواليد', 'أطقم حديثي الولادة', 'ملابس داخلية للأطفال'],

    // الحقائب
    'يدوية': ['صغيرة', 'كبيرة'],
    'ظهر': ['مدرسية', 'رياضية'],
    'كتف': ['جلد', 'قماش'],
    'أحزمة وسط': ['أنيقة', 'رياضية'],

    // الرجال
    'بناطيل': ['جينز', 'قماش', 'رياضية', 'شورت'],
    'قمصان': ['رسمية', 'كاجوال'],
    'بلايز': ['تي شيرت', 'كنزات', 'سترات'],
    'ملابس داخلية': ['سراويل داخلية', 'بيجاما', 'فانيلة'],
    'أطقم': ['بدلة رسمية', 'أطقم رياضية'],
    'جاكيتات': ['شتوية', 'خريفية'],
    // الأحذية
    'نساء': ['كعب عالي', 'مسطحة', 'صنادل', 'رياضية'],
    'رجال': ['رسمية', 'رياضية', 'كاجوال'],
    'أطفال': ['مدرسية', 'رياضية', 'صنادل'],

    // المجوهرات والاكسسوارات
    'مجوهرات': ['خواتم', 'سلاسل', 'أقراط', 'أساور'],
    'اكسسوارات': ['نظارات شمسية', 'ساعات', 'قبعات', 'أوشحة'],
    'حقائب صغيرة': ['محفظة', 'حقيبة يد صغيرة'],

    // الصحة والجمال
    'مكياج': ['أحمر شفاه', 'كحل', 'بودرة', 'مكياج عيون'],
    'عناية بالبشرة': ['مرطبات', 'منظفات', 'واقي شمس'],
    'شعر': ['شامبو', 'بلسم', 'زيوت', 'أجهزة تصفيف'],
    'أدوات تجميل': ['فرش', 'مقص أظافر', 'مرايا'],

    // المطبخ والمعيشة
    'أواني': ['قدور', 'مقالي', 'صحون'],
    'أدوات': ['ملاعق', 'سكاكين', 'مقاشط'],
    'ديكور': ['شموع', 'مزهرية', 'إضاءة'],
    'منظمات': ['منظمات أدراج', 'صناديق تخزين'],

    // المنسوجات المنزلية
    'مفروشات': ['شراشف', 'بطانيات', 'مخدات'],
    'مناشف': ['مناشف حمام', 'مناشف مطبخ'],
    'ستائر': ['غرف نوم', 'صالونات'],
    'سجاد': ['صغير', 'متوسط', 'كبير'],

    // الألعاب
    'تعليمية': ['ألعاب تركيب', 'كتب تلوين'],
    'تسلية': ['عرائس', 'سيارات', 'كرات'],
    'الكترونية': ['ألعاب فيديو', 'أجهزة لعب'],

    // السيارات
    'اكسسوارات': ['حامل جوال', 'فرش أرضية', 'ستائر شمسية'],
    'تنظيف': ['منظف داخلي', 'خارجي', 'مماسح'],
    'أجهزة': ['شاحن سيارة', 'كاميرا أمامية', 'حساسات'],

    // الأجهزة المنزلية
    'مطبخية': ['خلاط', 'مايكرويف', 'محضرة طعام'],
    'تنظيف': ['مكنسة كهربائية', 'آلة تنظيف بالبخار'],
    'تدفئة وتبريد': ['دفاية', 'مروحة', 'مكيف متنقل'],
  };

  final List<String> clothingSizes = ['S', 'M', 'L', 'XL', 'XXL'];
  final List<String> shoeSizes = ['38', '39', '40', '41', '42', '43'];
  final List<String> onesize = ['one size (مقاس واحد)'];

  Future<void> pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      for (var file in result.files) {
        selectedImages.add({
          'fileBytes': file.bytes,
          'fileName': file.name,
          'color': null,
        });
      }
      setState(() {});
    }
  }

  Future<void> uploadProduct() async {
    if (productNameController.text.isEmpty ||
        productSizeController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        stockController.text.isEmpty ||
        mainCategory == null ||
        subCategory == null ||
        subSubCategory == null ||
        selectedImages.isEmpty ||
        selectedImages.any((img) => img['color'] == null) ||
        selectedSizes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى تعبئة جميع الحقول واختيار المقاسات والألوان'),
        ),
      );
      return;
    }

    String productId = Uuid().v4();
    List<Map<String, dynamic>> uploadedImages = [];

    for (var img in selectedImages) {
      final ref = storage.ref().child(
        'products/$productId/${DateTime.now().millisecondsSinceEpoch}_${img['fileName']}',
      );
      await ref.putData(img['fileBytes']);
      final url = await ref.getDownloadURL();
      uploadedImages.add({'url': url, 'color': img['color']});
    }

    await firestore.collection('products').doc(productId).set({
      'productId': productId,
      'name': productNameController.text,
      'description': descriptionController.text,
      'price': double.parse(priceController.text),
      'stock': int.parse(stockController.text),
      'size': productSizeController.text,
      'availableSizes': selectedSizes,
      'mainCategory': mainCategory,
      'subCategory': subCategory,
      'subSubCategory': subSubCategory,
      'images': uploadedImages,
      'createdAt': FieldValue.serverTimestamp(),
      'sellerPhone': widget.sellerPhone,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('تم رفع المنتج بنجاح')));

    setState(() {
      productNameController.clear();
      productSizeController.clear();
      priceController.clear();
      descriptionController.clear();
      stockController.clear();
      mainCategory = null;
      subCategory = null;
      subSubCategory = null;
      selectedImages.clear();
      selectedSizes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إضافة منتج')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: productNameController,
              decoration: InputDecoration(labelText: 'اسم المنتج'),
            ),
            TextFormField(
              controller: productSizeController,
              decoration: InputDecoration(labelText: 'المقاس الأساسي'),
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'السعر (بالدينار)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'وصف المنتج'),
              maxLines: 3,
            ),
            TextFormField(
              controller: stockController,
              decoration: InputDecoration(labelText: 'الكمية المتوفرة'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: mainCategory,
              decoration: InputDecoration(labelText: 'الفئة الرئيسية'),
              items:
                  mainCategories
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
              onChanged: (val) {
                setState(() {
                  mainCategory = val;
                  subCategory = null;
                  subSubCategory = null;
                  selectedSizes.clear();
                });
              },
            ),
            if (mainCategory != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    value: subCategory,
                    decoration: InputDecoration(labelText: 'الفئة الفرعية'),
                    items:
                        subCategories[mainCategory]!
                            .map(
                              (sub) => DropdownMenuItem(
                                value: sub,
                                child: Text(sub),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      setState(() {
                        subCategory = val;
                        subSubCategory = null;
                      });
                    },
                  ),
                  if (subCategory != null)
                    DropdownButtonFormField<String>(
                      value: subSubCategory,
                      decoration: InputDecoration(
                        labelText: 'الفئة الفرعية الثانية',
                      ),
                      items:
                          subSubCategories[subCategory]!
                              .map(
                                (subSub) => DropdownMenuItem(
                                  value: subSub,
                                  child: Text(subSub),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (val) => setState(() {
                            subSubCategory = val;
                          }),
                    ),

                  SizedBox(height: 10),
                  Text('المقاسات المتوفرة'),
                  Wrap(
                    spacing: 8,
                    children:
                        ([
                                  'نساء',
                                  'لانجري وملابس داخلية وبيتيه',
                                  'الأطفال',
                                  'الرجال',
                                ].contains(mainCategory)
                                ? clothingSizes
                                : [
                                  'المجوهرات والاكسسوارات',
                                  'الصحة والجمال',
                                  'الحقائب',

                                  'المطبخ والمعيشة',
                                  'المنسوجات المنزلية',
                                  'الألعاب',
                                  'السيارات',
                                  'الأجهزة المنزلية',
                                ].contains(mainCategory)
                                ? onesize
                                : mainCategory == 'أحذية'
                                ? shoeSizes
                                : [])
                            .map(
                              (size) => FilterChip(
                                label: Text(size),
                                selected: selectedSizes.contains(size),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedSizes.add(size);
                                    } else {
                                      selectedSizes.remove(size);
                                    }
                                  });
                                },
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: pickImages, child: Text('اختيار الصور')),
            SizedBox(height: 10),
            ...selectedImages.map((img) {
              int index = selectedImages.indexOf(img);
              return Row(
                children: [
                  Image.memory(
                    img['fileBytes'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: img['color'],
                      decoration: InputDecoration(labelText: 'اللون'),
                      items:
                          ['أحمر', 'أزرق', 'أخضر', 'أسود', 'أبيض']
                              .map(
                                (color) => DropdownMenuItem(
                                  value: color,
                                  child: Text(color),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedImages[index]['color'] = value;
                        });
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(onPressed: uploadProduct, child: Text('رفع المنتج')),
          ],
        ),
      ),
    );
  }
}
*/
