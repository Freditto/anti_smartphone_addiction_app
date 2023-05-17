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
    var prefSilentTimeData =
        sharedPreferences.getString(SILENT_TIME_PREF_KEY);
    if (prefSilentTimeData != null) {
      return json.decode(prefSilentTimeData);
    }

    return [];
  }

  static void insertSilentTime(silentData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(SILENT_TIME_PREF_KEY, json.encode(silentData));
  }

  static Future<List<SilentTime>> allSilentTimes() async {
    List<SilentTime> silenttimeList = [];
    List silentTimeData = await SilentTime.querySilent_time();
    for (var data in silentTimeData) {
      // print("From the SharedPreferences");
      // print(cart['quantity'].runtimeType);
      // print(cart['quantity']);
      silenttimeList.add(SilentTime(
        data["id"],
        DateTime.parse(data['time']),
        data["silent_name"],
        data["daily"],
        data["weekly"],
        data["end_time_interval"],
      ));
    }

    return silenttimeList;
  }

  static isSilentTime(String id, List sellsCartData) {
    for (var sell_cart in sellsCartData) {
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
    List silenttimeList = await SilentTime.querySilent_time();
    for (int i = 0; i < silenttimeList.length; i++) {
      if (silenttimeList[i]['id'] == id) {
        silenttimeList.removeAt(i);
      }
    }
    SilentTime.insertSilentTime(silenttimeList);
  }

  static addToSilentTime(
      time, silentName, daily, weekly, endTimeInterval) async {
    List silentTimeData = await SilentTime.querySilent_time();
    String id = const Uuid().v4();
    if (SilentTime.isSilentTime(id, silentTimeData) == false) {
      print("Is already");
      // print('Adding');
      // print(quantity);
      silentTimeData.add({
        "id": id,
        "time": time,
        "silent_name": silentName,
        "daily": daily,
        "weekly": weekly,
        "end_time_interval": endTimeInterval,
      });

      SilentTime.insertSilentTime(silentTimeData);
    }
  }
}
