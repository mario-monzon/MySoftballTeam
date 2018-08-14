import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:my_softball_team/globals.dart' as globals;
import 'package:my_softball_team/widgets/editStatsModal.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';

class TeamList extends StatefulWidget {
  @override
  _TeamListState createState() => _TeamListState();
}

CollectionReference teamCollection = Firestore.instance.collection("Teams").document(globals.teamName).collection("Players");


class _TeamListState extends State<TeamList> {

  var position;

// Set field position on DropdownButton tap
  void _changeFieldPosition(value) {
    setState(() {
      position = value;
      teamCollection.document(globals.selectedPlayerName).updateData({"FieldPosition":position});
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: teamCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData == true) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.documents[index];
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      child: Text("${ds['PlayerName']}"[0]),
                    ),
                    title: Text("${ds['PlayerName']}"),
                    subtitle: Text("${ds['FieldPosition']}"),
                    trailing: SizedBox(
                      width: 150.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.insert_chart),
                            onPressed: (){
                              globals.selectedPlayerName = "${ds['PlayerName']}";
                              Navigator.of(context).push(MaterialPageRoute<Null>(
                                  builder: (BuildContext context) {
                                    return EditStatsModal();
                                  },
                                  fullscreenDialog: true
                              ));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.location_on),
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (_) => SimpleDialog(
                                  title: Text("Change Field Position"),
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        ListTile(
                                          leading: Icon(Icons.location_on),
                                          title: DropdownButton(
                                            items: globals.fieldPositions,
                                            onChanged: _changeFieldPosition,
                                            hint: Text("${ds['FieldPosition']}"),
                                            value: position),
                                          trailing: SizedBox(width: 25.0),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_forever),
                            onPressed: () => Firestore.instance.runTransaction((transaction) async {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text("Remove ${ds['PlayerName']} from your team?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: Text("No"),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        // Delete player from database
                                        teamCollection.document(globals.selectedPlayerName).delete();
                                        Navigator.pop(context);
                                      },
                                      child: Text("Yes"),
                                    ),
                                  ],
                                ),
                              );

                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 1.0, color: Colors.black26,)
                ],
              );
            });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

