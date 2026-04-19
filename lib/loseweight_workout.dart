import 'package:flutter/material.dart';
import 'loseweight_stretching.dart';
import 'loseweight_jumpingjack.dart'; 
import 'loseweight_walking.dart';     
import 'summerize.dart'; 
import 'global_data.dart';
import 'data_service.dart';

class LoseweightWorkout extends StatefulWidget {
  const LoseweightWorkout({super.key});

  @override
  State<LoseweightWorkout> createState() => _LoseweightWorkoutState();
}

class _LoseweightWorkoutState extends State<LoseweightWorkout> {
  final List<bool> _isCompleted = [false, false, false];
  final Stopwatch _sessionTimer = Stopwatch();

  @override
  void initState() {
    super.initState();
    GlobalData.totalCalories = 0.0;
    _sessionTimer.start(); 
  }

  bool get _isAllFinished => _isCompleted.every((status) => status == true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1976D2)),
                  ),
                  const Text(
                    'Lose Weight',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1976D2)),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              _buildExerciseCard(0, 'Stretching', '2 min', Icons.accessibility_new_rounded, const LoseweightStretching()),
              _buildExerciseCard(1, 'Jumping Jacks', '1 min', Icons.directions_run_rounded, const LoseweightJumpingjack()),
              _buildExerciseCard(2, 'Walking', '2 min', Icons.directions_walk_rounded, const LoseweightWalking()),
              const Spacer(),
              if (_isAllFinished)
                ElevatedButton(
                  onPressed: () async {
                    _sessionTimer.stop();
                    double kcal = GlobalData.totalCalories;
                    int secs = _sessionTimer.elapsed.inSeconds;
                    await DataService.saveWorkoutData('loseweight', kcal, secs);
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
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  child: const Text('FINISH & SAVE', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(int index, String title, String time, IconData icon, Widget page) {
    bool done = _isCompleted[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: done ? Colors.green.shade50 : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: Icon(icon, color: done ? Colors.green : Colors.blue),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, decoration: done ? TextDecoration.lineThrough : null)),
        onTap: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => page));
          if (res == true) setState(() => _isCompleted[index] = true);
        },
      ),
    );
  }
}