import 'package:flutter/material.dart';
import 'package:flutter_application_sport/sport_api.dart';

class MatchsInformation extends StatefulWidget {
  int id;
  String home;
  String away;
  String homeLogo;
  String awayLogo;

  MatchsInformation(
      {super.key,
      required this.id,
      required this.home,
      required this.away,
      required this.awayLogo,
      required this.homeLogo});

  @override
  State<MatchsInformation> createState() => _MatchsInformationState();
}

class _MatchsInformationState extends State<MatchsInformation> {
  Map<String, dynamic> mi = {};

  late Future future;

  @override
  void initState() {
    super.initState();
    future = matchInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.home} vs ${widget.away}'),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Image.network(
                    widget.homeLogo,
                  ),
                ),
                Text('vs'),
                Expanded(
                  child: Image.network(
                    widget.awayLogo,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    widget.home,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.home,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('경기전'));
                } else {
                  // print(mi['response'][0]['statistic'][0]['value'].toString());

                  return Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (mi['response'][0] == null) {
                          return Container(
                            child: Text("경기 전"),
                          );
                        } else {
                          return ListTile(
                            title: Row(
                              children: [
                                Text(mi['response'][0]['statistics'][index]
                                        ['value']
                                    .toString()),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(mi['response'][0]['statistics']
                                            [index]['type']
                                        .toString()),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              mi['response'][1]['statistics'][index]['value']
                                  .toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        }
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: 16,
                    ),
                  );
                }
              },
            )
          ],
        ));
  }

  Future<void> matchInfo() async {
    mi = await sport_api().matchDetail(widget.id) as Map<String, dynamic>;
    print(mi['response'][0]['statistics'][0]['value']);
  }
}
