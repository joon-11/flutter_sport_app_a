import 'dart:core';
import 'dart:html';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_sport/Detailranking.dart';
import 'package:flutter_application_sport/leagueDetail.dart';
import 'package:flutter_application_sport/matchsInformation.dart';
import 'package:flutter_application_sport/sport_api.dart';
import 'package:http/http.dart';

class ShowDetailInformation extends StatefulWidget {
  final leagueId;
  final leagueName;

  ShowDetailInformation({
    Key? key,
    required this.leagueId,
    required this.leagueName,
  }) : super(key: key);

  @override
  State<ShowDetailInformation> createState() => _ShowDetailInformationState();
}

class _ShowDetailInformationState extends State<ShowDetailInformation> {
  List id = ['Matchs', 'Rank', 'Record'];
  String selectedOption = 'Rank';
  final _years = ['2020', '2021', '2022', '2023'];
  String selectYear = '2023';
  Map<String, dynamic> ranking = {};
  Map<String, dynamic> topScorers = {};
  Map<String, dynamic> topAssist = {};
  Map<String, dynamic> topRedcard = {};
  Map<String, dynamic> topYellowcard = {};
  Map<String, dynamic> matchs = {};


  @override
  Widget build(BuildContext context) {
    var futureBuilderMatchs = FutureBuilder(
      future: showMatchs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else {
          return Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                var m = matchs['response'][index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchsInformation(
                          matchs: matchs,
                          index: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(m['teams']['home']['logo']),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                m['teams']['home']['name'].toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                '현지시간 ${m['fixture']['date'].toString().replaceAll(':00+00:00', '').replaceAll('T', '\n')}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.network(m['teams']['away']['logo']),
                              const SizedBox(height: 16.0),
                              Text(
                                m['teams']['away']['name'].toString(),
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: matchs['response'].length,
            ),
          );
        }
      },
    );
    var futureBuilderRank = FutureBuilder(
      future: showRank(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else {
          return Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                var r = ranking['response'][0]['league']['standings'][0][index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Image.network(r['team']['logo']),
                  ),
                  title: Text('${r['rank']}. ${r['team']['name']}'),
                  subtitle: Text(r['form'].toString()),
                  trailing: Text(
                    r['points'].toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FootballTeamInformation(
                          id: r['team']['id'].toString(),
                          leagueId: widget.leagueId,
                          season: selectYear,
                          name: r['team']['name'].toString(),
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount:
                  ranking['response'][0]['league']['standings'][0].length,
            ),
          );
        }
      },
    );

    var futureBuilderRecord = SingleChildScrollView(
      child: FutureBuilder(
        future: showRecord(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            return Column(
              children: [
                ExpansionTile(
                  initiallyExpanded: false,
                  title: Text('득점순위'),
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var score = topScorers['response'][index]['player'];
                        return ListTile(
                          leading: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                )),
                            child: Image.network(
                              score['photo'],
                            ),
                          ),
                          title: Text(
                            '${index + 1}. ${score['name']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: Text(
                            topScorers['response'][index]['statistics'][0]
                                    ['goals']['total']
                                .toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      },
                      itemCount: 5,
                      separatorBuilder: (context, index) => const Divider(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ExpansionTile(
                  initiallyExpanded: false,
                  title: Text('어시스트 순위'),
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var assist = topAssist['response'][index]['player'];
                        return ListTile(
                          leading: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                )),
                            child: Image.network(
                              assist['photo'],
                            ),
                          ),
                          title: Text(
                            '${index + 1}. ${assist['name']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: Text(
                            topAssist['response'][index]['statistics'][0]
                                    ['goals']['assists']
                                .toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      },
                      itemCount: 5,
                      separatorBuilder: (context, index) => const Divider(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ExpansionTile(
                  initiallyExpanded: false,
                  title: Text('레드카드 순위'),
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var red = topRedcard['response'][index]['player'];
                        return ListTile(
                          leading: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                )),
                            child: Image.network(
                              red['photo'],
                            ),
                          ),
                          title: Text(
                            '${index + 1}. ${red['name']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: Text(
                            topRedcard['response'][index]['statistics'][0]
                                    ['cards']['red']
                                .toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      },
                      itemCount: 5,
                      separatorBuilder: (context, index) => const Divider(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ExpansionTile(
                  initiallyExpanded: false,
                  title: Text('레드카드 순위'),
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var yellow = topYellowcard['response'][index]['player'];
                        return ListTile(
                          leading: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                )),
                            child: Image.network(
                              yellow['photo'],
                            ),
                          ),
                          title: Text(
                            '${index + 1}. ${yellow['name']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: Text(
                            topYellowcard['response'][index]['statistics'][0]
                                    ['cards']['yellow']
                                .toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      },
                      itemCount: 5,
                      separatorBuilder: (context, index) => const Divider(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 300,
                )
              ],
            );
          }
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.leagueName,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Center(
            child: DropdownButton(
              value: selectYear,
              items: _years
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectYear = value!;
                });
              },
            ),
          ),
          CustomRadioButton(
            enableShape: true,
            defaultSelected: selectedOption,
            buttonLables: const [
              '경기',
              '순위',
              '기록',
            ],
            buttonValues: id,
            radioButtonValue: (p0) {
              setState(
                () {
                  selectedOption = p0;
                },
              );
            },
            unSelectedColor: Colors.yellow,
            selectedColor: Colors.red,
          ),
          if (selectedOption == id[0]) futureBuilderMatchs,
          if (selectedOption == id[1]) futureBuilderRank,
          if (selectedOption == id[2]) futureBuilderRecord,
        ],
      ),
    );
  }

  Future<void> showRank() async {
    ranking = await sport_api().getStandings(selectYear, widget.leagueId)
        as Map<String, dynamic>;
    print(ranking);
  }

  Future<void> showRecord() async {
    topScorers = await sport_api().getTopScorers(widget.leagueId, selectYear)
        as Map<String, dynamic>;
    topAssist = await sport_api().getTopAssist(widget.leagueId, selectYear)
        as Map<String, dynamic>;
    topRedcard = await sport_api().getTopRedcard(widget.leagueId, selectYear)
        as Map<String, dynamic>;
    topYellowcard = await sport_api()
        .getTopYellowcard(widget.leagueId, selectYear) as Map<String, dynamic>;
  }

  Future<void> showMatchs() async {
    matchs = await sport_api().matchsInformation(widget.leagueId, selectYear)
        as Map<String, dynamic>;
  }
}
