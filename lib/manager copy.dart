import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SilentTime {
  final String id;

  String silent_name;
  DateTime time;
  bool daily;
  bool weekly;
  String end_time_interval;

  SilentTime(
    this.id,
    this.time,
    this.silent_name,
    this.daily,
    this.weekly,
    this.end_time_interval,
  );

  static const SILENT_TIME_PREF_KEY = 'silent_time';

  static Future<List> querySilent_time() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var pref_silent_time_data =
        sharedPreferences.getString(SILENT_TIME_PREF_KEY);
    if (pref_silent_time_data != null) {
      return json.decode(pref_silent_time_data);
    }

    return [];
  }

  static void insertSilentTime(silent_data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(SILENT_TIME_PREF_KEY, json.encode(silent_data));
  }

  static Future<List<SilentTime>> allSilentTimes() async {
    List<SilentTime> silentTime_list = [];
    List silent_time_data = await SilentTime.querySilent_time();
    for (var data in silent_time_data) {
      // print("From the SharedPreferences");
      // print(cart['quantity'].runtimeType);
      // print(cart['quantity']);
      silentTime_list.add(SilentTime(
        data["id"],
        DateTime.parse(data['time']),
        data["silent_name"],
        data["daily"],
        data["weekly"],
        data["end_time_interval"],
      ));
    }

    return silentTime_list;
  }

  static isSilentTime(String id, List sells_cart_data) {
    for (var sell_cart in sells_cart_data) {
      if (sell_cart['id'] == id) {
        return true;
      }
    }
    return false;
  }

  static clearSilentTime() async {
    SilentTime.insertSilentTime([]);
  }

  static remove(String id) async {
    List silentTime_list = await SilentTime.querySilent_time();
    for (int i = 0; i < silentTime_list.length; i++) {
      if (silentTime_list[i]['id'] == id) {
        silentTime_list.removeAt(i);
      }
    }
    SilentTime.insertSilentTime(silentTime_list);
  }

  static addToSilentTime(
      time, silent_name, daily, weekly, end_time_interval) async {
    List silent_time_data = await SilentTime.querySilent_time();
    String id = const Uuid().v4();
    if (SilentTime.isSilentTime(id, silent_time_data) == false) {
      print("Is already");
      // print('Adding');
      // print(quantity);
      silent_time_data.add({
        "id": id,
        "time": time,
        "silent_name": silent_name,
        "daily": daily,
        "weekly": weekly,
        "end_time_interval": end_time_interval,
      });

      SilentTime.insertSilentTime(silent_time_data);
    }
  }
}
