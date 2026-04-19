import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // นำเข้า Firestore

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // สร้าง Controller สำหรับแต่ละช่องกรอกข้อมูล
  final _firstnameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // ฟังก์ชันสำหรับจัดการการกดปุ่ม Sign up และบันทึกข้อมูลลง Firebase
  void _handleSignUp() async {
    String firstname = _firstnameController.text.trim();
    String surname = _surnameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // 1. ตรวจสอบว่ากรอกข้อมูลครบทุกช่องหรือไม่
    if (firstname.isEmpty || surname.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบทุกช่อง')),
      );
      return;
    }

    // 2. ตรวจสอบว่ารหัสผ่านตรงกันหรือไม่
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('รหัสผ่านไม่ตรงกัน')),
      );
      return;
    }

    // --- ส่วนที่เพิ่มใหม่: บันทึกข้อมูลลง Cloud Firestore ---
    try {
      // แสดง Loading ระหว่างรอส่งข้อมูล
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // บันทึกลง Collection ชื่อ 'users'
      await FirebaseFirestore.instance.collection('users').add({
        'firstname': firstname,
        'surname': surname,
        'email': email,
        'created_at': FieldValue.serverTimestamp(), // เก็บเวลาที่สมัคร
      });

      // ปิด Loading
      if (!mounted) return;
      Navigator.pop(context);

      // แสดงข้อความสำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('สมัครสมาชิกและบันทึกข้อมูลสำเร็จ!')),
      );

      // ย้อนกลับไปหน้า Login
      Navigator.pop(context);

    } catch (e) {
      // ปิด Loading ถ้าเกิด Error
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              const Text(
                'Welcome to WEhealth',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'photo/wehealthlogo.png',
                height: 100,
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.favorite, size: 60, color: Color(0xFF1976D2)),
              ),
              const SizedBox(height: 30),
              _buildInputField(label: 'Firstname', controller: _firstnameController),
              const SizedBox(height: 15),
              _buildInputField(label: 'Surname', controller: _surnameController),
              const SizedBox(height: 15),
              _buildInputField(label: 'Email', controller: _emailController),
              const SizedBox(height: 15),
              _buildInputField(label: 'New Password', controller: _passwordController, isPassword: true),
              const SizedBox(height: 15),
              _buildInputField(label: 'Confirmed Password', controller: _confirmPasswordController, isPassword: true),
              const SizedBox(height: 40),
              SizedBox(
                width: 160,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD0D7FF),
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.black87, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}