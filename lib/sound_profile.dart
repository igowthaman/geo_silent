import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

class SoundProfile {
  Future<RingerModeStatus> getCurrentSoundMode() async {
    RingerModeStatus status = RingerModeStatus.unknown;
    try {
      status = await SoundMode.ringerModeStatus;
    } catch (err) {
      status = RingerModeStatus.unknown;
    }
    print('******************** $status');
    return status;
  }

  Future<bool> setSilentMode() async {
    try {
      await SoundMode.setSoundMode(RingerModeStatus.silent);
      return true;
    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
    return false;
  }

  Future<bool> setNormalMode() async {
    try {
      await SoundMode.setSoundMode(RingerModeStatus.normal);
      return true;
    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
    return false;
  }

  Future<bool> setVibrateMode() async {
    try {
      await SoundMode.setSoundMode(RingerModeStatus.vibrate);
      return true;
    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
    return false;
  }

  void setProfile(type) async {
    try {
      switch (type) {
        case 0:
          {
            SoundMode.setSoundMode(RingerModeStatus.normal);
            break;
          }
        case 1:
          {
            SoundMode.setSoundMode(RingerModeStatus.silent);
            break;
          }
        case 2:
          {
            SoundMode.setSoundMode(RingerModeStatus.vibrate);
            break;
          }
      }
    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
  }
}
