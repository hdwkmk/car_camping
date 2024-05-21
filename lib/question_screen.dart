//question_screen.dart

import 'package:flutter/material.dart';
import 'package:map_sample/map.dart';

class QuestionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지도로 이동'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final csvFiles = [
              {'path': 'assets/restroom.csv', 'image': 'assets/images/restroom.webp'},
              {'path': 'assets/locations.csv', 'image': 'assets/images/sunny.jpeg'}
            ];

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyMap(csvFiles: csvFiles)),
            );
          },
          child: const Text('지도로 이동'),
        ),
      ),
    );
  }
}