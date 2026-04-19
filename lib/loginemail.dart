import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. นำเข้า Firebase Auth
import 'goal_setup.dart'; 

class LoginEmailPage extends StatefulWidget {
  const LoginEmailPage({super.key});

  @override
  State<LoginEmailPage> createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // สำหรับแสดงสถานะการโหลด

  // 2. ฟังก์ชันจัดการการ Login ด้วย Firebase
  Future<void> _handleSignIn() async {
    // ตรวจสอบเบื้องต้นว่ากรอกข้อมูลครบไหม
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog('กรุณากรอกอีเมลและรหัสผ่านให้ครบถ้วน');
      return;
    }

    setState(() {
      _isLoading = true; // เริ่มโหลด
    });

    try {
      // ตรวจสอบรหัสผ่านกับ Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // ถ้าผ่าน -> ไปหน้า GoalSetupPage
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const GoalSetupPage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      // ถ้าไม่ผ่าน (เช่น รหัสผิด, ไม่พบผู้ใช้) จะมาตกที่นี่
      String message = 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ';
      if (e.code == 'user-not-found') {
        message = 'ไม่พบผู้ใช้งานนี้ในระบบ';
      } else if (e.code == 'wrong-password') {
        message = 'รหัสผ่านไม่ถูกต้อง';
      } else if (e.code == 'invalid-email') {
        message = 'รูปแบบอีเมลไม่ถูกต้อง';
      }
      _showErrorDialog(message);
    } catch (e) {
      _showErrorDialog('เกิดข้อผิดพลาด: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // หยุดโหลด
        });
      }
    }
  }

  // ฟังก์ชันแสดง Alert เมื่อรหัสผิด
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('เข้าสู่ระบบไม่สำเร็จ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ตกลง'),
          ),
        ],
      ),
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
                  const Text('Welcome Back', 
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Sign in to continue your journey', 
                    style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 40),
                  
                  _buildTextField(
                    controller: _emailController, 
                    hint: 'Email Address', 
                    icon: Icons.email_outlined
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _passwordController, 
                    hint: 'Password', 
                    icon: Icons.lock_outline_rounded, 
                    isPassword: true
                  ),
                  
                  const SizedBox(height: 30),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignIn, // ปิดปุ่มชั่วคราวขณะโหลด
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white) // แสดงวงกลมโหลด
                        : const Text('Sign In', 
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 40),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), 
            blurRadius: 10, 
            offset: const Offset(0, 4)
          )
        ],
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