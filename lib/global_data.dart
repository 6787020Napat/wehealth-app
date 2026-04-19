// global_data.dart
class GlobalData {
  static int totalSteps = 0;
  static double totalCalories = 0.0;

  // ฟังก์ชันช่วยบวกแคลอรี่
  static void addCalories(double amount) {
    totalCalories += amount;
  }

  // ฟังก์ชันช่วยอัปเดตก้าวเดิน
  static void updateSteps(int steps) {
    totalSteps = steps;
  }
}