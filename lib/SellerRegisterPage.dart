import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerRegisterPage extends StatefulWidget {
  @override
  _SellerRegisterPageState createState() => _SellerRegisterPageState();
}

class _SellerRegisterPageState extends State<SellerRegisterPage> {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController(); // بدون +962
  final passwordController = TextEditingController();
  final storeNameController = TextEditingController();
  final areaController = TextEditingController();
  final codeController = TextEditingController();

  String? selectedGovernorate;
  String? verificationId;
  bool codeSent = false;
  bool isVerifying = false;
  bool phoneVerified = false;

  final governorates = [
    'عمان',
    'الزرقاء',
    'إربد',
    'العقبة',
    'المفرق',
    'الكرك',
    'الطفيلة',
  ];

  String get formattedPhone => '+962${phoneController.text.trim()}';

  @override
  void initState() {
    super.initState();
    phoneController.addListener(
      () => setState(() {}),
    ); // متابعة التغيير لتحديث الزر
  }

  Future<void> sendVerificationCode() async {
    final phone = phoneController.text.trim();
    if (phone.length != 9) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('يرجى إدخال رقم مكون من 9 أرقام')));
      return;
    }

    setState(() => isVerifying = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: formattedPhone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        setState(() {
          phoneVerified = true;
          isVerifying = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم التحقق تلقائيًا من الرقم')));
      },
      verificationFailed: (e) {
        setState(() => isVerifying = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('فشل التحقق: ${e.message}')));
      },
      codeSent: (verId, _) {
        setState(() {
          verificationId = verId;
          codeSent = true;
          isVerifying = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم إرسال رمز التحقق')));
      },
      codeAutoRetrievalTimeout: (verId) {
        verificationId = verId;
      },
    );
  }

  Future<void> verifyCode() async {
    final smsCode = codeController.text.trim();
    if (verificationId == null || smsCode.isEmpty) return;

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() => phoneVerified = true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تم التحقق من الرقم بنجاح')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل التحقق: رمز خاطئ')));
    }
  }

  Future<void> registerSeller() async {
    final fullName = fullNameController.text.trim();
    final phone = formattedPhone;
    final password = passwordController.text.trim();
    final storeName = storeNameController.text.trim();
    final area = areaController.text.trim();
    final city = selectedGovernorate;

    if ([
      fullName,
      phone,
      password,
      storeName,
      area,
      city,
    ].any((e) => e == null || e.isEmpty)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('الرجاء تعبئة جميع الحقول')));
      return;
    }

    if (!phoneVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى التحقق من رقم الهاتف أولاً')),
      );
      return;
    }

    final existing =
        await FirebaseFirestore.instance
            .collection('sellers')
            .where('phone', isEqualTo: phone)
            .get();

    if (existing.docs.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('رقم الهاتف مسجل مسبقًا')));
      return;
    }

    await FirebaseFirestore.instance.collection('sellers').add({
      'fullName': fullName,
      'phone': phone,
      'password': password,
      'storeName': storeName,
      'city': city,
      'area': area,
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('✅ تم إنشاء الحساب بنجاح')));

    fullNameController.clear();
    phoneController.clear();
    passwordController.clear();
    storeNameController.clear();
    areaController.clear();
    codeController.clear();

    setState(() {
      selectedGovernorate = null;
      phoneVerified = false;
      codeSent = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تسجيل حساب بائع')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'الاسم الكامل'),
            ),
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
              onChanged: (val) => setState(() => selectedGovernorate = val),
            ),
            TextField(
              controller: areaController,
              decoration: InputDecoration(labelText: 'المنطقة'),
            ),
            SizedBox(height: 16),
            isVerifying
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed:
                      phoneController.text.trim().length == 9
                          ? sendVerificationCode
                          : null,
                  child: Text('📲 إرسال رمز التحقق'),
                ),
            if (codeSent && !phoneVerified) ...[
              TextField(
                controller: codeController,
                decoration: InputDecoration(labelText: 'رمز التحقق'),
              ),
              ElevatedButton(
                onPressed: verifyCode,
                child: Text('✅ تأكيد الرمز'),
              ),
            ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: registerSeller,
              child: Text('📦 إنشاء الحساب'),
            ),
          ],
        ),
      ),
    );
  }
}
