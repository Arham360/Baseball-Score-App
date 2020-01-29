
import 'package:flutter/material.dart';
import 'package:sports_score_app/Models/Game.dart';

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
                columnSpacing: 10,
                horizontalMargin: 1,
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
