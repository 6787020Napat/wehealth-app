import 'package:flutter/material.dart';
import 'reducestress_meditate.dart';
import 'reducestress_deepbreathing.dart';
import 'reducestress_stretching.dart';
import 'summerize.dart'; 
import 'global_data.dart';
import 'data_service.dart';

class ReducestressWorkout extends StatefulWidget {
  const ReducestressWorkout({super.key});

  @override
  State<ReducestressWorkout> createState() => _ReducestressWorkoutState();
}

class _ReducestressWorkoutState extends State<ReducestressWorkout> {
  List<bool> isCompleted = [false, false, false];
  final Stopwatch _sessionTimer = Stopwatch();

  @override
  void initState() {
    super.initState();
    GlobalData.totalCalories = 0.0;
    _sessionTimer.start();
  }

  @override
  Widget build(BuildContext context) {
    bool isDone = isCompleted.every((e) => e);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new)),
                  const Text('Reduce Stress', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              _buildRow(0, 'Meditate', Icons.self_improvement, const ReducestressMeditate()),
              _buildRow(1, 'Deep Breathing', Icons.air, const ReducestressDeepBreathing()),
              _buildRow(2, 'Stretching', Icons.accessibility, const ReducestressStretching()),
              const Spacer(),
              if (isDone)
                ElevatedButton(
                  onPressed: () async {
                    _sessionTimer.stop();
                    double kcal = GlobalData.totalCalories;
                    int secs = _sessionTimer.elapsed.inSeconds;
                    await DataService.saveWorkoutData('reducestress', kcal, secs);
                    if (!mounted) return;
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => SummarizePage(
                        calories: kcal, 
                        totalSeconds: secs,
                        streakDays: 1, // เพิ่มค่า streakDays เพื่อแก้ตัวแดง
                      )
                    ));
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 60)),
                  child: const Text('Complete Session'),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(int index, String title, IconData icon, Widget page) {
    bool done = isCompleted[index];
    return ListTile(
      leading: Icon(icon, color: done ? Colors.green : Colors.blue),
      title: Text(title),
      onTap: () async {
        final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        if (res == true) setState(() => isCompleted[index] = true);
      },
    );
  }
}