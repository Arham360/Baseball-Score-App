

import 'package:sports_score_app/Models/Team.dart';

class Game{

  Team homeTeam;
  int homeTeamScore;
  List<int> homeInnings;
  List<int> homeStats;//score needs to turned into its own struct
  Team awayTeam;
  int awayTeamScore;
  List<int> awayInnings;
  List<int> awayStats;
  MatchType matchType;
  Selected selected = Selected.AWAY;

  Game({this.homeTeam,this.homeTeamScore, this.homeInnings, this.awayTeam, this.awayTeamScore,this.awayInnings, this.matchType, this.homeStats, this.awayStats});

}

enum Selected{
  AWAY,
  HOME
}

enum MatchType{
  Final,
  Regular
}