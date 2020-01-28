

import 'package:sports_score_app/Models/Team.dart';

class Game{

  Team homeTeam;
  int homeTeamScore;
  List<int> homeInnings;
  Team awayTeam;
  int awayTeamScore;
  List<int> awayInnings;
  MatchType matchType;
  Selected selected = Selected.AWAY;

  Game({this.homeTeam,this.homeTeamScore, this.homeInnings, this.awayTeam, this.awayTeamScore,this.awayInnings, this.matchType,});

}

enum Selected{
  AWAY,
  HOME
}

enum MatchType{
  Final,
  Regular
}