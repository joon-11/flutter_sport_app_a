import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class sport_api {
  final String apiKey = dotenv.env['api_key'].toString();
  final String apiHost = 'api-football-v1.p.rapidapi.com';

  Future<dynamic> getStandings(String season, String league) async {
    final String baseUrl =
        'https://api-football-v1.p.rapidapi.com/v3/standings';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost,
    };
    final Map<String, String> params = {
      'season': season,
      'league': league,
    };

    final Uri uri = Uri.parse('$baseUrl?${Uri(queryParameters: params).query}');

    try {
      final http.Response response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> showTeamInformation(
      String id, String leagueId, String season) async {
    final Uri url =
        Uri.parse('https://api-football-v1.p.rapidapi.com/v3/teams/statistics');
    final Map<String, String> queryParams = {
      'league': leagueId,
      'season': season,
      'team': id,
    };

    final Map<String, String> headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost,
    };

    final Uri uri = url.replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> loadTeam() async {
    const String apiUrl = 'https://api-football-v1.p.rapidapi.com/v3/leagues';

    final Map<String, String> headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost,
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> getTopScorers(String leagueId, String season) async {
    final String apiUrl =
        'https://api-football-v1.p.rapidapi.com/v3/players/topscorers';
    final Map<String, String> queryParams = {
      'league': leagueId,
      'season': season,
    };

    final Map<String, String> headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost,
    };

    final Uri uri =
        Uri.parse('$apiUrl?${Uri(queryParameters: queryParams).query}');

    try {
      final http.Response response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> getTopAssist(String leagueId, String season) async {
    final String apiUrl =
        'https://api-football-v1.p.rapidapi.com/v3/players/topassists';

    final Map<String, String> queryParams = {
      'league': leagueId,
      'season': season,
    };

    final Map<String, String> headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost,
    };

    final Uri uri =
        Uri.parse('$apiUrl?${Uri(queryParameters: queryParams).query}');

    try {
      final http.Response response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> matchsInformation(String leagueId, String season) async {
    var url = 'https://api-football-v1.p.rapidapi.com/v3/fixtures';

    var headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost,
    };
    var params = {// 고쳐야함 
      'league': leagueId,
      'season': season,
      'from': DateFormat('yyyy-mm-dd').format(DateTime.utc(2023, 04, 20)),
      'to': DateFormat('yyyy-mm-dd').format(DateTime.utc(2024, 11, 5))
    };

    final Uri uri = Uri.parse('$url?${Uri(queryParameters: params).query}');

    try {
      var response = await http.get(uri, headers: headers);
      return jsonDecode(response.body);
    } catch (error) {
      print(error);
    }
  }
}
