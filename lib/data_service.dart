import 'package:shared_preferences/shared_preferences.dart';

class DataService {
  // ดึงข้อมูลตามหมวดหมู่ (เช่น 'stayhealthy', 'reducestress')
  static Future<Map<String, dynamic>> loadData(String category) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'calories': prefs.getDouble('${category}_calories') ?? 0.0,
      'duration': prefs.getInt('${category}_duration') ?? 0,
    };
  }

  // บันทึกข้อมูลแบบสะสม (ใช้ตอนกด FINISH ในหน้า Workout)
  static Future<void> saveWorkoutData(String category, double newCalories, int newSeconds) async {
    final prefs = await SharedPreferences.getInstance();
    
    double currentCalories = prefs.getDouble('${category}_calories') ?? 0.0;
    int currentDuration = prefs.getInt('${category}_duration') ?? 0;
    
    await prefs.setDouble('${category}_calories', currentCalories + newCalories);
    await prefs.setInt('${category}_duration', currentDuration + newSeconds);
  }

  // รีเซ็ตข้อมูล (ถ้าต้องการเริ่มนับใหม่)
  static Future<void> resetCategoryData(String category) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('${category}_calories', 0.0);
    await prefs.setInt('${category}_duration', 0);
  }
}