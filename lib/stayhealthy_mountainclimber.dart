import 'package:flutter/material.dart';
import 'stayhealthy_stretching.dart'; 

class StayhealthyMountainClimber extends StatelessWidget {
  const StayhealthyMountainClimber({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExerciseBaseLayout(
      title: 'Mountain Climbers',
      icon: Icons.terrain_rounded,
      initialSeconds: 60, // ตั้งเวลา 1 นาที
    );
  }
}