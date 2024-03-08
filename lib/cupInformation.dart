import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_sport/teamdetail.dart';
import 'package:flutter_application_sport/sport_api.dart';

class ShowCupInformation extends StatefulWidget {
  final leagueId;
  final leagueName;

  const ShowCupInformation({
    super.key,
    required this.leagueId,
    required this.leagueName,
  });

  @override
  State<ShowCupInformation> createState() => _ShowCupInformationState();
}

class _ShowCupInformationState extends State<ShowCupInformation> {
  List id = ['Matchs', 'News', 'Rank', 'Record'];
  String selectedOption = 'Rank';
  final _years = ['2019', '2020'];
  String selectYear = '2020';
  Map<String, dynamic> ranking = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.leagueName,
          style: TextStyle(fontSize: 20, color: Colors.white),
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
            defaultSelected: id[2],
            buttonLables: const [
              '경기',
              '뉴스',
              '순위',
              '기록',
            ],
            buttonValues: id,
            radioButtonValue: (p0) {
              setState(() {
                selectedOption = p0;
              });
              if (p0 == id[2]) {
                showRank();
              } else if (p0 == id[0]) {}
            },
            unSelectedColor: Colors.yellow,
            selectedColor: Colors.red,
          ),
          if (selectedOption == id[2])
            FutureBuilder(
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
                        var r = ranking['response'][0]['league']['standings'][0]
                            [index];
                        return ListTile(
                          leading: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Image.network(r['team']['logo'])),
                          title: Text('${r['rank']}. ${r['team']['name']}'),
                          subtitle: Text(r['form'].toString()),
                          trailing: Text(
                            r['points'].toString(),
                            style: TextStyle(fontSize: 18),
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
                                      )),
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: ranking['response'][0]['league']['standings']
                              [0]
                          .length,
                    ),
                  );
                }
              },
            ),
        ],
      ),
    );
  }

  Future<void> showRank() async {
    ranking = await sport_api().getStandings(selectYear, widget.leagueId)
        as Map<String, dynamic>;
  }
}
