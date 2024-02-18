import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> requestLocationPermission() async {
  await Permission.location.request();
  var status = await Permission.locationAlways.request();
  return status;
}

Future<PermissionStatus> requestSoundPermission() async {
  var status = await Permission.accessNotificationPolicy.request();
  return status;
}

Future<List<PermissionStatus?>> requestPermission() async {
  Map<Permission, PermissionStatus> status = await [
    Permission.location,
    Permission.locationAlways,
    Permission.accessNotificationPolicy,
  ].request();
  return [status[Permission.locationAlways], status[Permission.accessNotificationPolicy]];
}

void openPermissionSettings() async {
  await openAppSettings();
}

Future<List<PermissionStatus>> getPermissionStatus() async {
  var locationStatus = await Permission.locationAlways.status;
  var soundStatus = await Permission.accessNotificationPolicy.status;
  return [locationStatus, soundStatus];
}
