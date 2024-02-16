import 'dart:math';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_sport/cupInformation.dart';
import 'package:flutter_application_sport/leagueInformation.dart';
import 'package:flutter_application_sport/login.dart';
import 'package:flutter_application_sport/sport_api.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: firstPage(),
    );
  }
}

class firstPage extends StatefulWidget {
  firstPage({super.key});

  @override
  State<firstPage> createState() => _firstPageState();
}

class _firstPageState extends State<firstPage> {
  Map<String, dynamic> leagueTeam = {};
  Future<void>? _teamListFuture;
  String searchText = '';
  var selectOption = 'ft';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _teamListFuture = teamShowing();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110.0),
          child: AppBar(
            backgroundColor: Colors.grey,
            toolbarHeight: 130,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '리그',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: TextField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 16,
                          ),
                          border: InputBorder.none,
                          icon: Padding(
                            padding: EdgeInsets.only(
                              left: 13,
                            ),
                            child: Icon(Icons.search),
                          ),
                          hintText: '원하는 리그 검색',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            CustomRadioButton(
              defaultSelected: 'ft',
              enableShape: true,
              buttonLables: ['football', 'baseball'],
              buttonValues: ['ft', 'bb'],
              radioButtonValue: (p0) {
                setState(
                  () {
                    selectOption = p0;
                  },
                );
              },
              unSelectedColor: Colors.red,
              selectedColor: Colors.yellow,
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              width: 70,
            ),
            if (selectOption == 'ft')
              FutureBuilder(
                future: _teamListFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('데이터 로딩 중 오류 발생'));
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: 100,
                        itemBuilder: (context, index) {
                          var T = leagueTeam['response'][index]['league'];
                          if (searchText.isNotEmpty &&
                              !T['name']
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase())) {
                            return const SizedBox.shrink();
                          }
                          return ListTile(
                            title: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  T['logo'],
                                  width: 5,
                                  height: 50,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              '${T['name']} - ${leagueTeam['response'][index]['country']['name']}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    if (T['type'] == 'Cup') {
                                      return ShowCupInformation(
                                        leagueId: T['id'].toString(),
                                        leagueName: T['name'].toString(),
                                      );
                                    } else {
                                      return ShowDetailInformation(
                                        leagueId: T['id'].toString(),
                                        leagueName: T['name'].toString(),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                },
              )
            else if (selectOption == 'bb')
              Text('야구임!')
          ],
        ),
      ),
    );
  }

  Future<void> teamShowing() async {
    leagueTeam = await sport_api().loadTeam() as Map<String, dynamic>;
  }
}
