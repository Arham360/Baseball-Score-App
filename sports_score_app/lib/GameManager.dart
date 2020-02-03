import 'package:scoped_model/scoped_model.dart';
import 'Models/Game.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class GameManager extends Model{

  Game game;

  init(Game g){
    game = g;
    notifyListeners();

    fetchDetails();
  }

  dispose(){
    game = null;
    notifyListeners();
  }

  fetchDetails() async{
    //in an actual app, youd pass in the ID for the game to start population
    var teamsUrl = "https://statsapi.mlb.com/api/v1/game/599342/boxscore?fields=teams,record,wins,losses,players,fullName,position,name,type,abbreviation,stats,batting,doubles,triples,homeRuns,strikeOuts,fielding,assists,errors,putOuts,pitching,runs,atBats,hits,rbi,inningsPitched,strikeOuts";

    var response = await http.get(teamsUrl);
    var data = jsonDecode(response.body);
    print("hi");

    var awayHitters = data["teams"]["away"]["batters"];
    game.away.hitters = awayHitters;

    var awayPitchers = data["teams"]["away"]["pitchers"];
    game.away.pitchers = awayPitchers;

    var homeHitters = data["teams"]["home"]["batters"];
    game.home.hitters = homeHitters;

    var homePitchers = data["teams"]["home"]["pitchers"];
    game.home.hitters = homePitchers;

    game.home.team.teamName = "butt";

    print(awayHitters.toString());
    print(awayPitchers.toString());
    print(homeHitters.toString());
    print(homePitchers.toString());

    notifyListeners();

  }

}