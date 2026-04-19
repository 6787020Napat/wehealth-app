import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'global_data.dart';

class BuildstrengthPushup extends StatefulWidget {
  const BuildstrengthPushup({super.key});

  @override
  State<BuildstrengthPushup> createState() => _BuildstrengthPushupState();
}

class _BuildstrengthPushupState extends State<BuildstrengthPushup> {
  Timer? _timer;
  int _currentSeconds = 30;
  bool _isRunning = false;

  void _handlePlayPause() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_currentSeconds > 0) {
            _currentSeconds--;
            // ออกกำลังกายหนัก (Strength) ให้แคลอรี่เยอะกว่าปกติ (0.1 kcal/sec)
            GlobalData.addCalories(0.1); 
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
    return ExerciseBaseLayout(
      title: 'Push up',
      icon: Icons.fitness_center_rounded,
      instruction: _isRunning ? 'Keep going!' : 'Ready?',
      timerDisplay: '${(_currentSeconds ~/ 60).toString().padLeft(2, '0')}:${(_currentSeconds % 60).toString().padLeft(2, '0')}',
      isRunning: _isRunning,
      onPlayPause: _handlePlayPause,
      onReset: () {
        _timer?.cancel();
        setState(() { _currentSeconds = 30; _isRunning = false; });
      },
      onDone: () => Navigator.pop(context, true),
    );
  }
}

// --- โครงสร้าง Layout ที่ใช้ร่วมกันทุกท่าใน Build Strength ---
class ExerciseBaseLayout extends StatelessWidget {
  final String title, instruction, timerDisplay;
  final IconData icon;
  final bool isRunning;
  final VoidCallback onPlayPause, onReset, onDone;

  const ExerciseBaseLayout({
    super.key, required this.title, required this.instruction, required this.icon,
    required this.timerDisplay, required this.isRunning, required this.onPlayPause,
    required this.onReset, required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                      const SizedBox(width: 5),
                      Text('${GlobalData.totalCalories.toStringAsFixed(1)} kcal', 
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(title, style: GoogleFonts.nunito(fontSize: 32, fontWeight: FontWeight.w900, color: const Color(0xFF1976D2))),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(40),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
            child: Column(
              children: [
                Icon(icon, size: 100, color: Colors.blue),
                const SizedBox(height: 20),
                Text(timerDisplay, style: GoogleFonts.nunito(fontSize: 70, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBtn(Icons.refresh, onReset),
                    _buildBtn(isRunning ? Icons.pause : Icons.play_arrow, onPlayPause, isMain: true),
                    _buildBtn(Icons.done, onDone),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBtn(IconData icon, VoidCallback onTap, {bool isMain = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isMain ? 90 : 70, width: isMain ? 90 : 70,
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF1976D2)]), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: isMain ? 45 : 35),
      ),
    );
  }
}