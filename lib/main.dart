//main.dart

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:map_sample/question_screen.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
    clientId: "2f9jiniswu",
    onAuthFailed: (ex) {
      logger.e("네이버맵 인증 오류", ex);
    },
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('편안차박'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/sunny.jpeg",
              width: 200,
            ),
            const Text(
              '편안차박',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuestionScreen()),
                );
              },
              child: const Text('시작하기'),
            ),
          ],
        ),
      ),
    );
  }
}