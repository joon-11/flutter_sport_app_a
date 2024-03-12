import 'dart:ffi';

import 'package:flutter/material.dart';

class MatchsInformation extends StatelessWidget {
  Int id;

  MatchsInformation({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    print(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(id as String),
      ),
    );
  }
}
