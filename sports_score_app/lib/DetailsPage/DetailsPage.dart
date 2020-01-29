import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sports_score_app/Models/Game.dart';
import 'package:sports_score_app/Models/Team.dart';
import 'package:sports_score_app/Models/TeamStats.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.game.away.team.teamName} @ ${widget.game.home.team.teamName}",
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
            ScoreSwitcher(widget.game)
          ],
        ),
      ),
    );
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
    return Center(
      child: Column(
        children: <Widget>[
          Text("Hitting"),

          //data table for hitters

          SizedBox(
            height: 100,
          ),

          Text("Pitching"),

          // data table for pitchers
        ],
      ),
    );
  }
}
