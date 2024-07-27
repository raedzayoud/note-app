import 'package:flutter/material.dart';

class Cardnote extends StatelessWidget {
  final String titlenote;
  final String contentnote;
  final void Function()?onTap;
  const Cardnote({super.key, required this.titlenote, required this.contentnote, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Expanded(
                child: Transform.scale(
                    scale: 0.9,
                    child: Image.asset(
                      "images/note.jpg",
                      width: 200,
                      height: 150,
                      fit: BoxFit.fill,
                    )),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text("${titlenote}"),
                subtitle: Text("${contentnote}"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
