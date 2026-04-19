import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'global_data.dart';

class SummarizePage extends StatefulWidget {
  final double calories;
  final int totalSeconds;
  final int streakDays;

  const SummarizePage({
    super.key,
    required this.calories,
    required this.totalSeconds,
    required this.streakDays,
  });

  @override
  State<SummarizePage> createState() => _SummarizePageState();
}

class _SummarizePageState extends State<SummarizePage> {
  
  // ฟังก์ชันแปลงวินาทีเป็น นาที:วินาที
  String _formatTime(int seconds) {
    if (seconds < 60) return '$seconds sec';
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return secs == 0 ? '$mins min' : '$mins min $secs sec';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black54),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You’ve done !',
                        style: GoogleFonts.nunito(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Amazing job on your workout!',
                        style: TextStyle(color: Colors.black45, fontSize: 16),
                      ),
                      const SizedBox(height: 40),
                      
                      // ส่วนแสดงสถิติที่แก้ไขใหม่
                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FBFF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat('Calories', widget.calories.toStringAsFixed(1), 'kcal', Colors.orange),
                            _buildStat('Duration', _formatTime(widget.totalSeconds), '', Colors.blue),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      // แสดง Streak
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${widget.streakDays} Day Streak',
                            style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          const Text('🔥', style: TextStyle(fontSize: 30)),
                        ],
                      ),

                      const SizedBox(height: 50),
                      SizedBox(
                        width: 200,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            // ล้างค่า Global ก่อนกลับหน้าแรก
                            GlobalData.totalCalories = 0.0;
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          child: const Text('Back to Home', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
    );
  }

  // Widget ลูกสำหรับสร้างช่องแสดงตัวเลข
  Widget _buildStat(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.black45, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
        if (unit.isNotEmpty) Text(unit, style: TextStyle(color: color, fontSize: 14)),
      ],
    );
  }
}