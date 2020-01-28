

import 'package:sports_score_app/Models/Team.dart';

class Game{

  Team homeTeam;
  int homeTeamScore;
  Team awayTeam;
  int awayTeamScore;
  MatchType matchType;
  Selected selected = Selected.AWAY;

  Game({this.homeTeam,this.homeTeamScore, this.awayTeam, this.awayTeamScore, this.matchType,});

}

enum Selected{
  AWAY,
  HOME
}

enum MatchType{
  Final,
  Regular
}