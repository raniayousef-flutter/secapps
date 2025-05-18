import 'package:flutter/material.dart';
import 'otp_verification.dart'; // صفحة تحقق الكود

class RegisterPhonePage extends StatefulWidget {
  @override
  _RegisterPhonePageState createState() => _RegisterPhonePageState();
}

class _RegisterPhonePageState extends State<RegisterPhonePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String selectedGovernorate = 'عمان';
  List<String> governorates = ['عمان', 'الزرقاء', 'إربد', 'العقبة', 'السلط'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إنشاء حساب')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'اسم المستخدم'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'رقم الهاتف الأردني'),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedGovernorate,
              items:
                  governorates.map((value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedGovernorate = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'المحافظة'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => OTPVerificationPage(
                            phoneNumber: phoneController.text.trim(),
                            userName: nameController.text.trim(),
                            governorate: selectedGovernorate,
                            password: '',
                          ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('يرجى تعبئة جميع الحقول')),
                  );
                }
              },
              child: Text('إرسال كود التحقق'),
            ),
          ],
        ),
      ),
    );
  }
}
