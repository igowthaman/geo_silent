import 'package:flutter/material.dart';
import 'package:geo_silent/component/savemodal.dart';
import 'package:geo_silent/constant/modal.dart';
import 'package:geo_silent/constant/types.dart';
import 'package:geo_silent/service/db.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class AddPage extends StatefulWidget {
  const AddPage({
    super.key,
    required this.currentLocation,
    required this.getPlaceList,
  });

  final Position currentLocation;
  final Function getPlaceList;

  @override
  _AddPage createState() => _AddPage();
}

class _AddPage extends State<AddPage> {
  final List<LatLng> _polygonPoints = [];
  final Set<Polygon> _polygon = {};
  Set<Marker> _markers = {};

  void updatePolygonAndMarker() async {
    Set<Marker> newMarker = {};
    final BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(128, 128)),
      'assets/images/location_markers.bmp',
    );
    for (var i = 0; i < _polygonPoints.length; i++) {
      newMarker.add(
        Marker(
          markerId: MarkerId(i.toString()),
          draggable: true,
          position: _polygonPoints[i],
          icon: markerIcon,
          anchor: const Offset(0.5, 0.5),
          onDrag: (value) {
            setState(() {
              _polygonPoints[i] = value;
            });
            updatePolygonAndMarker();
          },
          onTap: () {
            setState(() {
              _polygonPoints.removeAt(i);
            });
            updatePolygonAndMarker();
          },
        ),
      );
    }
    setState(() {
      _polygon.add(Polygon(
        polygonId: PolygonId(_polygonPoints.length.toString()),
        points: _polygonPoints,
        strokeColor: Colors.teal,
        strokeWidth: 2,
        fillColor: Colors.teal.withOpacity(0.1),
      ));
      _markers = newMarker.toSet();
    });
  }

  void saveLocation(String name, List days, SoundMode mode) {
    Navigator.pop(context);
    DbManager dbManager = DbManager();
    Place newPlace = Place(
      name: name,
      mode: mode == SoundMode.silent ? 1 : 2,
      days: days.join(','),
      points: _polygonPoints
          .map((e) => '${e.latitude},${e.longitude}')
          .toList()
          .join('|'),
    );
    dbManager.insertPlace(newPlace);
    widget.getPlaceList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 28,
                weight: 900,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Builder(builder: (context) {
          if (_polygonPoints.length < 3) {
            return const Text('');
          }
          return ElevatedButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                isDismissible: false,
                enableDrag: false,
                builder: (BuildContext modalContext) {
                  return SaveModal(
                    closefunction: () => Navigator.pop(modalContext),
                    savefunction: (String name, List days, SoundMode mode) {
                      Navigator.pop(modalContext);
                      saveLocation(name, days, mode);
                    },
                  );
                },
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'Quicksand',
              ),
            ),
          );
        }),
        body: GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onTap: (LatLng latLng) {
            setState(() {
              _polygonPoints.add(latLng);
              updatePolygonAndMarker();
            });
          },
          polygons: _polygon,
          markers: _markers,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.currentLocation.latitude,
              widget.currentLocation.longitude,
            ),
            zoom: 18,
          ),
        ));
  }
}
