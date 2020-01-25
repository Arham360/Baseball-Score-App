import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => null,
              child: AnimatedContainer(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1, //
                  ),
                ),
                duration: Duration(seconds: 1),
                child: Row(
                  children: <Widget>[
                    TeamCard(new Team(
                        "https://a2.espncdn.com/combiner/i?img=%2Fi%2Fteamlogos%2Fnfl%2F500%2Fgb.png",
                        "WSH",
                        6)),
                    Spacer(),
                    Text("FINAL"),
                    Spacer(),
                    TeamCard(new Team(
                        "https://a2.espncdn.com/combiner/i?img=%2Fi%2Fteamlogos%2Fnfl%2F500%2Fgb.png",
                        "WSH",
                        6)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
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
        tag: team.teamName,
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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
