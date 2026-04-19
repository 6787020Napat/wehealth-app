import 'package:flutter/material.dart';
import 'buildstrength_pushup.dart';
import 'buildstrenght_squat.dart';
import 'buildstrength_situp.dart';
import 'summerize.dart'; 
import 'global_data.dart';
import 'data_service.dart';

class BuildstrengthWorkout extends StatefulWidget {
  const BuildstrengthWorkout({super.key});

  @override
  State<BuildstrengthWorkout> createState() => _BuildstrengthWorkoutState();
}

class _BuildstrengthWorkoutState extends State<BuildstrengthWorkout> {
  final Set<String> _completed = {};
  final Stopwatch _sessionTimer = Stopwatch();

  @override
  void initState() {
    super.initState();
    GlobalData.totalCalories = 0.0;
    _sessionTimer.start();
  }

  @override
  Widget build(BuildContext context) {
    bool isAllDone = _completed.length >= 3;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new)),
                  const Text('Build Strength', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              _buildTile('Push Ups', const BuildstrengthPushup()),
              _buildTile('Squats', const BuildstrengthSquat()),
              _buildTile('Sit Ups', const BuildstrengthSitup()),
              const Spacer(),
              if (isAllDone)
                ElevatedButton(
                  onPressed: () async {
                    _sessionTimer.stop();
                    double kcal = GlobalData.totalCalories;
                    int secs = _sessionTimer.elapsed.inSeconds;
                    await DataService.saveWorkoutData('buildstrength', kcal, secs);
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
                  child: const Text('Finish Strength Training'),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(String title, Widget page) {
    bool done = _completed.contains(title);
    return ListTile(
      title: Text(title),
      trailing: Icon(done ? Icons.check_circle : Icons.play_arrow, color: done ? Colors.green : Colors.grey),
      onTap: () async {
        final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        if (res == true) setState(() => _completed.add(title));
      },
    );
  }
}