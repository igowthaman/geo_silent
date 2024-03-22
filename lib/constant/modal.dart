import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  int id;
  String name;
  int mode;
  String days;
  String points;

  Place({
    this.id = -1,
    required this.name,
    required this.mode,
    required this.days,
    required this.points,
  });

  Map<String, dynamic> toJson() {
    return {"name": name, "mode": mode, "days": days, "points": points};
  }

  Map<String, dynamic> toPlace() {
    List<int> daysList =
        days.split(',').map((String str) => int.parse(str)).toList();

    List<LatLng> pointsList = points.split('|').map((String str) {
      List<String> point = str.split(',');
      return LatLng(double.parse(point[0]), double.parse(point[1]));
    }).toList();

    return {
      "id": id,
      "name": name,
      "mode": mode,
      "days": daysList,
      "points": pointsList,
    };
  }
}
