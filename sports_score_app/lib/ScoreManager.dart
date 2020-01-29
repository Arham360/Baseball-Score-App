import 'package:scoped_model/scoped_model.dart';
import 'package:sports_score_app/Models/TeamStats.dart';
import 'dart:convert';
import 'Models/Game.dart';
import 'package:http/http.dart' as http;

import 'Models/Team.dart';

class ScoreManager extends Model {
  List<Game> games = List();

  populateGames() async {
    games.clear();
    //make request
    var response = await http.get(
        "https://statsapi.mlb.com/api/v1.1/game/534196/feed/live?fields=liveData,linescore,teams,away,home,runs");
    //parse json for scores
    var data = jsonDecode(response.body);
    var liveData = data["liveData"]["linescore"]["teams"];
    print(liveData);
    //hard code team names for now?

    var inningsResponse = await http.get("https://statsapi.mlb.com/api/v1/game/531060/linescore");
    var inningsJson = jsonDecode(inningsResponse.body);
    var inningsData = inningsJson["innings"];
    //print(inningsData);

    List<int> homeInnings = List();
    List<int> awayInnings = List();

    List<int> homeStats = List();
    List<int> awayStats = List();

    for(var i in inningsData){
      //might be worth it to have a map to correspond with the innings values
      var homeRuns = i["home"]["runs"]??0;
      var awayRuns = i["away"]["runs"]??0;
      homeInnings.add(homeRuns);
      awayInnings.add(awayRuns);
    }

    var teamsData = inningsJson["teams"];
    homeStats.add(teamsData["home"]["runs"]);
    homeStats.add(teamsData["home"]["hits"]);
    homeStats.add(teamsData["home"]["errors"]);

    awayStats.add(teamsData["away"]["runs"]);
    awayStats.add(teamsData["away"]["hits"]);
    awayStats.add(teamsData["away"]["errors"]);

    TeamStats home = TeamStats(
        team: Team(
    "https://a2.espncdn.com/combiner/i?img=%2Fi%2Fteamlogos%2Fnfl%2F500%2Fgb.png",
    "WSH",
    ),
    teamScore: liveData["home"]["runs"] as int,
    innings: homeInnings,
    runsHitsErrors: homeStats
    );

    TeamStats away = TeamStats(
    team: Team(
    "https://a2.espncdn.com/combiner/i?img=%2Fi%2Fteamlogos%2Fnfl%2F500%2Fgb.png",
    "HOU",
    ),
    teamScore: liveData["away"]["runs"] as int,
    innings: awayInnings,
    runsHitsErrors: awayStats
    );

    Game game = Game(
    away: away,
        home: home,

        matchType: MatchType.Final);
    //add into games and notify listeners
    games.add(game);
    notifyListeners();
  }

}

class GameManager extends Model{

  Game game;



}