// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'dart:convert';
void main() {
  final item = [
        {
      "sports_results": {
        "title": "Premier League standings",
        "thumbnail": "https://serpapi.com/searches/648a8057770844b0c5e614c1/images/d5f5ffc19b0f0c6a1e9ff9d681ce2d8b99855320524fac9b29eef510fce88fd9.png",
        "season": "2022–23",
        "round": "Regular season",
        "league": {
          "standings": [
            {
              "team": {
                "thumbnail": "https://serpapi.com/searches/648a8057770844b0c5e614c1/images/d5f5ffc19b0f0c6a559b830ff173e5f2afaf6d05565be226866c6f7f1a6875bf5fe6de2dd724a0f79d1bb9733fcb0f51f681678631ac1a2c.png",
                "name": "Man City"
              },
              "pos": "1",
              "mp": "38",
              "w": "28",
              "d": "5",
              "l": "5",
              "gf": "94",
              "ga": "33",
              "gd": "61",
              "pts": "89",
              "last_5": [
                "loss",
                "tie",
                "win",
                "win",
                "win"
              ]
            },
            {
              "team": {
                "thumbnail": "https://serpapi.com/searches/648a8057770844b0c5e614c1/images/d5f5ffc19b0f0c6a559b830ff173e5f2afaf6d05565be226866c6f7f1a6875bf7b93fedb1e0e043a7109f9b4a3eb41467edec8f5f6b1d4da.png",
                "name": "Arsenal"
              },
              "pos": "2",
              "mp": "38",
              "w": "26",
              "d": "6",
              "l": "6",
              "gf": "88",
              "ga": "43",
              "gd": "45",
              "pts": "84",
              "last_5": [
                "win",
                "loss",
                "loss",
                "win",
                "win"
              ]
            },
            {
              "team": {
                "thumbnail": "https://serpapi.com/searches/648a8057770844b0c5e614c1/images/d5f5ffc19b0f0c6a559b830ff173e5f2afaf6d05565be226866c6f7f1a6875bf066947bf5371a46b2b61d253359f10bff6d6d6498094cfb9.png",
                "name": "Man United"
              },
              "pos": "3",
              "mp": "38",
              "w": "23",
              "d": "6",
              "l": "9",
              "gf": "58",
              "ga": "43",
              "gd": "15",
              "pts": "75",
              "last_5": [
                "win",
                "win",
                "win",
                "win",
                "loss"
              ]
            },
          ]
        }
      },
    }
  ];
  print(json.encode(item));
}
