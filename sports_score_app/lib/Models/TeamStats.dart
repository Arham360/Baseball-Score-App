
import 'Team.dart';

class TeamStats {

  Team team;
  int teamScore;
  List<int> innings;
  List<int> runsHitsErrors;

  TeamStats({this.team, this.teamScore, this.innings,
      this.runsHitsErrors}); //score needs to turned into its own struct

}