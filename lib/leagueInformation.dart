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
  List id = ['Matchs', 'News', 'Rank', 'Record'];
  String selectedOption = 'Matchs';
  final _years = ['2020', '2021', '2022', '2023'];
  String selectYear = '2023';
  Map<String, dynamic> ranking = {};
  Map<String, dynamic> topScorers = {};
  Map<String, dynamic> topAssist = {};
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
                            child: Text(
                              '현지시간 ${m['fixture']['date'].toString().replaceAll(':00+00:00', '').replaceAll('T', '\n')}',
                              style: const TextStyle(fontSize: 16.0),
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

    var futureBuilderRecord = FutureBuilder(
      future: showRecord(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else {
          return Column(
            children: [
              const SizedBox(
                child: Text('득점 순위'),
              ),
              Container(
                width: double.infinity,
                height: 600,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    var topScorersRecord =
                        topScorers['response'][index]['player'];
                    return ListTile(
                      leading: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            )),
                        child: Image.network(
                          topScorersRecord['photo'],
                        ),
                      ),
                      title: Text(
                        '${index + 1}. ${topScorersRecord['name']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        topScorers['response'][index]['statistics'][0]['goals']
                                ['total']
                            .toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  },
                  itemCount: 4,
                  separatorBuilder: (context, index) => const Divider(),
                ),
                // ElevatedButton(
                //   onPressed: () =>
                //       Navigator.push(context, MaterialPageRoute(
                //     builder: (context) {
                //       return DetailRanking();
                //     },
                //   )),
                //   child: Text(
                //     '순위 더보기',
                //     style: TextStyle(fontSize: 8),
                //   ),
                // )
              ),
            ],
          );
        }
      },
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
            defaultSelected: id[0],
            buttonLables: [
              '경기',
              '뉴스',
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
          if (selectedOption == id[2]) futureBuilderRank,
          if (selectedOption == id[3]) futureBuilderRecord,
        ],
      ),
    );
  }

  Future<void> showRank() async {
    ranking = await sport_api().getStandings(selectYear, widget.leagueId)
        as Map<String, dynamic>;
  }

  Future<void> showRecord() async {
    topScorers = await sport_api().getTopScorers(widget.leagueId, selectYear)
        as Map<String, dynamic>;
    topAssist = await sport_api().getTopAssist(widget.leagueId, selectYear)
        as Map<String, dynamic>;
  }

  Future<void> showMatchs() async {
    matchs = await sport_api().matchsInformation(widget.leagueId, selectYear)
        as Map<String, dynamic>;
  }
}
