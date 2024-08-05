import 'package:flutter/material.dart';
import 'package:note_app/app/model/notemodel.dart';
import 'package:note_app/constant/linkapi.dart';

class Cardnote extends StatelessWidget {
  final Data note;
  final void Function()? onTap;
  final void Function()? onPressed;

  const Cardnote({
    super.key,
    required this.note,
    this.onTap,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        child: Row(
          children: [
            Container(
              width: 100,
              margin: EdgeInsets.only(right: 2),
              child: Transform.scale(
                scale: 0.8,
                child: Image.network(
                  "$linkImageRoot/${note.notesImage}",
                  width: 140,
                  height: 150,
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onPressed,
                ),
                title: Text(note.notesTitle ?? ''),
                subtitle: Text(note.notesContent ?? ''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
