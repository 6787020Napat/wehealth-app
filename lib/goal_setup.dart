import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- ส่วนที่ 1: Import หน้าปลายทาง ---
import 'package:wehealth/homepage_loseweight.dart';
import 'package:wehealth/homepage_buildstrenth.dart';
import 'package:wehealth/homepage_reducestress.dart';
import 'package:wehealth/homepage_stayhealthy.dart';

// เพิ่มการ Import หน้า Login (ตรวจสอบชื่อไฟล์และ Path ให้ตรงกับโปรเจกต์ของคุณ)
import 'package:wehealth/login_page.dart'; 

class GoalSetupPage extends StatelessWidget {
  const GoalSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Text(
                  'What is your goal?',
                  style: GoogleFonts.nunito(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1976D2),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Choose the path that fits you best',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),

                // ส่วนการ์ดเป้าหมาย
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.85,
                    children: [
                      _buildGoalCard(context, 'Lose weight', 'photo/loseweight.png'),
                      _buildGoalCard(context, 'Build strength', 'photo/buildstrength.png'),
                      _buildGoalCard(context, 'Reduce stress', 'photo/reducestress.png'),
                      _buildGoalCard(context, 'Stay healthy', 'photo/stayhealthy.png'),
                    ],
                  ),
                ),

                // ปุ่ม Back ที่แก้ไขแล้ว
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: SizedBox(
                    width: 180,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // แก้ไข: ใช้ pushAndRemoveUntil เพื่อล้างหน้าเก่าและกลับไปหน้า Login ชัวร์ๆ
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                          (route) => false, // ลบทุกหน้าใน Stack ออกเพื่อให้หน้า Login เป็นหน้าแรกสุด
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1976D2),
                        elevation: 4,
                        shadowColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Color(0xFFB3E0FF), width: 1.5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                          const SizedBox(width: 10),
                          Text(
                            'Back',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- ส่วนที่ 2: ฟังก์ชันสร้างการ์ดพร้อมระบบ Navigation ---
  Widget _buildGoalCard(BuildContext context, String title, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1976D2).withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Widget destination;
            // แก้ไขชื่อคลาสให้ตรงกับหน้าปลายทาง (เช็คเรื่องตัวพิมพ์เล็ก/ใหญ่ด้วย)
            if (title == 'Lose weight') {
              destination = const HomepageLoseweight(); 
            } else if (title == 'Build strength') {
              destination = const HomepageBuildstrength();
            } else if (title == 'Reduce stress') {
              destination = const HomepageReducestress();
            } else {
              destination = const HomepageStayhealthy();
            }

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          },
          borderRadius: BorderRadius.circular(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD).withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  imagePath,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.fitness_center_rounded, size: 50, color: Colors.blueGrey),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1976D2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}