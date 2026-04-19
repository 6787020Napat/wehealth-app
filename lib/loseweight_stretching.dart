import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'global_data.dart';

class LoseweightStretching extends StatefulWidget {
  const LoseweightStretching({super.key});

  @override
  State<LoseweightStretching> createState() => _LoseweightStretchingState();
}

class _LoseweightStretchingState extends State<LoseweightStretching> {
  Timer? _timer;
  int _currentSeconds = 120;
  bool _isRunning = false;

  void _handlePlayPause() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_currentSeconds > 0) {
            _currentSeconds--;
            GlobalData.addCalories(0.05); 
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
      title: 'Stretching',
      instruction: 'Stretch your muscles and relax.',
      icon: Icons.accessibility_new_rounded,
      timerDisplay: '${(_currentSeconds ~/ 60).toString().padLeft(2, '0')}:${(_currentSeconds % 60).toString().padLeft(2, '0')}',
      isRunning: _isRunning,
      onPlayPause: _handlePlayPause,
      onReset: () {
        _timer?.cancel();
        setState(() {
          _currentSeconds = 120;
          _isRunning = false;
        });
      },
      onDone: () => Navigator.pop(context, true),
    );
  }
}

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
          const SizedBox(height: 10),
          Text(title, style: GoogleFonts.nunito(fontSize: 32, fontWeight: FontWeight.w900, color: const Color(0xFF1976D2))),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(40),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
            child: Column(
              children: [
                Icon(icon, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                Text(timerDisplay, style: GoogleFonts.nunito(fontSize: 60, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBtn(Icons.refresh_rounded, onReset),
                    _buildBtn(isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded, onPlayPause, isMain: true),
                    _buildBtn(Icons.done_all_rounded, onDone),
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
        height: isMain ? 80 : 60, width: isMain ? 80 : 60,
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF1976D2)]), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: isMain ? 40 : 30),
      ),
    );
  }
}