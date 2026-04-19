import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart'; // ดึงหน้าแรกมาจากไฟล์ที่คุณแยกไว้
import 'package:firebase_core/firebase_core.dart'; // เพิ่มการนำเข้า Firebase
import 'firebase_options.dart'; // ไฟล์ที่สร้างขึ้นจากคำสั่ง flutterfire configure

void main() async {
  // เพิ่มบรรทัดเหล่านี้เพื่อเตรียมความพร้อมให้ Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const WEhealthApp());
}

class WEhealthApp extends StatelessWidget {
  const WEhealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WEhealth',
      debugShowCheckedModeBanner: false, // ปิดแถบ Debug สีแดงมุมขวา
      theme: ThemeData(
        // ใช้ฟอนต์ Nunito ทั้งแอปตามที่คุณต้องการ
        textTheme: GoogleFonts.nunitoTextTheme(),
        primarySwatch: Colors.blue,
      ),
      // กำหนดหน้าแรกของแอปเป็น LoginPage
      home: const LoginPage(), 
    );
  }
}