import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerLoginPage extends StatefulWidget {
  @override
  _SellerLoginPageState createState() => _SellerLoginPageState();
}

class _SellerLoginPageState extends State<SellerLoginPage> {
  final phoneController = TextEditingController(); // بدون +962
  final passwordController = TextEditingController();
  bool isLoading = false;

  String get formattedPhone => '+962${phoneController.text.trim()}';

  void loginSeller() async {
    final phone = formattedPhone;
    final password = passwordController.text.trim();

    if (phoneController.text.trim().isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('الرجاء تعبئة جميع الحقول')));
      return;
    }

    setState(() => isLoading = true);

    try {
      final sellerSnapshot =
          await FirebaseFirestore.instance
              .collection('sellers')
              .where('phone', isEqualTo: phone)
              .limit(1)
              .get();

      if (sellerSnapshot.docs.isEmpty) {
        throw 'لا يوجد حساب بهذا الرقم';
      }

      final data = sellerSnapshot.docs.first.data();
      if (data['password'] != password) {
        throw 'كلمة المرور غير صحيحة';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تم تسجيل الدخول بنجاح')));

      Navigator.pushNamed(
        context,
        '/seller_home',
        arguments: {'sellerPhone': phone},
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => isLoading = false);
  }

  void showPasswordResetDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController phoneResetController =
            TextEditingController();

        return AlertDialog(
          title: Text('استعادة كلمة المرور'),
          content: TextField(
            controller: phoneResetController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: 'أدخل رقم الهاتف بدون +962'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                final entered = phoneResetController.text.trim();
                if (entered.isEmpty) return;

                final enteredPhone = '+962$entered';

                final snapshot =
                    await FirebaseFirestore.instance
                        .collection('sellers')
                        .where('phone', isEqualTo: enteredPhone)
                        .limit(1)
                        .get();

                Navigator.pop(context);

                if (snapshot.docs.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('لم يتم العثور على الحساب')),
                  );
                  return;
                }

                final password = snapshot.docs.first.data()['password'];
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('كلمة المرور الخاصة بك: $password')),
                );
              },
              child: Text('استعادة'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تسجيل دخول البائع')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'رقم الهاتف (بدون +962)'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'كلمة المرور'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: loginSeller,
                  child: Text('تسجيل الدخول'),
                ),
            SizedBox(height: 8),
            TextButton(
              onPressed: showPasswordResetDialog,
              child: Text('نسيت كلمة المرور؟'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/SellerRegisterPage');
              },
              child: Text('ليس لديك حساب؟ سجل الآن'),
            ),
          ],
        ),
      ),
    );
  }
}

/* import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SellerPage extends StatefulWidget {
  @override
  _SellerPageState createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();
  final TextEditingController productPriceController = TextEditingController();

  String? selectedGovernorate;
  String? selectedProductMainCategory;
  String? selectedProductSubCategory;
  String? selectedProductSubSubCategory;

  final List<File> selectedImages = [];
  final List<String> selectedColors = [];
  final List<String> selectedSizes = [];
  final List<Map<String, dynamic>> addedProducts = [];

  final List<String> colorOptions = [
    'أحمر',
    'أزرق',
    'أخضر',
    'أسود',
    'أبيض',
    'وردي',
  ];

  final Map<String, List<String>> sizeOptions = {
    'النساء': ['XS', 'S', 'M', 'L', 'XL'],
    'الرجال': ['XS', 'S', 'M', 'L', 'XL'],
    'الأحذية': ['36', '37', '38', '39', '40', '41', '42', '43'],
    'الأطفال': ['1 سنة', '2 سنة', '3 سنة', '4 سنة', '5 سنة'],
  };

  final List<String> mainCategories = [
    'النساء',
    'اللانجري والملابس الداخلية',
    'الرجال',
    'الأطفال',
    'الأحذية',
    'الحقائب',
    'المجوهرات والإكسسوارات',
    'الصحة والجمال',
    'المنسوجات المنزلية',
    'المطبخ والمعيشة',
    'الأجهزة المنزلية',
    'الألعاب',
    'السيارات',
  ];

  final List<String> governorates = [
    'عمان',
    'إربد',
    'الزرقاء',
    'العقبة',
    'المفرق',
    'جرش',
    'عجلون',
    'الكرك',
    'الطفيلة',
    'معان',
    'البلقاء',
    'مأدبا',
  ];

  final Map<String, Map<String, List<String>>> categoryHierarchy = {
    'نساء': {
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
    },
    'لانجري وملابس داخلية وبيتيه': {
      'حمالات صدر': ['بأسلاك', 'من غير أسلاك', 'رياضية', 'للرضاعة'],
      'سراويل داخلية': ['قصة عالية', 'قصة منخفضة', 'بكيني', 'شورت'],
      'لانجري': ['بودي', 'ستاتين', 'طقم لانجري'],
      'بيجامات': ['شورت', 'بناطيل طويلة', 'فساتين نوم'],
      'أطقم داخلية': ['2 قطعة', '3 قطعة'],
    },
    'الأطفال': {
      'أولاد': ['تيشيرت', 'بنطال', 'شورت', 'بدلة', 'بيجاما'],
      'بنات': ['فساتين', 'بيجامات', 'بلايز', 'بناطيل', 'أطقم'],
      'بيبي': ['ملابس مواليد', 'أطقم حديثي الولادة', 'ملابس داخلية للأطفال'],
    },
    'الحقائب': {
      'يدوية': ['صغيرة', 'كبيرة'],
      'ظهر': ['مدرسية', 'رياضية'],
      'كتف': ['جلد', 'قماش'],
      'أحزمة وسط': ['أنيقة', 'رياضية'],
    },
    'الرجال': {
      'بناطيل': ['جينز', 'قماش', 'رياضية', 'شورت'],
      'قمصان': ['رسمية', 'كاجوال'],
      'بلايز': ['تي شيرت', 'كنزات', 'سترات'],
      'ملابس داخلية': ['سراويل داخلية', 'بيجاما', 'فانيلة'],
      'أطقم': ['بدلة رسمية', 'أطقم رياضية'],
      'جاكيتات': ['شتوية', 'خريفية'],
    },
    'الأحذية': {
      'نساء': ['كعب عالي', 'مسطحة', 'صنادل', 'رياضية'],
      'رجال': ['رسمية', 'رياضية', 'كاجوال'],
      'أطفال': ['مدرسية', 'رياضية', 'صنادل'],
    },
    'المجوهرات والاكسسوارات': {
      'مجوهرات': ['خواتم', 'سلاسل', 'أقراط', 'أساور'],
      'اكسسوارات': ['نظارات شمسية', 'ساعات', 'قبعات', 'أوشحة'],
      'حقائب صغيرة': ['محفظة', 'حقيبة يد صغيرة'],
    },
    'الصحة والجمال': {
      'مكياج': ['أحمر شفاه', 'كحل', 'بودرة', 'مكياج عيون'],
      'عناية بالبشرة': ['مرطبات', 'منظفات', 'واقي شمس'],
      'شعر': ['شامبو', 'بلسم', 'زيوت', 'أجهزة تصفيف'],
      'أدوات تجميل': ['فرش', 'مقص أظافر', 'مرايا'],
    },
    'المطبخ والمعيشة': {
      'أواني': ['قدور', 'مقالي', 'صحون'],
      'أدوات': ['ملاعق', 'سكاكين', 'مقاشط'],
      'ديكور': ['شموع', 'مزهرية', 'إضاءة'],
      'منظمات': ['منظمات أدراج', 'صناديق تخزين'],
    },
    'المنسوجات المنزلية': {
      'مفروشات': ['شراشف', 'بطانيات', 'مخدات'],
      'مناشف': ['مناشف حمام', 'مناشف مطبخ'],
      'ستائر': ['غرف نوم', 'صالونات'],
      'سجاد': ['صغير', 'متوسط', 'كبير'],
    },
    'الألعاب': {
      'تعليمية': ['ألعاب تركيب', 'كتب تلوين'],
      'تسلية': ['عرائس', 'سيارات', 'كرات'],
      'الكترونية': ['ألعاب فيديو', 'أجهزة لعب'],
    },
    'السيارات': {
      'اكسسوارات': ['حامل جوال', 'فرش أرضية', 'ستائر شمسية'],
      'تنظيف': ['منظف داخلي', 'خارجي', 'مماسح'],
      'أجهزة': ['شاحن سيارة', 'كاميرا أمامية', 'حساسات'],
    },
    'الأجهزة المنزلية': {
      'مطبخية': ['خلاط', 'مايكرويف', 'محضرة طعام'],
      'تنظيف': ['مكنسة كهربائية', 'آلة تنظيف بالبخار'],
      'تدفئة وتبريد': ['دفاية', 'مروحة', 'مكيف متنقل'],
    },
    // أكمل حسب الحاجة
  };

  List<String> getSubCategories(String? main) {
    if (main != null && categoryHierarchy.containsKey(main)) {
      return categoryHierarchy[main]!.keys.toList();
    }
    return [];
  }

  List<String> getSubSubCategories(String? main, String? sub) {
    if (main != null && sub != null) {
      return categoryHierarchy[main]?[sub] ?? [];
    }
    return [];
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty && selectedImages.length + images.length <= 4) {
      setState(() {
        selectedImages.addAll(images.map((x) => File(x.path)));
      });
    }
  }

  void addProduct() {
    if (productNameController.text.isEmpty ||
        productPriceController.text.isEmpty ||
        selectedImages.isEmpty ||
        selectedProductMainCategory == null ||
        selectedProductSubCategory == null ||
        selectedProductSubSubCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('يرجى تعبئة جميع بيانات المنتج.')));
      return;
    }

    addedProducts.add({
      'name': productNameController.text,
      'description': productDescriptionController.text,
      'price': productPriceController.text,
      'images': List<File>.from(selectedImages),
      'colors': List<String>.from(selectedColors),
      'sizes': List<String>.from(selectedSizes),
      'category':
          '$selectedProductMainCategory > $selectedProductSubCategory > $selectedProductSubSubCategory',
    });

    setState(() {
      productNameController.clear();
      productDescriptionController.clear();
      productPriceController.clear();
      selectedProductMainCategory = null;
      selectedProductSubCategory = null;
      selectedProductSubSubCategory = null;
      selectedImages.clear();
      selectedColors.clear();
      selectedSizes.clear();
    });

    Navigator.pop(context);
  }

  void showAddProductSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: StatefulBuilder(
              builder: (context, setSheetState) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: productNameController,
                          decoration: InputDecoration(labelText: 'اسم المنتج'),
                        ),
                        TextField(
                          controller: productDescriptionController,
                          decoration: InputDecoration(labelText: 'وصف المنتج'),
                        ),
                        TextField(
                          controller: productPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'السعر بالدينار',
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedProductMainCategory,
                          items:
                              mainCategories
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setSheetState(() {
                              selectedProductMainCategory = value;
                              selectedProductSubCategory = null;
                              selectedProductSubSubCategory = null;
                              selectedSizes.clear();
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'القسم الرئيسي',
                          ),
                        ),
                        if (selectedProductMainCategory != null)
                          DropdownButtonFormField<String>(
                            value: selectedProductSubCategory,
                            items:
                                getSubCategories(selectedProductMainCategory)
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(c),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              setSheetState(() {
                                selectedProductSubCategory = value;
                                selectedProductSubSubCategory = null;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'القسم الفرعي',
                            ),
                          ),
                        if (selectedProductSubCategory != null)
                          DropdownButtonFormField<String>(
                            value: selectedProductSubSubCategory,
                            items:
                                getSubSubCategories(
                                      selectedProductMainCategory,
                                      selectedProductSubCategory,
                                    )
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(c),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                (value) => setSheetState(
                                  () => selectedProductSubSubCategory = value,
                                ),
                            decoration: InputDecoration(
                              labelText: 'القسم الفرعي الفرعي',
                            ),
                          ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children:
                              colorOptions.map((color) {
                                return FilterChip(
                                  label: Text(color),
                                  selected: selectedColors.contains(color),
                                  onSelected:
                                      (selected) => setSheetState(() {
                                        selected
                                            ? selectedColors.add(color)
                                            : selectedColors.remove(color);
                                      }),
                                );
                              }).toList(),
                        ),
                        if (selectedProductMainCategory != null &&
                            sizeOptions.containsKey(
                              selectedProductMainCategory,
                            ))
                          Wrap(
                            spacing: 8,
                            children:
                                sizeOptions[selectedProductMainCategory]!.map((
                                  size,
                                ) {
                                  return FilterChip(
                                    label: Text(size),
                                    selected: selectedSizes.contains(size),
                                    onSelected:
                                        (selected) => setSheetState(() {
                                          selected
                                              ? selectedSizes.add(size)
                                              : selectedSizes.remove(size);
                                        }),
                                  );
                                }).toList(),
                          ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await pickImages();
                            setSheetState(() {});
                          },
                          icon: Icon(Icons.image),
                          label: Text('اختيار صور (حد أقصى 4)'),
                        ),
                        if (selectedImages.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            children:
                                selectedImages
                                    .map(
                                      (img) => Image.file(
                                        img,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    .toList(),
                          ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: addProduct,
                          child: Text('إضافة المنتج'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
    );
  }

  void submitProducts() {
    if (addedProducts.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('لم تقم بإضافة أي منتج.')));
      return;
    }
    print('--- إرسال البيانات ---');
    print('الاسم: ${fullNameController.text}');
    print('الهاتف: ${phoneController.text}');
    print('المتجر: ${storeNameController.text}');
    print('المحافظة: $selectedGovernorate');
    print('المنطقة: ${areaController.text}');
    print('عدد المنتجات: ${addedProducts.length}');
    for (var product in addedProducts) {
      print(product);
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('تم إرسال البيانات للمراجعة.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('أنا بائع')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildSellerInfoCard(),
            if (addedProducts.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                'المنتجات المضافة',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: addedProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final product = addedProducts[index];
                  final image =
                      product['images'].isNotEmpty
                          ? Image.file(product['images'][0], fit: BoxFit.cover)
                          : Icon(Icons.image);

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 6),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  child: image,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap:
                                      () => setState(
                                        () => addedProducts.removeAt(index),
                                      ),
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${product['price']} د.أ',
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitProducts,
                child: Text('إرسال البيانات للمراجعة'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildSellerInfoCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'الاسم الكامل'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'رقم الهاتف'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: storeNameController,
              decoration: InputDecoration(labelText: 'اسم المتجر'),
            ),
            DropdownButtonFormField<String>(
              value: selectedGovernorate,
              decoration: InputDecoration(labelText: 'المحافظة'),
              items:
                  governorates
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
              onChanged: (value) => setState(() => selectedGovernorate = value),
            ),
            TextField(
              controller: areaController,
              decoration: InputDecoration(labelText: 'المنطقة'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: showAddProductSheet,
              icon: Icon(Icons.add),
              label: Text('إضافة منتج جديد'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
} */
