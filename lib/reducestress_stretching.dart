import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'global_data.dart'; // นำเข้าข้อมูลกลาง

class ReducestressStretching extends StatelessWidget {
  const ReducestressStretching({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExerciseBaseLayout(
      title: 'Stretching',
      icon: Icons.accessibility_new_rounded,
      initialSeconds: 180, 
    );
  }
}

class ExerciseBaseLayout extends StatefulWidget {
  final String title;
  final IconData icon;
  final int initialSeconds;

  const ExerciseBaseLayout({
    super.key, 
    required this.title, 
    required this.icon, 
    required this.initialSeconds,
  });

  @override
  State<ExerciseBaseLayout> createState() => _ExerciseBaseLayoutState();
}

class _ExerciseBaseLayoutState extends State<ExerciseBaseLayout> {
  late int _secondsRemaining;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.initialSeconds;
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
            // --- เพิ่มระบบนับแคลอรี่ ---
            // กิจกรรมคลายเครียดใช้พลังงานน้อยกว่าออกกำลังกายหนัก (สมมติ 0.02 kcal/วินาที)
            GlobalData.addCalories(0.02); 
          } else {
            _timer?.cancel();
            _isRunning = false;
          }
        });
      });
    }
    setState(() => _isRunning = !_isRunning);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    String seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Column(
        children: [
          const SizedBox(height: 50),
          // แถบแสดงแคลอรี่สะสมด้านบน
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        '${GlobalData.totalCalories.toStringAsFixed(1)} kcal', 
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(widget.title, style: GoogleFonts.nunito(fontSize: 32, fontWeight: FontWeight.w900, color: const Color(0xFF1976D2))),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(40),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
            ),
            child: Column(
              children: [
                Icon(widget.icon, size: 100, color: Colors.blue),
                const SizedBox(height: 20),
                Text('$minutes:$seconds', style: GoogleFonts.nunito(fontSize: 70, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBtn(Icons.refresh, 'Reset', onTap: () {
                      _timer?.cancel();
                      setState(() {
                        _secondsRemaining = widget.initialSeconds;
                        _isRunning = false;
                      });
                    }),
                    _buildBtn(_isRunning ? Icons.pause : Icons.play_arrow, _isRunning ? 'Pause' : 'Play', isMain: true, onTap: _toggleTimer),
                    _buildBtn(Icons.check, 'Done', onTap: () {
                      _timer?.cancel();
                      Navigator.pop(context, true);
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBtn(IconData icon, String label, {bool isMain = false, VoidCallback? onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: isMain ? 90 : 70, width: isMain ? 90 : 70,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF1976D2)]),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: isMain ? 45 : 35, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}