import 'package:flutter/material.dart';
import 'package:flutter_application_sport/sport_api.dart';

class FootballTeamInformation extends StatefulWidget {
  final String id;
  final String leagueId;
  final String season;
  final String name;

  FootballTeamInformation({
    Key? key,
    required this.id,
    required this.leagueId,
    required this.season,
    required this.name,
  }) : super(key: key);

  @override
  State<FootballTeamInformation> createState() =>
      _FootballTeamInformationState();
}

class _FootballTeamInformationState extends State<FootballTeamInformation> {
  Map<String, dynamic> information = {};
  late Future info;

  @override
  void initState() {
    super.initState();
    info = showInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('팀 소개'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: info,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('데이터 로딩 중 오류 발생'));
            } else
              // ignore: curly_braces_in_flow_control_structures
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      '${information['response']['team']['logo']}',
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${information['response']['team']['name']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '리그: ${information['response']['league']['name']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    '국가: ${information['response']['league']['country']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '시즌 ${information['response']['league']['season']} 통계',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildStatRow(
                      '경기 수',
                      information['response']['fixtures']['played']['total']
                          .toString()),
                  buildStatRow(
                      '승리',
                      information['response']['fixtures']['wins']['total']
                          .toString()),
                  buildStatRow(
                      '무승부',
                      information['response']['fixtures']['draws']['total']
                          .toString()),
                  buildStatRow(
                      '패배',
                      information['response']['fixtures']['loses']['total']
                          .toString()),
                  const SizedBox(height: 16),
                  const Text(
                    '득점 통계',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildStatRow(
                      '득점 (총)',
                      information['response']['goals']['for']['total']['total']
                          .toString()),
                  buildStatRow(
                      '득점 평균',
                      information['response']['goals']['for']['average']
                              ['total']
                          .toString()),
                  // 다른 필요한 통계 정보도 추가 가능
                ],
              );
          },
        ),
      ),
    );
  }

  Widget buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> showInformation() async {
    information = await sport_api().showTeamInformation(
        widget.id, widget.leagueId, widget.season) as Map<String, dynamic>;
  }
}
