

import 'package:sports_score_app/Models/Team.dart';
import 'package:sports_score_app/Models/TeamStats.dart';

class Game{

  TeamStats home;
  TeamStats away;
  MatchType matchType = MatchType.Regular;

  Game({this.home, this.away, this.matchType,});

}

enum MatchType{
  Final,
  Regular
}