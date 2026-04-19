import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart'; // สำหรับขออนุญาตเซนเซอร์
import 'loseweight_stretching.dart'; // หรือไฟล์ที่เก็บ ExerciseBaseLayout
import 'global_data.dart';

class LoseweightWalking extends StatefulWidget {
  const LoseweightWalking({super.key});

  @override
  State<LoseweightWalking> createState() => _LoseweightWalkingState();
}

class _LoseweightWalkingState extends State<LoseweightWalking> {
  Timer? _timer;
  int _currentSeconds = 1800; // 30 นาที
  bool _isRunning = false;
  String _steps = '0';
  StreamSubscription<StepCount>? _stepCountSubscription;

  @override
  void initState() {
    super.initState();
    initPedometer(); // เริ่มต้นขออนุญาตและดึงค่าก้าว
  }

  // ฟังก์ชันขออนุญาตใช้งานเซนเซอร์และเริ่มนับก้าว
  void initPedometer() async {
    // 1. ขออนุญาตเข้าถึง Activity Recognition (สำหรับ Android 10+)
    if (await Permission.activityRecognition.request().isGranted) {
      // 2. ถ้าอนุญาตแล้ว เริ่มดึงข้อมูลก้าว
      _stepCountSubscription = Pedometer.stepCountStream.listen(
        (event) {
          if (mounted) {
            setState(() {
              _steps = event.steps.toString();
              GlobalData.updateSteps(event.steps); // เก็บก้าวเข้า Global
            });
          }
        },
        onError: (error) => print("Step Count Error: $error"),
      );
    } else {
      print("Permission Denied");
      // คุณอาจจะโชว์แจ้งเตือนว่า 'กรุณาอนุญาตการเข้าถึงกิจกรรมเพื่อรันระบบนับก้าว'
    }
  }

  void _handlePlayPause() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_currentSeconds > 0) {
            _currentSeconds--;
            GlobalData.addCalories(0.02); // เพิ่มแคลอรี่ระหว่างเดิน
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
    _stepCountSubscription?.cancel(); // ยกเลิกการฟังค่าก้าวเมื่อปิดหน้า
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExerciseBaseLayout(
      title: 'Walking',
      instruction: 'Current Steps: $_steps', // โชว์จำนวนก้าว
      icon: Icons.directions_walk_rounded,
      timerDisplay: '${(_currentSeconds ~/ 60).toString().padLeft(2, '0')}:${(_currentSeconds % 60).toString().padLeft(2, '0')}',
      isRunning: _isRunning,
      onPlayPause: _handlePlayPause,
      onReset: () {
        _timer?.cancel();
        setState(() {
          _currentSeconds = 1800;
          _isRunning = false;
        });
      },
      onDone: () {
        _timer?.cancel();
        Navigator.pop(context, true); // ส่ง true กลับไปหน้า Workout ให้ติ๊กถูก
      },
    );
  }
}