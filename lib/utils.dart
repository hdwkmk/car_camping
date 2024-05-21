//utils.dart

import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:map_sample/map_location.dart';
import 'package:logger/logger.dart';

final logger = Logger();

Future<List<MapLocation>> loadLocationsFromCsv(String csvFilePath, String imagePath) async {
  final locations = <MapLocation>[];

  try {
    final csvString = await rootBundle.loadString(csvFilePath);
    final List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);

    for (var row in rowsAsListOfValues.skip(1)) {
      if (row.length < 5) {
        logger.w('Skipping row with insufficient data: $row');
        continue;
      }

      try {
        final location = MapLocation(
          num: row[0].toString(),
          place: row[1].toString(),
          number: row[2].toString(),
          latitude: double.parse(row[3].toString()),
          longitude: double.parse(row[4].toString()),
          imagePath: imagePath,
        );
        locations.add(location);
      } catch (e) {
        logger.e('Error parsing row: $row', e);
      }
    }
    logger.i('Loaded ${locations.length} locations from $csvFilePath');
  } catch (e) {
    logger.e('Error loading CSV: $csvFilePath', e);
  }

  return locations;
}