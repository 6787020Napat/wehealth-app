import 'dart:async';
import 'package:flutter/material.dart';
import 'loseweight_stretching.dart';
import 'global_data.dart'; // Import ข้อมูลกลาง

class LoseweightJumpingjack extends StatefulWidget {
  const LoseweightJumpingjack({super.key});

  @override
  State<LoseweightJumpingjack> createState() => _LoseweightJumpingjackState();
}

class _LoseweightJumpingjackState extends State<LoseweightJumpingjack> {
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
            // กระโดดตบเผาผลาญหนักกว่าเดิน
            GlobalData.addCalories(0.15); 
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
      title: 'Jumping Jack',
      instruction: 'Burn calories: ${GlobalData.totalCalories.toStringAsFixed(1)}', 
      icon: Icons.bolt_rounded,
      timerDisplay: '${(_currentSeconds ~/ 60).toString().padLeft(2, '0')}:${(_currentSeconds % 60).toString().padLeft(2, '0')}',
      isRunning: _isRunning,
      onPlayPause: _handlePlayPause,
      onReset: () => setState(() {
        _timer?.cancel();
        _currentSeconds = 120;
        _isRunning = false;
      }),
      onDone: () {
        _timer?.cancel();
        Navigator.pop(context, true); 
      },
    );
  }
}