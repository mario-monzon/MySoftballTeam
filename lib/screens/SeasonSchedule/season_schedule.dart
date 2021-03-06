import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:my_softball_team/globals.dart' as globals;
import 'package:my_softball_team/screens/SeasonSchedule/edit_game.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:my_softball_team/screens/SeasonSchedule/game_card.dart';

class SeasonSchedule extends StatefulWidget {
  @override
  _SeasonScheduleState createState() => _SeasonScheduleState();
}

class _SeasonScheduleState extends State<SeasonSchedule> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("Teams")
          .document(globals.teamName)
          .collection("Seasons")
          .document(DateTime.now().year.toString())
          .collection("Games")
          .snapshots(),
      builder: (context, snapshot) {

        List<Widget> gameCards = [];

        if(snapshot.hasData) {

          List<DocumentSnapshot> games = snapshot.data.documents;

          games.sort((a, b){
            DateTime game1 = globals.convertStringDateToDateTime(a['GameDate'], a['GameTime']);
            DateTime game2 = globals.convertStringDateToDateTime(b['GameDate'], b['GameTime']);
            return game1.compareTo(game2);
          });

          for(int index = 0; index < games.length; index++) {
            // Check each game date - if the date is in the past, do not display a GameCard
            DateTime gameDate = globals.convertStringDateToDateTime(
              "${games[index]['GameDate']}",
              "${games[index]['GameTime']}",
            );
            DateTime today = new DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              0
            );
            //print(dateToEval);
            if(gameDate.isBefore(today) == true){
              // do not create a GameCard
            } else {
              gameCards.add(
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: GameCard(
                    gameID: games[index].documentID,
                    homeOrAway: "${games[index]['HomeOrAway']}",
                    teamName: globals.teamName,
                    opposingTeam: "${games[index]['OpposingTeam']}",
                    gameTime: "${games[index]['GameTime']}",
                    gameDate: "${games[index]['GameDate']}",
                    gameLocation: "${games[index]['GameLocation']}",
                    isPreviousGame: false,
                  ),
                ),
              );
            }
          }

          return gameCards.length > 0 ? ListView.builder(
            itemCount: gameCards.length,
            itemBuilder: (context, index){
              return gameCards[index];
            },
          ) :
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Text("No games scheduled"),
            ),
          );

        } else {
          return Center(child: Text("Data not found"));
        }
      },
    );
  }
}
