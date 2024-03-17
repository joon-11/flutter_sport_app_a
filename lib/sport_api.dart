import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// '6c6f57b93dmsh391caffd34718a7p13fe49jsnbbff15dbe7bc' google
// '44b53a7a9fmshd4b09e186aeeefbp1eb70ejsnbca7d65497bd' 쌤
// '6f0a3673b5mshd4bbc5ca627763cp142354jsn6cee76f580bf' naver

class sport_api {
  final String apiKey = '6f0a3673b5mshd4bbc5ca627763cp142354jsn6cee76f580bf';
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
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> getTopRedcard(String leagueId, String season) async {
    final String apiUrl =
        'https://api-football-v1.p.rapidapi.com/v3/players/topredcards';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost,
    };

    final Map<String, String> params = {
      'league': leagueId,
      'season': season,
    };

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: params);

    try {
      final http.Response response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> getTopYellowcard(String leagueId, String season) async {
    final String apiUrl =
        'https://api-football-v1.p.rapidapi.com/v3/players/topyellowcards';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost,
    };

    final Map<String, String> params = {
      'league': leagueId,
      'season': season,
    };

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: params);

    try {
      final http.Response response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> matchsInformation(
      String leagueId, String selectYear, date) async {
    final String url = 'https://api-football-v1.p.rapidapi.com/v3/fixtures';

    String d = DateFormat('yyyy-MM-dd').format(date);

    final Map<String, String> headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost,
    };

    final Uri uri =
        Uri.parse('$url?date=${d}&league=${leagueId}&season=${selectYear}');

    try {
      final http.Response response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> matchDetail(fixture) async {
    final Uri uri = Uri.parse(
        'https://api-football-v1.p.rapidapi.com/v3/fixtures/statistics?fixture=${fixture}');
    final Map<String, String> headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost
    };

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
