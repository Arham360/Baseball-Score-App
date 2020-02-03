import 'dart:math';

import 'package:scoped_model/scoped_model.dart';
import 'package:sports_score_app/Models/TeamStats.dart';
import 'Models/Game.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class GameManager extends Model{

  Game game;

  bool isLoading;

  Selected selected;// use to flip between away and home data tables

  init(Game g){ //call when coming into details page
    isLoading = true;
    game = g;
    notifyListeners();

    fetchDetails();
  }

  dispose(){//call on will pop scope to clear
    game = null;
    notifyListeners();
  }

  fetchDetails() async{
    //in an actual app, youd pass in the ID for the game to start population
    var teamsUrl = "https://statsapi.mlb.com/api/v1/game/599342/boxscore?fields=teams,record,wins,losses,players,fullName,position,name,type,abbreviation,stats,batting,doubles,triples,homeRuns,strikeOuts,fielding,assists,errors,putOuts,pitching,runs,atBats,hits,rbi,inningsPitched,strikeOuts";

    var response = await http.get(teamsUrl);
    var data = jsonDecode(response.body)["teams"];

    var awayHitters = data["away"]["batters"] as List;
    List<Player> tags = awayHitters != null ? awayHitters.map((i) => Player(i)).toList() : null;
    game.away.hitters = tags;

    game.away.hitters.forEach((element) {
      var pData = data["away"]["players"]["ID${element.id}"]["stats"];
      element.runs = pData["runs"];
      element.hits = pData["hits"];
      element.ab = pData["atBats"];
      element.rbi = pData["rbi"];
    });

    var awayPitchers = data["away"]["pitchers"] as List<int>;
    tags = awayHitters != null ? awayPitchers.map((i) => Player(i)).toList() : null;
    game.away.pitchers = tags;

    var homeHitters = data["home"]["batters"]as List<int>;
    tags = awayHitters != null ? homeHitters.map((i) => Player(i)).toList() : null;
    game.home.hitters = tags;

    game.home.hitters.forEach((element) {
      var pData = data["home"]["players"]["ID${element.id}"]["stats"];
      element.runs = pData["runs"];
      element.hits = pData["hits"];
      element.ab = pData["atBats"];
      element.rbi = pData["rbi"];
    });

    var homePitchers = data["home"]["pitchers"]as List<int>;
    tags = awayHitters != null ? homePitchers.map((i) => Player(i)).toList() : null;
    game.home.pitchers = tags;



    isLoading = false;
    notifyListeners();
  }


}

enum Selected{
  AWAY,
  HOME
}