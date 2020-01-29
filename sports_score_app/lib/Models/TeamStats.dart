
import 'Team.dart';

class TeamStats {

  Team team;
  int teamScore;
  List<int> innings;
  List<int> runsHitsErrors;

  //todo add a map of players and a data structure(individual scores)

  TeamStats({this.team, this.teamScore, this.innings,
      this.runsHitsErrors});

}