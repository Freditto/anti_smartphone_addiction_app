import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Info")),
      body: FutureBuilder<AppInfo>(
        future: InstalledApps.getAppInfo("com.google.android.gm"),
        builder: (BuildContext buildContext, AsyncSnapshot<AppInfo> snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
                  ? Center(
                      child: Column(
                        children: [
                          Image.memory(snapshot.data!.icon!),
                          Text(
                            snapshot.data!.name!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                            ),
                          ),
                          Text(snapshot.data!.getVersionInfo())
                        ],
                      ),
                    )
                  : const Center(child: Text("Error while getting app info ...."))
              : const Center(child: Text("Getting app info ...."));
        },
      ),
    );
  }
}