import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimalDetails extends StatelessWidget {
  const AnimalDetails({super.key, required this.photoUrl, required this.name, required this.temperamento, required this.needs, required this.size, required this.gender, required this.id});

  final String photoUrl;
  final String id;
  final String name;
  final String temperamento;
  final String needs;
  final String size;
  final String gender;

  @override
  Widget build(BuildContext context) {
    var photo = photoUrl;
    if (id.isNotEmpty) {
      photo = "https://firebasestorage.googleapis.com/v0/b/meau-c3971.appspot.com/o/animals%2F$id.jpg?alt=media&token=9805742e-61e5-4230-a621-4e36b8462c00";
    }
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: ListView(
        children: [
          photo.isNotEmpty ? Image(
            image: NetworkImage(photo),
          ) : Container(),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 16,),
          getTextWidget('PORTE', size),
          getTextWidget('GENERO', gender),
          getTextWidget('TEMPERAMENTO', temperamento),
          getTextWidget('o que $name precisa'.toUpperCase(), needs),
        ],
      ),
    );
  }

  Widget getTextWidget(String title, String value) {
    if (value.isEmpty)
      return Container();

    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16,),
          ],
        ),
      ),
    );
  }
}
