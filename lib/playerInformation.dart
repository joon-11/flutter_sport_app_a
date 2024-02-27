import 'package:appbar_animated/appbar_animated.dart';
import 'package:flutter/material.dart';

class PlayerInformation extends StatelessWidget {
  Map<String, dynamic> info;

  PlayerInformation({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(info['player']['name']),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80.0,
                  backgroundImage: NetworkImage(info['player']['photo']),
                ),
                const SizedBox(height: 16.0),
                Text(
                  info['player']['firstname'] +
                      " " +
                      info['player']['lastname'],
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '팀: ${info['statistics'][0]['team']['name']}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '나이: ${info['player']['age']}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '국적: ${info['player']['nationality']}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '선수 소개 및 경력:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  '선수에 대한 간단한 소개나 경력 정보를 입력하세요.',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
