import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerForgotPasswordPage extends StatefulWidget {
  @override
  _SellerForgotPasswordPageState createState() =>
      _SellerForgotPasswordPageState();
}

class _SellerForgotPasswordPageState extends State<SellerForgotPasswordPage> {
  final phoneController = TextEditingController();
  final newPasswordController = TextEditingController();
  String? sellerDocId;
  bool phoneFound = false;
  bool isLoading = false;

  Future<void> checkPhoneExists() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('يرجى إدخال رقم الهاتف')));
      return;
    }

    setState(() => isLoading = true);

    final query =
        await FirebaseFirestore.instance
            .collection('sellers')
            .where('phone', isEqualTo: phone)
            .get();

    if (query.docs.isNotEmpty) {
      setState(() {
        phoneFound = true;
        sellerDocId = query.docs.first.id;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('رقم الهاتف غير موجود')));
    }

    setState(() => isLoading = false);
  }

  Future<void> updatePassword() async {
    final newPassword = newPasswordController.text.trim();

    if (newPassword.isEmpty || sellerDocId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('يرجى إدخال كلمة مرور جديدة')));
      return;
    }

    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(sellerDocId)
        .update({'password': newPassword});

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('تم تحديث كلمة المرور بنجاح')));

    Navigator.pop(context); // الرجوع لصفحة تسجيل الدخول
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('نسيت كلمة المرور')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'رقم الهاتف'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: checkPhoneExists,
                  child: Text('🔍 تحقق من الرقم'),
                ),
            if (phoneFound) ...[
              SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                decoration: InputDecoration(labelText: 'كلمة المرور الجديدة'),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: updatePassword,
                child: Text('🔐 تحديث كلمة المرور'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
