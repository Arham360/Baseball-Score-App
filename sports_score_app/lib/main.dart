import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sports_score_app/ScoreManager.dart';

import 'Models/Game.dart';
import 'Models/Team.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Today's Games".toUpperCase(),
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: ScopedModel(model: ScoreManager(), child: HomePage()),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 1,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, i) {
          return MatchCard(
            game: Game(
                homeTeam: Team(
                  "https://a2.espncdn.com/combiner/i?img=%2Fi%2Fteamlogos%2Fnfl%2F500%2Fgb.png",
                  "WSH",
                ),
                homeTeamScore: 6,
                awayTeam: new Team(
                  "https://a2.espncdn.com/combiner/i?img=%2Fi%2Fteamlogos%2Fnfl%2F500%2Fgb.png",
                  "HOU",
                ),
                awayTeamScore: 2,
                matchType: MatchType.Final),
            isDetails: false,
          );
        },
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  Game game;
  bool isDetails;

  MatchCard({this.game, this.isDetails});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => _navigateToGameDetails(game, context),
        child: AnimatedContainer(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1, //
            ),
          ),
          duration: Duration(seconds: 1),
          child: Row(
            children: <Widget>[
              TeamCard(game.awayTeam),
              Text(
                game.awayTeamScore.toString(),
                style: TextStyle(fontSize: 28),
              ),
              Spacer(),
              Text((game.matchType == MatchType.Final) ? "FINAL" : "Regular"),
              Spacer(),
              Text(
                game.homeTeamScore.toString(),
                style: TextStyle(fontSize: 28),
              ),
              TeamCard(game.homeTeam),
            ],
          ),
        ),
      ),
    );
  }

  _navigateToGameDetails(Game game, BuildContext context) {
    if (!isDetails) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => MatchDetails(game)));
    }
  }
}

class TeamCard extends StatelessWidget {
  Team team;

  TeamCard(this.team);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Hero(
        tag: team.teamName,
        //this will cause issues if i have another card with same team name
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Image.network(
                  team.imageUrl,
                  height: MediaQuery.of(context).size.width * 0.20,
                ),
                Text(team.teamName)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MatchDetails extends StatelessWidget {
  Game game;

  MatchDetails(this.game);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${game.awayTeam.teamName} @ ${game.homeTeam.teamName}",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MatchCard(
              game: game,
            ),
          ],
        ),
      ),
    );
  }
}
