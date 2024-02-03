import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Test{
  final String apiKey = dotenv.env['api_key'].toString();
  final String apiHost = 'api-football-v1.p.rapidapi.com';

  final String standingsUrl = 'https://api-football-v1.p.rapidapi.com/v3/standings';
  final String statisticsUrl = 'https://api-football-v1.p.rapidapi.com/v3/teams/statistics';
  final String leaguesUrl = 'https://api-football-v1.p.rapidapi.com/v3/leagues';
  final String topscorersUrl = 'https://api-football-v1.p.rapidapi.com/v3/players/topscorers';
  final String topassistsUrl = 'https://api-football-v1.p.rapidapi.com/v3/players/topassists';
  final String matchsUrl = 'https://api-football-v1.p.rapidapi.com/v3/fixtures';

  
}