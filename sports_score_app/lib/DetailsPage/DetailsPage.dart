import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sports_score_app/Models/Game.dart';
import 'package:sports_score_app/Models/Team.dart';
import 'package:sports_score_app/Models/TeamStats.dart';

import '../GameManager.dart';
import '../main.dart';

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
    initializeGameManager();

    column.add(
      DataColumn(
        label: Text(""),
      ),
    );
    for (int i = 1; i < 10; i++) {
      column.add(
        DataColumn(
          label: Text(
            i.toString(),
          ),
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

    home.add(
      DataCell(
        Text(widget.game.home.team.teamName),
      ),
    );
    home.addAll(
      widget.game.home.innings
          .map(
            (val) => DataCell(
              Text(
                val.toString(),
              ),
            ),
          )
          .toList(),
    );
    home.addAll(
      widget.game.home.runsHitsErrors
          .map(
            (val) => DataCell(
              Text(
                val.toString(),
              ),
            ),
          )
          .toList(),
    );

    away.add(
      DataCell(
        Text(widget.game.away.team.teamName),
      ),
    );
    away.addAll(
      widget.game.away.innings
          .map(
            (val) => DataCell(
              Text(
                val.toString(),
              ),
            ),
          )
          .toList(),
    );
    away.addAll(
      widget.game.away.runsHitsErrors
          .map(
            (val) => DataCell(
              Text(
                val.toString(),
              ),
            ),
          )
          .toList(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameManager>(
        builder: (context, child, model) => Scaffold(
              appBar: AppBar(
                title: Text(
                  "${model.game.away.team.teamName} @ ${model.game.home.team.teamName}",
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              ),
              body: (model.isLoading) ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    MatchCard(
                      game: model.game,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10,
                        horizontalMargin: 1,
                        columns: column,
                        rows: [DataRow(cells: home), DataRow(cells: away)],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    ScoreSwitcher(model.game)
                  ],
                ),
              ),
            ));
  }

  void initializeGameManager() {
     ScopedModel.of<GameManager>(context).init(widget.game);
  }
}

class ScoreSwitcher extends StatefulWidget {
  Game game;

  ScoreSwitcher(this.game);

  @override
  _ScoreSwitcherState createState() => _ScoreSwitcherState();
}

class _ScoreSwitcherState extends State<ScoreSwitcher> {
  int _selectedIndexValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //segmented controller? can it get the shape they want?

        CupertinoSegmentedControl(
          padding: EdgeInsets.symmetric(horizontal: 40),
          selectedColor: Colors.black,
          unselectedColor: Colors.white,
          children: {
            0: Text("AWAY"),
            1: Text("HOME"),
          },
          groupValue: _selectedIndexValue,
          onValueChanged: (value) {
            setState(() => _selectedIndexValue = value);
          },
        ),

        _selectedIndexValue == 0
            ? ScoreTable(widget.game.home)
            : ScoreTable(widget.game.away)

        //OR

        //row with 2 buttons?
        //2 animated switcher that has 2 data tables
      ],
    );
  }
}

class ScoreTable extends StatelessWidget {
  TeamStats teamStats;

  ScoreTable(this.teamStats);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            "Hitting",
            style: TextStyle(fontSize: 30),
          ),
        ),

        Container(
          color: Colors.black,
          height: 1,
          width: MediaQuery.of(context).size.width * 0.9,
        ),

        //data table for hitters
        (teamStats.hitters.length != 0) ? HittersTable(teamStats.hitters) : CircularProgressIndicator(),

        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            "Pitching",
            style: TextStyle(fontSize: 30),
          ),
        ),

        Container(
          color: Colors.black,
          height: 1,
          width: MediaQuery.of(context).size.width * 0.9,
        ),

        // data table for pitchers
        Text(teamStats.hitters.toString()),
        Text(teamStats.pitchers.toString()),
      ],
    );
  }
}

class HittersTable extends StatefulWidget {
  List<Player> hitters;

  HittersTable(this.hitters);

  @override
  _HittersTableState createState() => _HittersTableState();
}

class _HittersTableState extends State<HittersTable> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(
          label: Text("HITTERS"),
        ),
        DataColumn(
          label: Text("AB"),
        ),
        DataColumn(
          label: Text("R"),
        ),
        DataColumn(
          label: Text("H"),
        ),
        DataColumn(
          label: Text("RBI"),
        ),
      ],
      rows: widget.hitters.map(
        (val) => DataRow(
          cells: [
            DataCell(Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: FadeInImage.assetNetwork(
                      placeholder: "assets/loader.png",
                      image:
                          "https://content.mlb.com/images/headshots/current/60x60/${val.id}@3x.png"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "https://content.mlb.com/images/headshots/current/60x60/605200@3x.png"),
                )
              ],
            )),
            DataCell(Text(val.ab.toString())),
            DataCell(Text(val.runs.toString())),
            DataCell(Text(val.hits.toString())),
            DataCell(Text(val.rbi.toString())),
          ],
        ),
      ).toList(),
    );
  }
}
