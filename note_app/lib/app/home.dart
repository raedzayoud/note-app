import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:note_app/app/components/cardnote.dart';
import 'package:note_app/app/components/crud.dart';
import 'package:note_app/app/model/notemodel.dart';
import 'package:note_app/app/notes/edit.dart';
import 'package:note_app/constant/linkapi.dart';
import 'package:note_app/main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Crud c = Crud();

  Future<dynamic> getNotes() async {
    var response = await c.PostRequest(linkview, {
      "id": sharedPreferences.getString("id") ?? "",
    });
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color.fromARGB(255, 104, 189, 108),
        title: Text(
          "Note App",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              sharedPreferences.clear();
              Navigator.of(context).pushReplacementNamed("login");
            },
            icon: Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getNotes(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  if (snapshot.data['status'] == 'success') {
                    List notes = snapshot.data['data'];
                    return ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, i) {
                        return Cardnote(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Edit(
                                  note: snapshot.data['data'][i],
                                ),
                              ));
                            },
                            note: Data.fromJson(notes[i]),
                            onPressed: () async {
                              var response = await c.PostRequest(linkdelete, {
                                "id": notes[i]['notes_id'].toString(),
                                 "imagename":notes[i]['notes_image'].toString()
                              });
                              if (response['status'] == 'success') {
                                Navigator.of(context)
                                    .pushReplacementNamed("home");
                              }
                            });
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        "There are no notes",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: Text("No data available"),
                  );
                }
              },
            ),
          ),
          Container(
            height: 100,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("home");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("Homeprofile");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).pushNamed("addnote");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
