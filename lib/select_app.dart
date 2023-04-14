import 'package:ant_smartphone_addiction_app/select_time.dart';
import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:usage_stats/usage_stats.dart';

class SelectAppScreen extends StatefulWidget {
  @override
  State<SelectAppScreen> createState() => _SelectAppScreenState();
}

class _SelectAppScreenState extends State<SelectAppScreen> {
  List<AppInfo>? app_list_data;

  List<AppUsageInfo> _infos = [];

  @override
  void initState() {
    fetchSocialMediaOnlysData();
    initUsage();
    super.initState();


  }

  final List<String> _app_packageNames = [
    'com.instagram.android', // instagram

    // 'com.facebook.orca' // facebook
    'com.facebook.katana' // facebook
        // 'com.example.facebook' // facebook
        // 'com.facebook.android' // facebook

        'com.twitter.android', // twitter
    'com.zhiliaoapp.musically', // ticktok
    'com.whatsapp', // whatsapp
  ];

  fetchSocialMediaOnlysData() async {
    List<AppInfo> _app_list_items = [];

    for (AppInfo info in await InstalledApps.getInstalledApps(true, true)) {
      if (_app_packageNames.contains(info.packageName)) {
        _app_list_items.add(info);
      }
    }

    setState(() {
      app_list_data = _app_list_items;
      // next = body['next'];
    });

    return [];
  }

  List<EventUsageInfo> events = [];
  Map<String?, NetworkInfo?> _netInfoMap = Map();

  
  Future<void> initUsage() async {
    try {
      UsageStats.grantUsagePermission();

      DateTime endDate = new DateTime.now();
      DateTime startDate = endDate.subtract(Duration(days: 1));

      List<EventUsageInfo> queryEvents =
          await UsageStats.queryEvents(startDate, endDate);
      List<NetworkInfo> networkInfos = await UsageStats.queryNetworkUsageStats(
        startDate,
        endDate,
        networkType: NetworkType.all,
      );

      Map<String?, NetworkInfo?> netInfoMap = Map.fromIterable(networkInfos,
          key: (v) => v.packageName, value: (v) => v);

      List<UsageInfo> t = await UsageStats.queryUsageStats(startDate, endDate);

      for (var i in t) {
        if (double.parse(i.totalTimeInForeground!) > 0) {
          print(
              DateTime.fromMillisecondsSinceEpoch(int.parse(i.firstTimeStamp!))
                  .toIso8601String());

          print(DateTime.fromMillisecondsSinceEpoch(int.parse(i.lastTimeStamp!))
              .toIso8601String());

          print(i.packageName);
          print(DateTime.fromMillisecondsSinceEpoch(int.parse(i.lastTimeUsed!))
              .toIso8601String());
          print(int.parse(i.totalTimeInForeground!) / 1000 / 60);

          print('-----\n');
        }
      }

      this.setState(() {
        events = queryEvents.reversed.toList();
        _netInfoMap = netInfoMap;
      });
    } catch (err) {
      print(err);
    }
  }

  void getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(hours: 1));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);
      setState(() => _infos = infoList);

      for (var info in infoList) {
        print(info.toString());
      }
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text('Select App', style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onPressed: () async {
              // do something

              // Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => SelectAppScreen()));

              // final PermissionStatus permissionStatus =
              //     await _getPermission();
              // if (permissionStatus ==
              //     PermissionStatus.granted) {
              //   //We can now access our contacts here

              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) =>
              //               SelectContactScreen()));
              // } else {
              //   //If permissions have been denied show standard cupertino alert dialog
              //   showDialog(
              //       context: context,
              //       builder: (BuildContext context) =>
              //           CupertinoAlertDialog(
              //             title:
              //                 Text('Permissions error'),
              //             content: Text(
              //                 'Please enable contacts access '
              //                 'permission in system settings'),
              //             actions: <Widget>[
              //               CupertinoDialogAction(
              //                 child: Text('OK'),
              //                 onPressed: () =>
              //                     Navigator.of(context)
              //                         .pop(),
              //               )
              //             ],
              //           ));
              // }
            },
          )
        ],
      ),
      // body: FutureBuilder<List<AppInfo>>(
      //   future: InstalledApps.getInstalledApps(true, true),
      //   builder: (BuildContext buildContext,
      //       AsyncSnapshot<List<AppInfo>> snapshot) {
      //     print(snapshot.data![0].packageName);
      //     return snapshot.connectionState == ConnectionState.done
      //         ? snapshot.hasData
      //             ? ListView.builder(
      //                 itemCount: snapshot.data!.length,
      //                 itemBuilder: (context, index) {
      //                   print(snapshot.data![index].packageName);
      //                   AppInfo app = snapshot.data![index];
      //                   return Card(
      //                     // child: SwitchListTile(
      //                     //   value: _darkMode,
      //                     //   title: Text(app.name!),
      //                     //   subtitle: Text(app.getVersionInfo()),
      //                     //   secondary: Padding(
      //                     //     padding: const EdgeInsets.all(9.0),
      //                     //     child: CircleAvatar(
      //                     //     backgroundColor: Colors.transparent,
      //                     //     child: Image.memory(app.icon!),
      //                     //   ),
      //                     //   ),
      //                     //   onChanged: (newValue) {
      //                     //     setState(() {
      //                     //       _darkMode = newValue;
      //                     //     });
      //                     //   },
      //                     //   // visualDensity: VisualDensity.adaptivePlatformDensity,
      //                     //   // switchType: SwitchType.material,
      //                     //   activeColor: Colors.indigo,
      //                     // ),

      //                     child: ListTile(
      //                       leading: CircleAvatar(
      //                         backgroundColor: Colors.transparent,
      //                         child: Image.memory(app.icon!),
      //                       ),
      //                       title: Text(app.name!),
      //                       subtitle: Text(app.getVersionInfo()),
      //                       onTap: () {
      //                         Navigator.push(context,
      //                           MaterialPageRoute(builder: (context) => Select_TimeScreen()));
      //                       },

      //                       onLongPress: () =>
      //                           InstalledApps.openSettings(
      //                               app.packageName!),
      //                     ),
      //                   );
      //                 },
      //               )
      //             : Center(
      //                 child: Text(
      //                     "Error occurred while getting installed apps ...."))
      //         : Center(child: Text("Getting installed apps ...."));
      //   },
      // ),

      body: social_mediaComponent(),
    );
  }

  social_mediaComponent() {
    if (app_list_data == null) {
      return Container(
        child: Center(child: Text('Loading...')),
        // color: Colors.black,
        // size: 50.0,
      );
    } else if (app_list_data != null && app_list_data?.length == 0) {
      // No Data
      return Column(children: [
        Image.asset("assets/images/no_data.gif"),
        // Text(
        //   AppLocalizations.of(context)!.no_shipped,
        //   style: TextStyle(fontSize: 18),
        // )
      ]);
    } else {
      return ListView.builder(
        itemCount: app_list_data!.length,
        itemBuilder: (context, index) {
          AppInfo app = app_list_data![index];
          // return Card(
          //   child: SwitchListTile(
          //     value: _darkMode,
          //     title: Text(app.name!),
          //     subtitle: Text(app.getVersionInfo()),
          //     secondary: Padding(
          //       padding: const EdgeInsets.all(9.0),
          //       child: CircleAvatar(
          //         backgroundColor: Colors.transparent,
          //         child: Image.memory(app.icon!),
          //       ),
          //     ),
          //     onChanged: (newValue) {
          //       setState(() {
          //         _darkMode = newValue;
          //       });
          //     },
          //     // visualDensity: VisualDensity.adaptivePlatformDensity,
          //     // switchType: SwitchType.material,
          //     activeColor: Colors.indigo,
          //   ),

          return InkWell(
            onTap: () {
              print(app.packageName);
              // getUsageStats();
              
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Select_TimeScreen(app.packageName)));
            },
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Image.memory(app.icon!),
                ),
                title: Text(app.name!),
                subtitle: Text(app.getVersionInfo()),
                // onTap: () =>
                //     InstalledApps.startApp(app.packageName!),
                // onLongPress: () =>
                //     InstalledApps.openSettings(
                //         app.packageName!),
              ),
            ),
          );
        },
      );
    }
  }
}
