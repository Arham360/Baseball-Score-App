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
                Text(team.teamName)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MatchDetails extends StatefulWidget {
  Game game;

  MatchDetails(this.game);

  @override
  _MatchDetailsState createState() => _MatchDetailsState();
}

class _MatchDetailsState extends State<MatchDetails> {
  List<DataColumn> column = [];

  List<DataCell> home = [];
  List<DataCell> away = [];

  @override
  void initState() {
    column.add(
      DataColumn(
        label: Text(""),
      ),
    );
    for (int i = 1; i < 10; i++) {
      column.add(
        DataColumn(
          label: Text(i.toString()),
        ),
      );
    }
    column.add(
      DataColumn(
        label: Text("R"),
      ),
    );
    column.add(
      DataColumn(
        label: Text("H"),
      ),
    );
    column.add(
      DataColumn(
        label: Text("E"),
      ),
    );

    home.add(DataCell(Text(widget.game.homeTeam.teamName)));
    home.addAll(widget.game.homeInnings
        .map(
          (val) => DataCell(
            Text(
              val.toString(),
            ),
          ),
        )
        .toList());
    home.addAll(widget.game.homeStats
        .map(
          (val) => DataCell(
            Text(
              val.toString(),
            ),
          ),
        )
        .toList());

    away.add(DataCell(Text(widget.game.awayTeam.teamName)));
    away.addAll(widget.game.awayInnings
        .map(
          (val) => DataCell(
            Text(
              val.toString(),
            ),
          ),
        )
        .toList());
    away.addAll(widget.game.awayStats
        .map(
          (val) => DataCell(
            Text(
              val.toString(),
            ),
          ),
        )
        .toList());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.game.awayTeam.teamName} @ ${widget.game.homeTeam.teamName}",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MatchCard(
              game: widget.game,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: column,
                rows: [DataRow(cells: home), DataRow(cells: away)],
              ),
            )
          ],
        ),
      ),
    );
  }
}
