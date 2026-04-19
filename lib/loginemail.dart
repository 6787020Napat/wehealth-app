import 'package:flutter/material.dart';
// 1. นำเข้าไฟล์หน้า Goal Setup (เช็คชื่อไฟล์ให้ตรงกับในเครื่องคุณ)
import 'goal_setup.dart'; 

class LoginEmailPage extends StatefulWidget {
  const LoginEmailPage({super.key});

  @override
  State<LoginEmailPage> createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // ฟังก์ชันจัดการเมื่อกดปุ่ม Sign In
  void _handleSignIn() {
    // ตรงนี้คุณสามารถเพิ่ม Logic ตรวจสอบ Email/Password ได้ในอนาคต
    
    // 2. คำสั่งเปลี่ยนหน้าไปยัง GoalSetupPage
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const GoalSetupPage()), // ตรวจสอบชื่อ Class ในไฟล์ goal_setup.dart ว่าชื่อนี้ไหม
      (route) => false, // ใช้ false เพื่อไม่ให้กดย้อนกลับมาหน้า Login ได้อีก
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset('photo/wehealthlogo.png', height: 180),
                  const SizedBox(height: 30),
                  const Text('Welcome Back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Sign in to continue your journey', style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 40),
                  
                  _buildTextField(controller: _emailController, hint: 'Email Address', icon: Icons.email_outlined),
                  const SizedBox(height: 20),
                  _buildTextField(controller: _passwordController, hint: 'Password', icon: Icons.lock_outline_rounded, isPassword: true),
                  
                  const SizedBox(height: 30),
                  
                  // ปุ่ม Sign In ที่แก้ไขแล้ว
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _handleSignIn, // เรียกใช้ฟังก์ชันที่เราสร้างไว้ด้านบน
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // ... ส่วนล่างของโค้ดคงเดิม ...
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF1976D2)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }
}