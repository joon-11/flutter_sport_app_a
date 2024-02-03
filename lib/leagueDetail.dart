import 'package:flutter/material.dart';
import 'package:flutter_application_sport/sport_api.dart';

class FootballTeamInformation extends StatelessWidget {
  final String id;
  final String leagueId;
  final String season;
  final String name;
  Map<String, dynamic> information = {};

  FootballTeamInformation({
    Key? key,
    required this.id,
    required this.leagueId,
    required this.season,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            name,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
        body: Column(
          children: [
            FutureBuilder(
              future: showInformation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                } else {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                information['response']['team']['logo']),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Text('다음경기'),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.red,
                        ),
                      )
                    ],
                  );
                }
              },
            )
          ],
        ));
  }

  Future<void> showInformation() async {
    information = await sport_api().showTeamInformation(id, leagueId, season)
        as Map<String, dynamic>;
  }
}
