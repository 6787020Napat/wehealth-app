import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'loseweight_workout.dart'; 
import 'data_service.dart';

class HomepageLoseweight extends StatefulWidget {
  const HomepageLoseweight({super.key});

  @override
  State<HomepageLoseweight> createState() => _HomepageLoseweightState();
}

class _HomepageLoseweightState extends State<HomepageLoseweight> {
  double totalKcal = 0.0;
  int totalSeconds = 0;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // แก้ไข: ระบุหมวดหมู่ 'loseweight' เพื่อดึงข้อมูลให้ถูกกล่อง
  Future<void> _refreshData() async {
    final data = await DataService.loadData('loseweight');
    if (mounted) {
      setState(() {
        // ใช้ num เพื่อป้องกัน Error กรณีค่าที่คืนมาเป็น int
        totalKcal = (data['calories'] as num).toDouble();
        totalSeconds = (data['duration'] as num).toInt();
      });
    }
  }

  String _formatTime(int seconds) {
    if (seconds < 60) return '$seconds sec';
    return '${seconds ~/ 60} min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'WEhealth', 
                    style: GoogleFonts.nunito(
                      fontSize: 28, 
                      fontWeight: FontWeight.w800, 
                      color: const Color(0xFF4A90E2)
                    )
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.redAccent),
                    tooltip: 'Reset Lose Weight Data',
                    onPressed: () async {
                      // แก้ไข: Reset เฉพาะหมวดหมู่ loseweight
                      await DataService.resetCategoryData('loseweight');
                      _refreshData();
                    },
                  )
                ],
              ),
              const SizedBox(height: 20),
              _buildGoalCard(context),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      'Duration', 
                      _formatTime(totalSeconds), 
                      Icons.timer, 
                      const Color(0xFFE1F5FE), 
                      Colors.blue
                    )
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildInfoCard(
                      'Total Burn', 
                      '${totalKcal.toStringAsFixed(1)} kcal', 
                      Icons.local_fire_department, 
                      const Color(0xFFFFF3E0), 
                      Colors.orange
                    )
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Back to Menu'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF8ECAE6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          const Text(
            "TODAY'S PLAN", 
            style: TextStyle(color: Colors.white70, letterSpacing: 1.2, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 8),
          const Text(
            "Lose Weight Session", 
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const LoseweightWorkout())
              ).then((_) => _refreshData()); // รีเฟรชข้อมูลเมื่อกลับมาหน้า Home
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4A90E2),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
            ),
            child: const Text('Start Now', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 12),
          Text(title, style: GoogleFonts.nunito(color: Colors.black45, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87)),
        ],
      ),
    );
  }
}