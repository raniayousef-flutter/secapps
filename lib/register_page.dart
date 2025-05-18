import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'otp_verification.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController phonePasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  String selectedCity = 'عمان';
  bool useEmail = true;
  bool isLoading = false;

  final List<String> jordanianCities = [
    'عمان',
    'الزرقاء',
    'إربد',
    'العقبة',
    'مادبا',
    'السلط',
    'الكرك',
    'معان',
    'الطفيلة',
    'جرش',
    'عجلون',
    'المفرق',
  ];

  Future<void> registerWithEmail() async {
    setState(() => isLoading = true);
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final name = nameController.text.trim();

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
            'email': email,
            'name': name,
            'phone': null,
            'password': password,
            'city': selectedCity,
            'createdAt': FieldValue.serverTimestamp(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إرسال رابط لتأكيد البريد الإلكتروني')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء إنشاء الحساب: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void registerWithPhone() async {
    final localPhone = phoneController.text.trim();
    final name = nameController.text.trim();
    final password = phonePasswordController.text.trim();

    if (!RegExp(r'^(079|078|077)\d{7}$').hasMatch(localPhone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('أدخل رقم هاتف أردني صحيح (مثال: 079xxxxxxx)')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('كلمة المرور يجب أن تكون 6 أحرف على الأقل')),
      );
      return;
    }

    final fullPhone = '+962' + localPhone.substring(1);

    setState(() => isLoading = true);

    if (kIsWeb) {
      try {
        final confirmationResult = await FirebaseAuth.instance
            .signInWithPhoneNumber(fullPhone);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => OTPVerificationPage(
                  confirmationResult: confirmationResult,
                  phoneNumber: fullPhone,
                  userName: name,
                  governorate: selectedCity,
                  password: password,
                ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل إرسال كود التحقق: ${e.toString()}')),
        );
        setState(() => isLoading = false);
      }
    } else {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullPhone,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('فشل التحقق: ${e.message}')));
          setState(() => isLoading = false);
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => OTPVerificationPage(
                    verificationId: verificationId,
                    phoneNumber: fullPhone,
                    userName: name,
                    governorate: selectedCity,
                    password: password,
                  ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إنشاء حساب')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ToggleButtons(
                        isSelected: [useEmail, !useEmail],
                        onPressed:
                            (index) => setState(() => useEmail = index == 0),
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("بريد إلكتروني"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("رقم هاتف"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'الاسم الكامل'),
                      ),
                      const SizedBox(height: 10),
                      if (useEmail) ...[
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'البريد الإلكتروني',
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'كلمة المرور'),
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('+962'),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'رقم الهاتف (مثل: 079xxxxxxx)',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: phonePasswordController,
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'كلمة المرور'),
                        ),
                      ],
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedCity,
                        decoration: InputDecoration(labelText: 'المدينة'),
                        items:
                            jordanianCities
                                .map(
                                  (city) => DropdownMenuItem(
                                    value: city,
                                    child: Text(city),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) => setState(() => selectedCity = value!),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed:
                            useEmail ? registerWithEmail : registerWithPhone,
                        child: Text('تسجيل حساب'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}



/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> register() async {
    setState(() => isLoading = true);
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إرسال رابط التحقق إلى بريدك الإلكتروني')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء إنشاء الحساب: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إنشاء حساب')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'كلمة المرور'),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: register,
                      child: Text('تسجيل حساب'),
                    ),
                  ],
                ),
              ),
    );
  }
}
*/