
import 'Team.dart';

class TeamStats {

  Team team;
  int teamScore;
  List<int> innings;
  List<int> runsHitsErrors;
  List<String> hitters;
  List<String> pitchers;

  //todo add a map of players and a data structure(individual scores)

  TeamStats({this.team, this.teamScore, this.innings,
      this.runsHitsErrors, this.hitters, this.pitchers});

}