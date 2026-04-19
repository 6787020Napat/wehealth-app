import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. ต้องนำเข้าตัวนี้เพื่อทำระบบ Login

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstnameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _handleSignUp() async {
    String firstname = _firstnameController.text.trim();
    String surname = _surnameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim(); // เพิ่ม .trim() ป้องกันช่องว่าง
    String confirmPassword = _confirmPasswordController.text.trim();

    if (firstname.isEmpty || surname.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบทุกช่อง')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('รหัสผ่านไม่ตรงกัน')),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // --- ส่วนที่แก้ไข: สร้างบัญชีผู้ใช้ในระบบ Authentication ก่อน ---
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // --- บันทึกข้อมูลเสริมลง Firestore โดยใช้ UID จาก Authentication ---
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'firstname': firstname,
        'surname': surname,
        'email': email,
        'created_at': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.pop(context); // ปิด Loading

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('สมัครสมาชิกสำเร็จ!')),
      );

      Navigator.pop(context); // ย้อนกลับหน้า Login

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // ปิด Loading
      String message = 'เกิดข้อผิดพลาด';
      if (e.code == 'email-already-in-use') {
        message = 'อีเมลนี้ถูกใช้งานไปแล้ว';
      } else if (e.code == 'weak-password') {
        message = 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // ... ส่วน dispose และ build เหมือนเดิมทุกประการ ...
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