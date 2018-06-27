import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_softball_team/globals.dart' as globals;

class AddNewPlayer extends StatefulWidget {
  @override
  _AddNewPlayerState createState() => new _AddNewPlayerState();
}

class _AddNewPlayerState extends State<AddNewPlayer> {

  // Controllers
  TextEditingController _playerNameController = new TextEditingController();
  TextEditingController _gamesPlayerController = new TextEditingController();
  TextEditingController _atBatsController = new TextEditingController();
  TextEditingController _baseHitsController = new TextEditingController();
  TextEditingController _outsReceivedController = new TextEditingController();
  TextEditingController _assistsController = new TextEditingController();
  TextEditingController _outsFieldedController = new TextEditingController();

  // Variables
  String playerName;
  String position;
  String gamesPlayed;
  String atBats;
  String baseHits;
  String outsReceived;
  String assists;
  String outsFielded;

  // Set field position on DropdownButton tap
  void _chooseFieldPosition(value) {
    setState(() {
      position = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add New Player"),
      ),
      body: new SingleChildScrollView(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Card(
                  elevation: 4.0,
                  child: new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new SizedBox(
                          height: 25.0,
                        ),
                        new TextField(
                          decoration: new InputDecoration(
                            icon: new Icon(Icons.person),
                            labelText: "Player Name",
                          ),
                          controller: _playerNameController,
                        ),
                        new SizedBox(
                          height: 25.0,
                        ),
                        new DropdownButton(
                          items: globals.fieldPositions,
                          onChanged: _chooseFieldPosition,
                          hint: new Text("Choose Field Position"),
                          value: position,
                        ),
                        new SizedBox(
                          height: 15.0,
                        ),
                        new ExpansionTile(
                          title: new Text("Initial Stats (Optional)"),
                          children: <Widget>[
                            new ListTile(
                              title: new Text("Games Played"),
                              subtitle: new SizedBox(
                                width: 75.0,
                                child: new TextField(
                                  keyboardType: TextInputType.number,
                                  controller: _gamesPlayerController,
                                ),
                              ),
                            ),
                            new ListTile(
                              title: new Text("At Bats"),
                              subtitle: new SizedBox(
                                width: 75.0,
                                child: new TextField(
                                  keyboardType: TextInputType.number,
                                  controller: _atBatsController,
                                ),
                              ),
                            ),
                            new ListTile(
                              title: new Text("Base Hits"),
                              subtitle: new SizedBox(
                                width: 75.0,
                                child: new TextField(
                                  keyboardType: TextInputType.number,
                                  controller: _baseHitsController,
                                ),
                              ),
                            ),
                            new ListTile(
                              title: new Text("Outs Received"),
                              subtitle: new SizedBox(
                                width: 75.0,
                                child: new TextField(
                                  keyboardType: TextInputType.number,
                                  controller: _outsReceivedController,
                                ),
                              ),
                            ),
                            new ListTile(
                              title: new Text("Assists"),
                              subtitle: new SizedBox(
                                width: 75.0,
                                child: new TextField(
                                  keyboardType: TextInputType.number,
                                  controller: _assistsController,
                                ),
                              ),
                            ),
                            new ListTile(
                              title: new Text("Outs Fielded"),
                              subtitle: new Padding(
                                padding: const EdgeInsets.only(bottom: 25.0),
                                child: new SizedBox(
                                  width: 75.0,
                                  child: new TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _outsFieldedController,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        new SizedBox(
                          height: 25.0,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new RaisedButton(
                              onPressed: () => Firestore.instance
                                      .runTransaction((transaction) async {
                                    // Get all the text from the fields
                                    playerName = _playerNameController.text;
                                    gamesPlayed = _gamesPlayerController.text;
                                    atBats = _atBatsController.text;
                                    baseHits = _baseHitsController.text;
                                    outsReceived = _outsReceivedController.text;
                                    assists = _assistsController.text;
                                    outsFielded = _outsFieldedController.text;

                                    // Save the player to the database
                                    CollectionReference team = Firestore.instance.collection('Teams').document(globals.teamTame).collection("Players");
                                    CollectionReference stats = Firestore.instance.collection('Teams').document(globals.teamTame).collection("Stats");
                                    team.document(playerName).setData({
                                      "PlayerName": playerName,
                                      "FieldPosition": position,
                                    });
                                    stats.document("Games Played").setData({playerName:gamesPlayed});
                                    stats.document("At Bats").setData({playerName:atBats});
                                    stats.document("Base Hits").setData({playerName:baseHits});
                                    stats.document("Outs Received").setData({playerName:outsReceived});
                                    stats.document("Assists").setData({playerName:assists});
                                    stats.document("Outs Fielded").setData({playerName:outsFielded});
                                    Navigator.pop(context);
                                  }),
                              color: Colors.blue,
                              child: new Text(
                                "Save",
                                style: new TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              splashColor: Colors.lightBlueAccent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
