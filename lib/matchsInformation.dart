import 'package:flutter/material.dart';

class MatchsInformation extends StatelessWidget {
  final Map<String, dynamic> matchs;

  var index;

  MatchsInformation({super.key, required this.matchs, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            matchs['response'][index]['teams']['home']['name'].toString() +
                " VS " +
                matchs['response'][index]['teams']['away']['name'].toString()),
      ),
    );
  }
}
