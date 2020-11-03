  
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class Lcmd extends StatefulWidget {
  @override
  _LcmdState createState() => _LcmdState();
}

class _LcmdState extends State<Lcmd> {
  var data;
  var cmd;
  var useremail;
  var fieldclear =
      TextEditingController(); //to clear the text field when the cmd is sent
  var firebaseconnect =
      FirebaseFirestore.instance; //initialize firestore services
  var authentication =
      FirebaseAuth.instance; //initialize authentication services

  /*launchurl() async {
    const url =
        "https://console.firebase.google.com/u/1/project/t3linuxintegration/firestore/data~2FConsoleData~2FwclEhiSuQJSZCQODdgNi";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'error setting up connection ${url}';
    }
  }*/

  firebasedata(cmd) async {
     useremail = authentication.currentUser.email;
     firebaseconnect = FirebaseFirestore.instance;
    var url = "http://192.168.43.55/cgi-bin/web.py?x=${cmd}";
    var response = await http.get(url);

    setState(() {
      data = response.body;
    });

    print(data);
    
      firebaseconnect.collection("students").add({
       
      "name": useremail, //add the username in firestore database
      'command': "${data}" //add command and its output in the database
    });

  // onPressed: ()
  //             {
  //                fconnect.collection("students").add({
  //                  "name" : "pras",
  //                  'email': "pras@p.com",
  //                  'title': "ok oka",
  //                });
   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(' Terminal'),
          backgroundColor: Colors.black,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.laptop_windows), onPressed: (){print('helo');})
          ],
        ),
        body: Stack(
          children: <Widget>[
            
                
            Container(
              margin: EdgeInsets.fromLTRB(10, 40, 20, 20),
              child: TextField(
                controller: fieldclear,
                onChanged: (value) {
                  cmd = value;
                },
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                // cursorWidth: 4.0,
                cursorColor: Colors.black38,
                decoration: InputDecoration(
                  hintText: 'Enter Command',
                 border:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                 ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(10, 125, 10, 10),
              child: Material(
                color: Colors.black,
                // borderRadius: BorderRadius.circular(25),
                child: MaterialButton(
                  onPressed: () async {
                    firebasedata(cmd);
                    fieldclear.clear();
    //   //                 await firebaseconnect.collection('students').add({
    //   // "name": "prasuk", //add the username in firestore database
    //   // 'command': "hello",//"${data}" //add command and its output in the database
    // });
                    //launchurl();
                  },
                  child: Text(
                    'Run Command',
                    style: TextStyle(
                      fontSize: 10,
                     
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 200, 10, 10),
              //color: Colors.white.withOpacity(0.3),
              color: Colors.white,
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    data ?? " ", //checks the null operator
                    textAlign: TextAlign.center,
                    
                    style:
                     TextStyle(
                       
                     color: Colors.black,
                      fontSize: 20,
                    ),
                
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}