import 'package:flutter/material.dart';
import 'reducestress_stretching.dart';

class ReducestressMeditate extends StatelessWidget {
  const ReducestressMeditate({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExerciseBaseLayout(
      title: 'Meditate',
      icon: Icons.self_improvement_rounded,
      initialSeconds: 60, // 1 นาที
    );
  }
}