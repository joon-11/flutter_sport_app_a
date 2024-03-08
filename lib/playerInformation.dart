import 'dart:async';

import 'package:appbar_animated/appbar_animated.dart';
import 'package:flutter/material.dart';

class PlayerInformation extends StatelessWidget {
  final Map<String, dynamic> playerInfo;

  PlayerInformation({
    Key? key,
    required this.playerInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${playerInfo['player']['firstname']} ${playerInfo['player']['lastname']}',
        ),
      ),
      body: SingleChildScrollView(
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ), // Set the desired text size here
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(playerInfo['player']['photo']),
                const SizedBox(height: 16),
                const Text(
                  '기본 정보',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('나이: ${playerInfo['player']['age']}'),
                Text('출생일: ${playerInfo['player']['birth']['date']}'),
                Text(
                  '출생지: ${playerInfo['player']['birth']['place']}, ${playerInfo['player']['birth']['country']}',
                ),
                Text('국적: ${playerInfo['player']['nationality']}'),
                Text('키: ${playerInfo['player']['height']}'),
                Text('몸무게: ${playerInfo['player']['weight']}'),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
