import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'services/database_service.dart';

class OTPVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String userName;
  final String governorate;
  final String password;

  final String? verificationId; // للموبايل
  final ConfirmationResult? confirmationResult; // للويب

  OTPVerificationPage({
    required this.phoneNumber,
    required this.userName,
    required this.governorate,
    required this.password,
    this.verificationId,
    this.confirmationResult,
  });

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  Future<void> verifyOTP() async {
    setState(() => isLoading = true);

    try {
      final otp = otpController.text.trim();

      UserCredential userCredential;

      if (kIsWeb) {
        // تحقق للويب
        userCredential = await widget.confirmationResult!.confirm(otp);
      } else {
        // تحقق للموبايل
        final credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId!,
          smsCode: otp,
        );
        userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
      }

      final user = userCredential.user;
      if (user != null) {
        await saveUserData(user.uid);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      } else {
        throw Exception('فشل تسجيل الدخول، المستخدم غير موجود');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('كود خاطئ أو انتهت صلاحيته')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> saveUserData(String uid) async {
    await DatabaseService().saveUserData(
      uid: uid,
      name: widget.userName,
      email: '',
      phone: widget.phoneNumber,
      governorate: widget.governorate,
      password: widget.password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تأكيد رقم الهاتف')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('أدخل كود التحقق المرسل إلى ${widget.phoneNumber}'),
                    SizedBox(height: 20),
                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'كود التحقق'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: verifyOTP,
                      child: Text('تأكيد الكود'),
                    ),
                  ],
                ),
              ),
    );
  }
}

/*class OTPVerificationPage extends StatefulWidget {
  final String phoneNumber;

  OTPVerificationPage({required this.phoneNumber});

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController otpController = TextEditingController();
  String? verificationId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    sendOTP();
  }

  Future<void> sendOTP() async {
    setState(() => isLoading = true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // التحقق التلقائي (اندرويد فقط)
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل إرسال الكود: ${e.message}')),
        );
        setState(() => isLoading = false);
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          verificationId = verId;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم إرسال كود التحقق')),
        );
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> verifyOTP() async {
    setState(() => isLoading = true);
    try {
      final otp = otpController.text.trim();
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('كود خاطئ أو انتهت صلاحيته')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تأكيد رقم الهاتف')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('أدخل كود التحقق المرسل إلى ${widget.phoneNumber}'),
                  SizedBox(height: 20),
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'كود التحقق',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: verifyOTP,
                    child: Text('تأكيد الكود'),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: sendOTP,
                    child: Text('إعادة إرسال الكود'),
                  ),
                ],
              ),
            ),
    );
  }
}
*/
