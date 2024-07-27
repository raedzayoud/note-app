import 'package:flutter/material.dart';
import 'package:note_app/app/components/cardnote.dart';
import 'package:note_app/app/components/crud.dart';
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
    print(sharedPreferences.getString("id"));
    var response = await c.PostRequest(linkview, {
      "id": sharedPreferences.getString("id") ?? "",
    });
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Home",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: getNotes(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading ... "),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data['status'] == 'success') {
              List notes = snapshot.data['data'];
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, i) {
                  return Cardnote(
                    titlenote: notes[i]['notes_title'],
                    contentnote: notes[i]['notes_content'],
                  );
                },
              );
            } else {
              return Center(
                child: Text("Failed to load notes"),
              );
            }
          } else {
            return Center(
              child: Text("No data available"),
            );
          }
        },
      ),
    );
  }
}
