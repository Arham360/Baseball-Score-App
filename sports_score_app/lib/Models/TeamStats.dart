
import 'Team.dart';

class TeamStats {

  Team team;
  int teamScore;
  List<int> innings;
  List<int> runsHitsErrors;
  List<Player> hitters = List();
  List<Player> pitchers = List();

  //todo add a map of players and a data structure(individual scores)

  TeamStats({this.team, this.teamScore, this.innings,
      this.runsHitsErrors});

}

class Player{

  int id;

  int runs;
  int hits;
  int ab;
  int rbi;

  //also needs to support pitching fields. this is not a good design

  Player(this.id);

}