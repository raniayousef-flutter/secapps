import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:secapps/MyCartPage.dart';
import 'firebase_options.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// صفحات عامة
import 'home_page.dart';
import 'ProfilePage.dart';
import 'confirmation_page.dart';
import 'login_page.dart';

// صفحات البائع
import 'seller_page.dart';
import 'SellerRegisterPage.dart' as register;
import 'SellerForgotPasswordPage.dart';
import 'SellerHomePage.dart';
import 'add_product.dart' as add;

// صفحات التوثيق
import 'otp_verification.dart';

// صفحات أخرى
import 'offers_page.dart';
import 'delivery_page.dart';
import 'game_page.dart';
import 'coupon_page.dart';
import 'MenuPage.dart';
import 'CategoryPage.dart';
import 'subcategorypage.dart';
import 'subsubcategorypage.dart';

// صفحات الادمن
import 'AdminReviewPage.dart';
import 'ApprovedProductsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy()); // هذا السطر يجب أن يعمل فقط على الويب
  }

  runApp(const SecApps());
}

class SecApps extends StatelessWidget {
  const SecApps({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecApps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Cairo'),
      home: LoginPage(),
      routes: {
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/seller_login': (context) => SellerLoginPage(),
        '/SellerRegisterPage': (context) => register.SellerRegisterPage(),
        '/seller_forgot_password': (context) => SellerForgotPasswordPage(),
        '/confirmation': (context) => ConfirmationPage(),
        '/offers': (context) => OffersPage(),
        '/delivery': (context) => DeliveryPage(),
        '/game': (context) => GamePage(),
        '/coupon': (context) => CouponPage(),
        '/admin': (context) => const AdminReviewPage(),
        '/menu': (context) => MenuPage(),
        '/category': (context) => CategoriesPage(),
        '/sub_category': (context) => SubCategoryPage(category: ''),
        '/approved_products':
            (context) =>
                ApprovedProductsPage(mainCategory: '', subCategory: ''),
        '/sub_sub_category':
            (context) => SubSubCategoryPage(subCategory: '', mainCategory: ''),
        '/cart': (context) => const MyCartPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/otp') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => OTPVerificationPage(
                  phoneNumber: args['phoneNumber'],
                  userName: args['userName'],
                  governorate: args['governorate'],
                  password: args['password'] ?? '',
                  verificationId: args['verificationId'],
                  confirmationResult: args['confirmationResult'],
                ),
          );
        }

        if (settings.name == '/seller_home') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => SellerHomePage(sellerPhone: args['sellerPhone']),
          );
        }

        if (settings.name == '/add_product') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) =>
                    add.UploadProductPage(sellerPhone: args['sellerPhone']),
          );
        }

        return null;
      },
    );
  }
}




/*
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:secapps/subcategorypage.dart';
import 'package:secapps/subsubcategorypage.dart';
import 'firebase_options.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart'; // مهم أحيانًا للويب

// صفحات عامة
import 'home_page.dart';
import 'ProfilePage.dart';
import 'confirmation_page.dart';
import 'login_page.dart'; // تأكد من استيراد LoginPage

// ادمن
import 'AdminReviewPage.dart';
import 'ApprovedProductsPage.dart';

// صفحات البائع
import 'seller_page.dart';
import 'SellerRegisterPage.dart' as register; // استخدام alias لحل التضارب
import 'SellerForgotPasswordPage.dart';
import 'SellerHomePage.dart';
import 'add_product.dart' as add; // alias هنا أيضاً

// صفحات OTP والتوثيق
import 'otp_verification.dart';

// صفحات أخرى
import 'offers_page.dart';
import 'delivery_page.dart';
import 'game_page.dart';
import 'coupon_page.dart';
import 'MenuPage.dart';
import 'CategoryPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setUrlStrategy(PathUrlStrategy()); // اختياري لكن مفيد للويب

  runApp(const SecApps());
}

class SecApps extends StatelessWidget {
  const SecApps({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecApps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Cairo'),

      // الصفحة الافتراضية عند التشغيل
      home: LoginPage(),

      routes: {
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/seller_login': (context) => SellerLoginPage(),
        '/SellerRegisterPage': (context) => register.SellerRegisterPage(),
        '/seller_forgot_password': (context) => SellerForgotPasswordPage(),
        '/confirmation': (context) => ConfirmationPage(),
        '/offers': (context) => OffersPage(),
        '/delivery': (context) => DeliveryPage(),
        '/game': (context) => GamePage(),
        '/coupon': (context) => CouponPage(),
        '/admin': (context) => const AdminReviewPage(),
        '/menu': (context) => MenuPage(),
        '/category': (context) => CategoriesPage(), // صفحة الأقسام

        '/sub_category':
            (context) => SubCategoryPage(category: ''), // صفحة الفئات الفرعية
        '/approved_products':
            (context) => ApprovedProductsPage(
              mainCategory: '',
              subCategory: '',
            ), // صفحة المنتجات المعتمدة
        '/sub_sub_category':
            (context) => SubSubCategoryPage(
              subCategory: '',
              mainCategory: '',
            ), // صفحة الفئة الفرعية الثانية
      },

      onGenerateRoute: (settings) {
        if (settings.name == '/otp') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => OTPVerificationPage(
                  phoneNumber: args['phoneNumber'],
                  userName: args['userName'],
                  governorate: args['governorate'],
                  password: args['password'] ?? '',
                  verificationId: args['verificationId'],
                  confirmationResult: args['confirmationResult'],
                ),
          );
        }

        if (settings.name == '/seller_home') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => SellerHomePage(sellerPhone: args['sellerPhone']),
          );
        }

        if (settings.name == '/add_product') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) =>
                    add.UploadProductPage(sellerPhone: args['sellerPhone']),
          );
        }

        return null;
      },
    );
  }
}
*/