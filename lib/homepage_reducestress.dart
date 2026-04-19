import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reducestress_workout.dart'; 
import 'data_service.dart';

class HomepageReducestress extends StatefulWidget {
  const HomepageReducestress({super.key});

  @override
  State<HomepageReducestress> createState() => _HomepageReducestressState();
}

class _HomepageReducestressState extends State<HomepageReducestress> {
  double totalKcal = 0.0;
  int totalDurationSeconds = 0;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    final data = await DataService.loadData('reducestress'); 
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
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFFE1F5FE), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                _buildHeader(),
                const SizedBox(height: 30),
                _buildGoalCard(context),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Duration', _formatTime(totalDurationSeconds), Icons.spa_outlined, Colors.green)),
                    const SizedBox(width: 20),
                    Expanded(child: _buildStatCard('Calories', '${totalKcal.toStringAsFixed(1)} kcal', Icons.local_fire_department, Colors.orange)),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Back to Main", style: GoogleFonts.nunito(color: Colors.grey)),
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
        Text('Reduce Stress', style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.blueGrey[800])),
        Text('Relax your mind and body', style: GoogleFonts.nunito(fontSize: 16, color: Colors.black45)),
      ],
    );
  }

  Widget _buildGoalCard(BuildContext context) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        gradient: const LinearGradient(colors: [Color(0xFF81C784), Color(0xFF4CAF50)]),
      ),
      child: Column(
        children: [
          Text("DAILY FOCUS", style: GoogleFonts.nunito(color: Colors.white, letterSpacing: 2, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Mindfulness Session", style: GoogleFonts.nunito(color: Colors.white, fontSize: 20)),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ReducestressWorkout()))
              .then((_) => _refreshData());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            child: const Text('Start Relaxing', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 15)]),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(title, style: GoogleFonts.nunito(color: Colors.black54, fontWeight: FontWeight.bold)),
          Text(value, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}