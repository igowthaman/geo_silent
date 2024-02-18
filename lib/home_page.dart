import 'package:flutter/material.dart';
import 'package:geo_silent/permission.dart';
import 'package:geo_silent/sound_profile.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RingerModeStatus _soundMode = RingerModeStatus.unknown;
  bool? _permissionStatus;

  SoundProfile profile = SoundProfile();

  Future<void> updateSoundStatus() async {
    RingerModeStatus soundModeStatus = await profile.getCurrentSoundMode();
    setState(() {
      _soundMode = soundModeStatus;
    });
  }

  Future<bool> updatePermissionStatus() async {
    List<PermissionStatus> permissionStatus = await getPermissionStatus();
    setState(() {
      _permissionStatus =
          permissionStatus[0].isGranted && permissionStatus[1].isGranted;
    });
    return permissionStatus[0].isGranted && permissionStatus[1].isGranted;
  }

  void setSoundMode(type) {
    profile.setProfile(type);
    updateSoundStatus();
  }

  void getPermission() async {
    setState(() {
      _permissionStatus = null;
    });
    List<PermissionStatus> permissionStatus = await getPermissionStatus();
    if (!permissionStatus[0].isGranted) {
      permissionStatus[0] = await requestLocationPermission();
    }
    if (!permissionStatus[1].isGranted) {
      permissionStatus[1] = await requestSoundPermission();
    }
    updatePermissionStatus();
  }

  @override
  void initState() {
    super.initState();
    updateSoundStatus();
    updatePermissionStatus().then((value) => {
          if (!value) {getPermission()}
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionStatus == null) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[CircularProgressIndicator()],
          ),
        ),
      );
    }
    if (!_permissionStatus!) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "Geo Silent",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/permission_denied.svg',
                width: 300,
                height: 300,
              ),
              const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "We require access to your device's location and sound settings to continue",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                    textAlign: TextAlign.center,
                  )),
              TextButton(
                  onPressed: getPermission, child: const Text('Continue'))
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Column(children: [
            Text(
              "Geo Silent",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
          ])),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_soundMode',
            ),
            TextButton(
                onPressed: () => setSoundMode(1), child: const Text("Silent")),
            TextButton(
                onPressed: () => setSoundMode(0), child: const Text("Normal")),
            TextButton(
                onPressed: () => setSoundMode(2), child: const Text("Vibrate"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
