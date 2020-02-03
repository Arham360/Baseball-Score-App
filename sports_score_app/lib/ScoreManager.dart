import 'dart:ui';

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
    notifyListeners();

    //make request
    var response = await http.get(
        "https://statsapi.mlb.com/api/v1.1/game/534196/feed/live?fields=liveData,linescore,teams,away,home,runs");
    //parse json for scores
    var data = jsonDecode(response.body);
    var liveData = data["liveData"]["linescore"]["teams"];
    print(liveData);

    //add into games and notify listeners
    games.add(await generateGameFromLiveData(liveData));

    notifyListeners();
  }

  Future<Game> generateGameFromLiveData(liveData) async {
    //json serializable is probably better but the generate command is having issues right now

    var inningsResponse =
        await http.get("https://statsapi.mlb.com/api/v1/game/531060/linescore");
    var inningsJson = jsonDecode(inningsResponse.body);
    var inningsData = inningsJson["innings"];

    List<int> homeInnings = List();
    List<int> awayInnings = List();

    List<int> homeStats = List();
    List<int> awayStats = List();

    for (var i in inningsData) {
      //might be worth it to have a map to correspond with the innings values
      var homeRuns = i["home"]["runs"] ?? 0;
      var awayRuns = i["away"]["runs"] ?? 0;
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
    //hard code team names for now?
    TeamStats home = TeamStats(
        team: Team(
          imageUrl:
              "https://upload.wikimedia.org/wikipedia/en/thumb/a/a3/Washington_Nationals_logo.svg/1200px-Washington_Nationals_logo.svg.png",
          teamName: "WSH",
          teamColors: [Color(0XFFFDC701), Color(0XFFFF7747)],
        ),
        teamScore: liveData["home"]["runs"] as int,
        innings: homeInnings,
        runsHitsErrors: homeStats);

    TeamStats away = TeamStats(
        team: Team(
          imageUrl:
              "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Houston-Astros-Logo.svg/1200px-Houston-Astros-Logo.svg.png",
          teamName: "HOU",
          teamColors: [
            Color(0XFFFD4848),
            Color(0XFF530433),
          ],
        ),
        teamScore: liveData["away"]["runs"] as int,
        innings: awayInnings,
        runsHitsErrors: awayStats);

    Game game = Game(away: away, home: home, matchType: MatchType.Final);
    return game;
  }
}

