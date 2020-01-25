

import 'package:sports_score_app/Models/Team.dart';

class Game{

  Team homeTeam;
  Team awayTeam;
  MatchType matchType;

  Game({this.homeTeam, this.awayTeam, this.matchType});

}

enum MatchType{
  Final,
  Regular
}