import 'package:shared_preferences/shared_preferences.dart';

class Day {
  String day = "";
  void setDay() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    String date = DateTime.now().toUtc().toIso8601String();
    prefs.setString('day', date);
  }

  Future<bool> checkDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final date = prefs.get('day').toString();
    DateTime dateTime;
    try {
      dateTime = DateTime.parse(date);
    } catch (e) {
      dateTime = DateTime.now().toUtc();
      setDay();

      return true;
    }
    if (DateTime.now().toUtc().day == dateTime.day) {
      return false;
    } else {
      setDay();
      return true;
    }
  }
}
