import 'dart:core';
import 'dart:html';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_sport/Detailranking.dart';
import 'package:flutter_application_sport/leagueDetail.dart';
import 'package:flutter_application_sport/matchsInformation.dart';
import 'package:flutter_application_sport/playerInformation.dart';
import 'package:flutter_application_sport/sport_api.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:weekly_calendar/weekly_calendar.dart';

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
  int selectedOption = 0;
  final _years = ['2020', '2021', '2022', '2023'];
  String selectYear = '2023';
  Map<String, dynamic> ranking = {};
  Map<String, dynamic> topScorers = {};
  Map<String, dynamic> topAssist = {};
  Map<String, dynamic> topRedcard = {};
  Map<String, dynamic> topYellowcard = {};
  Map<String, dynamic> matchs = {};
  DateTime? d = DateTime.now();
  late Future matchsFuture;

  @override
  void initState() {
    super.initState();
    d = DateTime.now(); // or set it to the initial date you want
    matchsFuture = showMatchs(d);
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilderMatchs = Scaffold(
      body: Column(        
        children: [
          Expanded(
            child: Column(
              children: [
                WeeklyCalendar(
                  calendarStyle: const CalendarStyle(
                    locale: "en_US",
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    margin: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(14))),
                    headerDateTextColor: Colors.white,
                    headerDateTextAlign: Alignment.center,
                    isShowHeaderDateText: true,
                    footerDateTextColor: Colors.white,
                    footerDateTextAlign: Alignment.center,
                    isShowFooterDateText: false,
                    selectedCircleColor: Colors.white,
                    todaySelectedCircleColor: Colors.greenAccent,
                    dayTextColor: Colors.white,
                    todayDayTextColor: Colors.greenAccent,
                    selectedDayTextColor: Colors.black,
                    weekendDayTextColor: Colors.grey,
                    dayOfWeekTextColor: Colors.white,
                    weekendDayOfWeekTextColor: Colors.grey,
                  ),
                  isAutoSelect: true,
                  onChangedSelectedDate: (DateTime date) {
                    setState(() {
                      d = date;
                      matchsFuture = showMatchs(d);
                    });
                    
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: matchsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(child: Text('Error loading data'));
                } else {
                  return Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                          m['teams']['home']['logo']),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        m['teams']['home']['name'].toString(),
                                        textAlign: TextAlign.start,
                                        style:
                                            const TextStyle(fontSize: 16.0),
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
                                        style:
                                            const TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Image.network(
                                          m['teams']['away']['logo']),
                                      const SizedBox(height: 16.0),
                                      Text(
                                        m['teams']['away']['name'].toString(),
                                        textAlign: TextAlign.end,
                                        style:
                                            const TextStyle(fontSize: 16.0),
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
            ),
          ),
        ],
      ),
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
                  title: const Text('득점순위'),
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
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlayerInformation(
                                      info: topScorers['response'][index],
                                    ),
                                  ),
                                ));
                      },
                      itemCount: 5,
                      separatorBuilder: (context, index) => const Divider(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                // ExpansionTile(
                //   initiallyExpanded: false,
                //   title: Text('어시스트 순위'),
                //   children: [
                //     ListView.separated(
                //       shrinkWrap: true,
                //       itemBuilder: (context, index) {
                //         var assist = topAssist['response'][index]['player'];
                //         return ListTile(
                //           leading: Container(
                //             decoration: const BoxDecoration(
                //                 color: Colors.white,
                //                 borderRadius: BorderRadius.all(
                //                   Radius.circular(8),
                //                 )),
                //             child: Image.network(
                //               assist['photo'],
                //             ),
                //           ),
                //           title: Text(
                //             '${index + 1}. ${assist['name']}',
                //             style: const TextStyle(color: Colors.white),
                //           ),
                //           trailing: Text(
                //             topAssist['response'][index]['statistics'][0]
                //                     ['goals']['assists']
                //                 .toString(),
                //             style: const TextStyle(fontSize: 18),
                //           ),
                //         );
                //       },
                //       itemCount: 5,
                //       separatorBuilder: (context, index) => const Divider(),
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // ExpansionTile(
                //   initiallyExpanded: false,
                //   title: Text('레드카드 순위'),
                //   children: [
                //     ListView.separated(
                //       shrinkWrap: true,
                //       itemBuilder: (context, index) {
                //         var red = topRedcard['response'][index]['player'];
                //         return ListTile(
                //           leading: Container(
                //             decoration: const BoxDecoration(
                //                 color: Colors.white,
                //                 borderRadius: BorderRadius.all(
                //                   Radius.circular(8),
                //                 )),
                //             child: Image.network(
                //               red['photo'],
                //             ),
                //           ),
                //           title: Text(
                //             '${index + 1}. ${red['name']}',
                //             style: const TextStyle(color: Colors.white),
                //           ),
                //           trailing: Text(
                //             topRedcard['response'][index]['statistics'][0]
                //                     ['cards']['red']
                //                 .toString(),
                //             style: const TextStyle(fontSize: 18),
                //           ),
                //         );
                //       },
                //       itemCount: 5,
                //       separatorBuilder: (context, index) => const Divider(),
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // ExpansionTile(
                //   initiallyExpanded: false,
                //   title: Text('옐로카드 순위'),
                //   children: [
                //     ListView.separated(
                //       shrinkWrap: true,
                //       itemBuilder: (context, index) {
                //         var yellow = topYellowcard['response'][index]['player'];
                //         return ListTile(
                //           leading: Container(
                //             decoration: const BoxDecoration(
                //                 color: Colors.white,
                //                 borderRadius: BorderRadius.all(
                //                   Radius.circular(8),
                //                 )),
                //             child: Image.network(
                //               yellow['photo'],
                //             ),
                //           ),
                //           title: Text(
                //             '${index + 1}. ${yellow['name']}',
                //             style: const TextStyle(color: Colors.white),
                //           ),
                //           trailing: Text(
                //             topYellowcard['response'][index]['statistics'][0]
                //                     ['cards']['yellow']
                //                 .toString(),
                //             style: const TextStyle(fontSize: 18),
                //           ),
                //         );
                //       },
                //       itemCount: 5,
                //       separatorBuilder: (context, index) => const Divider(),
                //     ),
                //   ],
                // ),
                const SizedBox(
                  height: 300,
                )
              ],
            );
          }
        },
      ),
    );

    void _onItemTapped(int index) {
      setState(() {
        selectedOption = index;
      });
    }

    Widget? buildBody() {
      if (selectedOption == 0) {
        return futureBuilderMatchs;
      } else if (selectedOption == 1) {
        return futureBuilderRank;
      } else if (selectedOption == 2) {
        return futureBuilderRecord;
      } else {
        // 기본적으로 빈 컨테이너를 반환하거나 다른 처리를 수행할 수 있습니다.
        return Container();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.leagueName,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.red,
        actions: [
          DropdownButton(
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
        ],
      ),
      body: buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: '경기 일정',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: '순위',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: '기록',
          ),
        ],
        currentIndex: selectedOption,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
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
    // topAssist = await sport_api().getTopAssist(widget.leagueId, selectYear)
    //     as Map<String, dynamic>;
    // topRedcard = await sport_api().getTopRedcard(widget.leagueId, selectYear)
    //     as Map<String, dynamic>;
    // topYellowcard = await sport_api()
    //     .getTopYellowcard(widget.leagueId, selectYear) as Map<String, dynamic>;
  }

  Future<void> showMatchs(date) async {
    matchs =
        await sport_api().matchsInformation(widget.leagueId, selectYear, date)
            as Map<String, dynamic>;

    print(matchs);
  }
}
