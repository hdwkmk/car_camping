//map.dart

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:map_sample/utils.dart';
import 'package:map_sample/map_location.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class MyMap extends StatefulWidget {
  final List<Map<String, String>> csvFiles;

  MyMap({required this.csvFiles});

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  List<MapLocation> _locations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAllLocations();
  }

  Future<void> _loadAllLocations() async {
    List<MapLocation> allLocations = [];
    for (var file in widget.csvFiles) {
      try {
        logger.i('Loading locations from ${file['path']}');
        List<MapLocation> locations = await loadLocationsFromCsv(file['path']!, file['image']!);
        allLocations.addAll(locations);
        logger.i('Loaded ${locations.length} locations from ${file['path']}');
      } catch (e) {
        logger.e('Error loading locations from ${file['path']}', e);
      }
    }
    setState(() {
      _locations = allLocations;
      _loading = false;
    });
    logger.i('Total locations loaded: ${_locations.length}');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: NaverMap(
        options: NaverMapViewOptions(
          symbolScale: 1.2,
          pickTolerance: 2,
          initialCameraPosition: NCameraPosition(target: NLatLng(35.83840532, 128.5603346), zoom: 12),
          mapType: NMapType.basic,
        ),
        onMapReady: (controller) {
          logger.i('Map is ready');
          _addMarkers(controller);
        },
      ),
    );
  }

  Future<void> _addMarkers(NaverMapController controller) async {
    for (var location in _locations) {
      try {
        logger.i('Adding marker for ${location.place} at ${location.latitude}, ${location.longitude}');
        final overlayImage = await NOverlayImage.fromAssetImage(location.imagePath);

        final marker = NMarker(
          id: location.num,
          position: NLatLng(location.latitude, location.longitude),
          icon: overlayImage,
          size: Size(30, 30),
        );

        marker.setOnTapListener((overlay) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(location.place),
                content: Text('전화번호: ${location.number}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('닫기'),
                  ),
                ],
              );
            },
          );
          return true;
        });

        await controller.addOverlay(marker);
        logger.i('Successfully added marker for ${location.place}');
      } catch (e) {
        logger.e('Error adding marker for ${location.place}', e);
      }
    }
  }
}