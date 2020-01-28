

import 'package:sports_score_app/Models/Team.dart';

class Game{

  Team homeTeam;
  int homeTeamScore;
  Team awayTeam;
  int awayTeamScore;
  MatchType matchType;

  Game({this.homeTeam,this.homeTeamScore, this.awayTeam, this.awayTeamScore, this.matchType,});

}

enum MatchType{
  Final,
  Regular
}