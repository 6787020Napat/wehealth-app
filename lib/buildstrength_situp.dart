import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'buildstrength_pushup.dart'; // เพื่อเรียกใช้ ExerciseBaseLayout ร่วมกัน
import 'global_data.dart'; // นำเข้าข้อมูลแคลอรี่กลาง

class BuildstrengthSitup extends StatefulWidget {
  const BuildstrengthSitup({super.key});

  @override
  State<BuildstrengthSitup> createState() => _BuildstrengthSitupState();
}

class _BuildstrengthSitupState extends State<BuildstrengthSitup> {
  Timer? _timer;
  int _currentSeconds = 30; // ตั้งเวลา 30 วินาที
  bool _isRunning = false;

  void _handlePlayPause() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_currentSeconds > 0) {
            _currentSeconds--;
            // --- เพิ่มระบบนับแคลอรี่ ---
            // Sit-up เป็นท่าสร้างกล้ามเนื้อ ให้แคลอรี่ประมาณ 0.1 kcal ต่อวินาที
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
    // ใช้ ExerciseBaseLayout ที่อยู่ในไฟล์ pushup เพื่อให้ UI ไปทางเดียวกัน
    return ExerciseBaseLayout(
      title: 'Sit up',
      icon: Icons.airline_seat_flat_angled_rounded,
      instruction: _isRunning ? 'Feel the burn!' : 'Ready to sit up?',
      timerDisplay: '${(_currentSeconds ~/ 60).toString().padLeft(2, '0')}:${(_currentSeconds % 60).toString().padLeft(2, '0')}',
      isRunning: _isRunning,
      onPlayPause: _handlePlayPause,
      onReset: () {
        _timer?.cancel();
        setState(() {
          _currentSeconds = 30;
          _isRunning = false;
        });
      },
      onDone: () {
        _timer?.cancel();
        Navigator.pop(context, true); // ส่งค่า true กลับไปติ๊กถูกที่หน้า Workout
      },
    );
  }
}