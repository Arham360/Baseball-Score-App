

import 'package:sports_score_app/Models/Team.dart';

class Match{

  Team homeTeam;
  Team awayTeam;
  MatchType matchType;

}

enum MatchType{
  Final,
  Regular
}