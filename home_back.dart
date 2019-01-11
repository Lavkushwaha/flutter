import 'package:flutter/material.dart';
import 'package:home2/auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:home2/splash.dart';

import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _keys = null, _data = null;
  List myRoomSwitch = new List<RoomSwitch>();

  //List<Room> myRooms = new List();

  @override
  void initState() {
    //getUser();
    getData();
  }

//

  Future<Object> getData() async {
    final uid = await Auth().getCurrentUser();

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    ref.child(uid).onChildChanged.listen((event) => _onUpdateAction(event));

    ref.child(uid).once().then((DataSnapshot snap) {
      setState(() {
        _keys = snap.value.keys;
        _data = snap.value;
      });

      for (var key in _keys) {

        RoomSwitch r = new RoomSwitch(key, _data[key]['S1'], _data[key]['S2'],
            _data[key]['S3'], _data[key]['S4']);

        setState(() {
          myRoomSwitch.add(r);
        });
      }
    });
  }

  void _onUpdateAction(event) {
    print('Chnaged Something');
    print(event.snapshot.key);

    var oldValue = myRoomSwitch
        .singleWhere((entry) => entry.roomName == event.snapshot.key);

    setState(() {
      myRoomSwitch[myRoomSwitch.indexOf(oldValue)] = new RoomSwitch(
          event.snapshot.key,
          event.snapshot.value['S1'],
          event.snapshot.value['S2'],
          event.snapshot.value['S3'],
          event.snapshot.value['S4']);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (myRoomSwitch.length > 0) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Home'),
          ),
          body: ListView.builder(
              itemCount: myRoomSwitch.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return new ListTile(

                  title: Text(
                      '${myRoomSwitch[index].roomName} and S2 is ${myRoomSwitch[index].s2} '),
                  leading: Icon(Icons.room_service),
                  onTap: () {
                    toggleSwitch(myRoomSwitch[index].roomName, 'S2',
                        myRoomSwitch[index].s2);
                  },
                );
              }));
    }

    return Splash();

    //return Splash();
  }
}

class RoomSwitch {
  final int s1, s2, s3, s4;

  var roomName;

  RoomSwitch(this.roomName, this.s1, this.s2, this.s3, this.s4);
}

void toggleSwitch(String key, var button, var buttonValue) async {
//print('key is ${key} button is ${button}');

  final uid = await Auth().getCurrentUser();
  var toggledValue = buttonValue == 0 ? 1 : 0;
  DatabaseReference ref = FirebaseDatabase.instance.reference();
  ref.child(uid).child(key).update({button: toggledValue});

//print('${toggledValue} and ${buttonValue}');
}
