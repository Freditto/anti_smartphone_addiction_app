import 'package:ant_smartphone_addiction_app/select_time.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class SelectAppScreen extends StatefulWidget {
  @override
  State<SelectAppScreen> createState() => _SelectAppScreenState();
}

class _SelectAppScreenState extends State<SelectAppScreen> {
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
      body: FutureBuilder<List<AppInfo>>(
        future: InstalledApps.getInstalledApps(true, true),
        builder: (BuildContext buildContext,
            AsyncSnapshot<List<AppInfo>> snapshot) {
          print(snapshot.data![0].packageName);
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        print(snapshot.data![index].packageName);
                        AppInfo app = snapshot.data![index];
                        return Card(
                          // child: SwitchListTile(
                          //   value: _darkMode,
                          //   title: Text(app.name!),
                          //   subtitle: Text(app.getVersionInfo()),
                          //   secondary: Padding(
                          //     padding: const EdgeInsets.all(9.0),
                          //     child: CircleAvatar(
                          //     backgroundColor: Colors.transparent,
                          //     child: Image.memory(app.icon!),
                          //   ),
                          //   ),
                          //   onChanged: (newValue) {
                          //     setState(() {
                          //       _darkMode = newValue;
                          //     });
                          //   },
                          //   // visualDensity: VisualDensity.adaptivePlatformDensity,
                          //   // switchType: SwitchType.material,
                          //   activeColor: Colors.indigo,
                          // ),


                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Image.memory(app.icon!),
                            ),
                            title: Text(app.name!),
                            subtitle: Text(app.getVersionInfo()),
                            onTap: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Select_TimeScreen()));
                            },

                            onLongPress: () =>
                                InstalledApps.openSettings(
                                    app.packageName!),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                          "Error occurred while getting installed apps ...."))
              : Center(child: Text("Getting installed apps ...."));
        },
      ),
    
    );
  }
}
