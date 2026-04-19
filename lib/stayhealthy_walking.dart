import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'stayhealthy_stretching.dart';
import 'global_data.dart';

class StayhealthyWalking extends StatefulWidget {
  const StayhealthyWalking({super.key});

  @override
  State<StayhealthyWalking> createState() => _StayhealthyWalkingState();
}

class _StayhealthyWalkingState extends State<StayhealthyWalking> {
  String _steps = '0';

  @override
  void initState() {
    super.initState();
    Pedometer.stepCountStream.listen((event) {
      if (mounted) {
        setState(() {
          _steps = event.steps.toString();
          GlobalData.updateSteps(event.steps);
          GlobalData.addCalories(0.04); // 1 ก้าวประมาณ 0.04 kcal
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExerciseBaseLayout(
      title: 'Walking',
      icon: Icons.directions_walk_rounded,
      initialSeconds: 120,
      extraInfo: 'Steps: $_steps',
    );
  }
}