import 'package:flutter/material.dart';
import 'stayhealthy_mountainclimber.dart';
import 'stayhealthy_stretching.dart';
import 'stayhealthy_walking.dart';
import 'summerize.dart';
import 'global_data.dart';
import 'data_service.dart';

class StayhealthyWorkout extends StatefulWidget {
  const StayhealthyWorkout({super.key});

  @override
  State<StayhealthyWorkout> createState() => _StayhealthyWorkoutState();
}

class _StayhealthyWorkoutState extends State<StayhealthyWorkout> {
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
      backgroundColor: const Color(0xFFF0F8FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new)),
                  const Text('Stay Healthy', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                ],
              ),
              const SizedBox(height: 25),
              _buildExerciseCard(0, 'Stretching', Icons.accessibility, const StayhealthyStretching()),
              _buildExerciseCard(1, 'Mountain Climber', Icons.terrain, const StayhealthyMountainClimber()),
              _buildExerciseCard(2, 'Walking', Icons.directions_walk, const StayhealthyWalking()),
              const Spacer(),
              if (isDone)
                ElevatedButton(
                  onPressed: () async {
                    _sessionTimer.stop();
                    double kcal = GlobalData.totalCalories;
                    int secs = _sessionTimer.elapsed.inSeconds;
                    await DataService.saveWorkoutData('stayhealthy', kcal, secs);
                    if (!mounted) return;
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => SummarizePage(
                        calories: kcal, 
                        totalSeconds: secs,
                        streakDays: 1, // เพิ่มค่า streakDays เพื่อแก้ตัวแดง
                      )
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  child: const Text('Finish'),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(int index, String title, IconData icon, Widget page) {
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