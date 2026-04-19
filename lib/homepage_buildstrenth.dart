import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'buildstrength_workout.dart'; 
import 'data_service.dart';

class HomepageBuildstrength extends StatefulWidget {
  const HomepageBuildstrength({super.key});

  @override
  State<HomepageBuildstrength> createState() => _HomepageBuildstrengthState();
}

class _HomepageBuildstrengthState extends State<HomepageBuildstrength> {
  double totalKcal = 0.0;
  int totalDurationSeconds = 0;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // ดึงข้อมูลล่าสุดโดยระบุหมวดหมู่ 'buildstrength'
  Future<void> _refreshData() async {
    final data = await DataService.loadData('buildstrength');
    if (mounted) {
      setState(() {
        totalKcal = (data['calories'] as num).toDouble();
        totalDurationSeconds = (data['duration'] as num).toInt();
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
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                _buildHeader(),
                const SizedBox(height: 35),
                _buildGoalCard(context),
                const SizedBox(height: 35),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Duration', 
                        _formatTime(totalDurationSeconds), 
                        Icons.timer_outlined, 
                        Colors.blue
                      )
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildStatCard(
                        'Calories', 
                        '${totalKcal.toStringAsFixed(1)} kcal', 
                        Icons.local_fire_department, 
                        Colors.orange
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.grey),
                    label: Text("Back to Home", style: GoogleFonts.nunito(color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Build Strength',
          style: GoogleFonts.nunito(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1976D2),
          ),
        ),
        Text(
          'Track your muscle progress',
          style: GoogleFonts.nunito(fontSize: 16, color: Colors.black45),
        ),
      ],
    );
  }

  Widget _buildGoalCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        gradient: const LinearGradient(colors: [Color(0xFF1976D2), Color(0xFF64B5F6)]),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            "TODAY'S GOAL", 
            style: GoogleFonts.nunito(color: Colors.white, letterSpacing: 2, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 10),
          Text(
            "Build Strength Session", 
            style: GoogleFonts.nunito(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              // นำทางไปหน้า Workout และโหลดข้อมูลใหม่เมื่อกลับมา
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const BuildstrengthWorkout())
              ).then((_) => _refreshData());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1976D2),
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(title, style: GoogleFonts.nunito(color: Colors.black54, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(value, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87)),
        ],
      ),
    );
  }
}