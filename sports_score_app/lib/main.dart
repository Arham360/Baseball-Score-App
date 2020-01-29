import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sports_score_app/ScoreManager.dart';

import 'DetailsPage/DetailsPage.dart';
import 'Models/Game.dart';
import 'Models/Team.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: ScoreManager(),
      child: MaterialApp(
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
          body: HomePage(),
          floatingActionButton:
              FloatingActionButton(onPressed: () => _refresh(context)),
        ),
      ),
    );
  }

  _refresh(context) async {
    await ScopedModel.of<ScoreManager>(context).populateGames();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    asyncPopulate();
  }

  asyncPopulate() async {
    await ScopedModel.of<ScoreManager>(context).populateGames();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: ScopedModelDescendant<ScoreManager>(
            builder: (context, child, model) => (model.games.length != 0)
                ? ListView.builder(
                    itemCount: model.games.length,
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (context, i) {
                      return MatchCard(
                        game: model.games[i],
                        isDetails: false,
                      );
                    },
                  )
                : CircularProgressIndicator()),
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
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.1,
                  0.4,
                  0.6,
                  0.9
                ],
                colors: [
                  Color(0XFFFDC701),
                  Color(0XFFFF7747),
                  Color(0XFFFD4848),
                  Color(0XFF530433),
                ]),
            border: Border.all(
              width: 1,
              color: Colors.black
            ),
          ),
          duration: Duration(seconds: 1),
          child: Row(
            children: <Widget>[
              TeamCard(game.awayTeam),
              Text(
                game.awayTeamScore.toString(),
                style: TextStyle(fontSize: 28,color: Colors.white),
              ),
              Spacer(),
              Text((game.matchType == MatchType.Final) ? "FINAL" : "Regular", style: TextStyle(color: Colors.white, fontSize: 40),),
              Spacer(),
              Text(
                game.homeTeamScore.toString(),
                style: TextStyle(fontSize: 28,color: Colors.white),
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
          builder: (BuildContext context) => MatchDetails(game),
        ),
      );
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
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Image.network(
                  team.imageUrl,
                  height: MediaQuery.of(context).size.width * 0.20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Colors.transparent,
                      child: Text(
                    team.teamName,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

