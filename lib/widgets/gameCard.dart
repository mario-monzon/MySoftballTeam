import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:flutter/material.dart';
import 'package:my_softball_team/globals.dart' as globals;
import 'package:my_softball_team/widgets/editGameModal.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class GameCard extends StatelessWidget{
  String gameID;
  String homeOrAway;
  String teamName;
  String opposingTeam;
  String gameDate;
  String gameTime;
  String gameLocation;
  String fullText;
  bool isPreviousGame;
  TextEditingController ownTeamScoreController = TextEditingController();
  TextEditingController opposingTeamScoreController = TextEditingController();

  GameCard({
    this.gameID,
    this.homeOrAway,
    this.teamName,
    this.opposingTeam,
    this.gameDate,
    this.gameTime,
    this.gameLocation,
    this.isPreviousGame
  });

  @override
  Widget build(BuildContext context) {
    switch (homeOrAway) {
      case "Home":
        fullText = teamName + " VS " + opposingTeam;
        break;
      case "Away":
        fullText = opposingTeam + " VS " + teamName;
        break;
      case "Bye":
        fullText = homeOrAway;
        break;
    }
    return Card(
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 6.0, top: 8.0),
            child: Text(
              fullText,
              style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 6.0),
            child: Text(
                gameTime + " on " + gameDate
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
                gameLocation
            ),
          ),
          // Check if this game is a previous game - if so, do not show the action row
          (isPreviousGame == false) ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.delete_outline),
                tooltip: "Delete game",
                onPressed: () {
                  globals.selectedGameDocument = gameID;
                  showDialog(
                  context: context,
                  builder: (_) =>
                    SimpleDialog(
                      title: Text("Delete Game"),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ListTile(
                            title: Text(
                                "Are you sure you want to remove this game from the schedule?"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                child: Text("No"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text("Yes"),
                                onPressed: () {
                                  globals.gamesDB.document(
                                      globals.selectedGameDocument)
                                      .delete();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(GroovinMaterialIcons.edit_outline),
                tooltip: "Edit game details",
                onPressed: () {
                  globals.selectedGameDocument = gameID;
                  Navigator.of(context).push(new MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return new EditGameModal();
                      },
                      fullscreenDialog: true
                  ));
                },
              ),
              IconButton(
                icon: Icon(OMIcons.email),
                tooltip: "Send game reminder",
                onPressed: () {
                  globals.selectedGameDocument = gameID;
                  Navigator.of(context).pushNamed(
                      '/SendGameReminderEmailScreen');
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(GroovinMaterialIcons.trophy_variant_outline),
                  tooltip: "Record score",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) =>
                        SimpleDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Record Score")
                            ],
                          ),
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 24.0),
                                      child: Text(teamName),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 24.0),
                                      child: SizedBox(
                                        width: 25.0,
                                        child: TextField(
                                          controller: ownTeamScoreController,
                                          keyboardType: TextInputType.number,
                                          maxLength: 3,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 24.0),
                                      child: Text(opposingTeam),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 24.0),
                                      child: SizedBox(
                                        width: 25.0,
                                        child: TextField(
                                          controller: opposingTeamScoreController,
                                          keyboardType: TextInputType.number,
                                          maxLength: 3,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FlatButton(
                                      child: Text("Save", style: TextStyle(color: Colors.indigo),),
                                      onPressed: () {
                                        int ownScore = int.parse(ownTeamScoreController.text);
                                        int opposingScore = int.parse(opposingTeamScoreController.text);
                                        String winOrLoss;
                                        if(ownScore > opposingScore){
                                          winOrLoss = "Win";
                                        } else {
                                          winOrLoss = "Loss";
                                        }
                                        if(ownScore == opposingScore){
                                          winOrLoss = "Unknown"; //TODO figure something out with this
                                        }
                                        globals.gamesDB.document(gameID).updateData({
                                          "WinOrLoss":winOrLoss
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                    );
                  },
                ),
              ),
            ],
          ) : Container(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
          ),
        ],
      ),
    );
  }
}
