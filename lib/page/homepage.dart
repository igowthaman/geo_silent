import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geo_silent/constant/modal.dart';
import 'package:geo_silent/page/addpage.dart';
import 'package:geo_silent/page/loadingpage.dart';
import 'package:geo_silent/page/nopermissionpage.dart';
import 'package:geo_silent/service/db.dart';
import 'package:geo_silent/service/location.dart';
import 'package:geo_silent/service/permission.dart';
import 'package:geo_silent/service/sound.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RingerModeStatus _soundMode = RingerModeStatus.unknown;
  bool? _permissionStatus;
  Position? _currentLocation;
  List<Place> _placeList = [];
  Set<Polygon> _polygon = {};

  Future<void> updateSoundStatus() async {
    RingerModeStatus soundModeStatus = await getCurrentSoundProfile();
    setState(() {
      _soundMode = soundModeStatus;
    });
  }

  Future<bool> updatePermissionStatus() async {
    List<PermissionStatus> permissionStatus = await getPermissionStatus();
    bool status =
        permissionStatus[0].isGranted && permissionStatus[1].isGranted;
    setState(() {
      _permissionStatus = status;
    });
    updateSoundStatus();
    loadData();
    return status;
  }

  void setSoundMode(type) {
    setSoundProfile(type);
    updateSoundStatus();
  }

  void getPermission() async {
    setState(() {
      _permissionStatus = null;
    });
    List<PermissionStatus> permissionStatus = [
      PermissionStatus.denied,
      PermissionStatus.denied
    ];
    permissionStatus[0] = await requestLocationPermission();
    permissionStatus[1] = await requestSoundPermission();
    updatePermissionStatus();
  }

  void loadData() async {
    Position position = await getCurrentLocation();
    setState(() {
      _currentLocation = position;
    });
    getPlaceList();
  }

  void deletePlace(id) async {
    DbManager db = DbManager();
    await db.deletePlace(id);
    getPlaceList();
  }

  void updatePolygon() {
    Set<Polygon> polygonSet = {};
    for (var i = 0; i < _placeList.length; i++) {
      List<LatLng> pointsList =
          _placeList[i].points.split('|').map((String str) {
        List<String> point = str.split(',');
        return LatLng(double.parse(point[0]), double.parse(point[1]));
      }).toList();
      polygonSet.add(Polygon(
        polygonId: PolygonId(_placeList[i].name),
        geodesic: true,
        points: pointsList,
        strokeColor: Colors.teal,
        strokeWidth: 2,
        fillColor: Colors.teal.withOpacity(0.1),
      ));
    }
    setState(() {
      _polygon = polygonSet;
    });
  }

  void getPlaceList() async {
    DbManager db = DbManager();
    List<Place> placeList = await db.getPlaceList();
    setState(() {
      _placeList = placeList;
    });
    updatePolygon();
  }

  @override
  void initState() {
    super.initState();
    updatePermissionStatus().then((status) {
      if (!status) {
        getPermission();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionStatus == null) {
      return const LoadingPage();
    }
    if (!_permissionStatus!) {
      return NoPermissionPage(getPermission: getPermission);
    }
    if (_currentLocation == null) {
      return const LoadingPage();
    }
    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              height: 0.9 * MediaQuery.of(context).size.height,
              child: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                indoorViewEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      _currentLocation!.latitude, _currentLocation!.longitude),
                  zoom: 17,
                ),
                polygons: _polygon,
              ),
            );
          }),
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            maxChildSize: 0.5,
            minChildSize: 0.2,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    height: 0.48 * MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 0,
                          color: Colors.white,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(13, 0, 0, 0),
                            spreadRadius: 3,
                            blurRadius: 5,
                          )
                        ],
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0,
                                color: Colors.grey[400]!,
                              ),
                              color: Colors.grey[400],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            width: 100,
                            height: 4,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 12, bottom: 12, top: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Places',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return AddPage(
                                          currentLocation: _currentLocation!,
                                          loadData: loadData,
                                        );
                                      },
                                    ),
                                  )
                                },
                                icon: const Icon(
                                  Icons.add,
                                  weight: 900,
                                  size: 28,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _placeList.isEmpty
                              ? const Text('No Places Added')
                              : ListView.builder(
                                  padding: const EdgeInsets.all(0.0),
                                  shrinkWrap: true,
                                  itemCount: _placeList.length,
                                  itemBuilder: (context, index) {
                                    Place place = _placeList[index];
                                    List<String> daysIds =
                                        place.days.split(',');
                                    daysIds.sort();
                                    Map<String, String> daysIdToString = {
                                      '0': 'Sun',
                                      '1': 'Mon',
                                      '2': 'Tue',
                                      '3': 'Wed',
                                      '4': 'Thu',
                                      '5': 'Fri',
                                      '6': 'Sat',
                                    };

                                    List<String?> daysString = daysIds
                                        .map((e) => daysIdToString[e])
                                        .toList();

                                    return Card(
                                      child: ListTile(
                                        leading: const Icon(Icons.place_sharp),
                                        title: Text(place.name),
                                        subtitle: Text(daysString.join(',')),
                                        trailing: IconButton(
                                          onPressed: () {
                                            deletePlace(place.id);
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
