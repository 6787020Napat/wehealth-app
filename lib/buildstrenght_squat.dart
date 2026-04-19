import 'dart:async';
import 'package:flutter/material.dart';
import 'buildstrength_pushup.dart'; // เรียกใช้ Layout
import 'global_data.dart';

class BuildstrengthSquat extends StatefulWidget {
  const BuildstrengthSquat({super.key});
  @override
  State<BuildstrengthSquat> createState() => _BuildstrengthSquatState();
}

class _BuildstrengthSquatState extends State<BuildstrengthSquat> {
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
  Widget build(BuildContext context) {
    return ExerciseBaseLayout(
      title: 'Squat',
      icon: Icons.accessibility_new_rounded,
      instruction: 'Squat low!',
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