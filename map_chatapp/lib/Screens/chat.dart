import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MyChat extends StatefulWidget {
  @override
  _MyChatState createState() => _MyChatState();
}

var authc = FirebaseAuth.instance;

class _MyChatState extends State<MyChat> {
  var msgtextcontroller = TextEditingController();

  var fs = FirebaseFirestore.instance;
  var authc = FirebaseAuth.instance;
  var la1;
  var lo1;
  String chatmsg;
  LocationResult pickedLocation;
  current_location() async {
    Position p =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    la1 = p.latitude;
    lo1 = p.longitude;
    print(p);
    print(la1);
    print(lo1);

    LocationResult result = await showLocationPicker(
      context,
      'AIzaSyA4cnOjUQzIVtu_ToVI3kH7k6yJaI3qAPM',
      initialCenter: LatLng(la1, lo1),
      myLocationButtonEnabled: true,
      layersButtonEnabled: true,
      desiredAccuracy: LocationAccuracy.best,
    );
    print("result = $result");
    setState(() => pickedLocation = result);
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;

    var signInUser = authc.currentUser.email;

    return Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
          backgroundColor: Colors.pink,
          leading: IconButton(
            icon: Icon(Icons.account_circle_sharp),
            onPressed: () {
              current_location();
            },
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app_sharp),
                onPressed: () async {
                  print("sign off");
                  await authc.signOut();
                  Navigator.pushNamed(context, "login");
                }),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  builder: (context, snapshot) {
                    print('new data comes');

                    var msg = snapshot.data.docs;
                    // print(msg);
                    // print(msg[0].data());

                    List<Widget> y = [];
                    for (var d in msg) {
                      // print(d.data()['sender']);
                      var msgText = d.data()['text'];
                      var msgSender = d.data()['sender'];
                      var msgWidget = Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Card(
                          elevation: 10,
                          margin: EdgeInsets.only(top: 15),
                          color: Colors.red.shade100,
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom: 5,
                              right: 20,
                              top: 5,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "$msgSender",
                                  style: TextStyle(fontSize: 8),
                                ),
                                Text(
                                  "$msgText",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                      y.add(msgWidget);
                    }

                    print(y);

                    return Container(
                      width: deviceWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: y,
                      ),
                    );
                  },
                  stream: fs.collection("chat").snapshots(),
                ),
                Center(
                  child: Container(
                    width: deviceWidth,
                    height: 50,
                    child: TextField(
                      controller: msgtextcontroller,
                      onChanged: (value) {
                        chatmsg = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffix: FlatButton(
                          child: Icon(Icons.send_rounded),
                          onPressed: () async {
                            msgtextcontroller.clear();

                            await fs.collection("chat").add({
                              "text": chatmsg,
                              "sender": signInUser,
                            });
                            print(signInUser);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
