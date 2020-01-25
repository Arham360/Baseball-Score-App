import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        ),
        body: HomePage(),
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
            new Game(homeTeam: Team(
                "https://a2.espncdn.com/combiner/i?img=%2Fi%2Fteamlogos%2Fnfl%2F500%2Fgb.png",
                "WSH",
                6),awayTeam: new Team(
                "https://a2.espncdn.com/combiner/i?img=%2Fi%2Fteamlogos%2Fnfl%2F500%2Fgb.png",
                "HOU",
                6), matchType: MatchType.Final )
          );
        },
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  Game game;

  MatchCard(this.game);

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
              Spacer(),
              Text((game.matchType == MatchType.Final)?"FINAL" : "Regular"),
              Spacer(),
              TeamCard(game.homeTeam),
            ],
          ),
        ),
      ),
    );
  }

  _navigateToGameDetails(Game game, BuildContext context) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
            MatchDetails(game)));
  }
}


class TeamCard extends StatelessWidget {
  Team team;

  //make this into an object

  TeamCard(this.team);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Hero(
        tag: team.teamName,//this will cause issues if i have another card with same team name
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
            Text(
              team.teamScore.toString(),
              style: TextStyle(fontSize: 28),
            )
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
        title: Text("${game.awayTeam.teamName} @ ${game.homeTeam.teamName}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MatchCard(game)
          ],
        ),
      ),
    );
  }
}
