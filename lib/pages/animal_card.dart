import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meau/pages/animal_details.dart';

class AnimalCard extends StatelessWidget {
  final String id;
  final String name;
  final String photoUrl;
  final String specie;
  final String gender;
  final String size;

  const AnimalCard({
    super.key,
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.specie,
    required this.gender,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    var photo = photoUrl;
    if (id.isNotEmpty) {
      photo =
          "https://firebasestorage.googleapis.com/v0/b/meau-c3971.appspot.com/o/animals%2F$id.jpg?alt=media&token=9805742e-61e5-4230-a621-4e36b8462c00";
    }
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AnimalDetails(
                        id: id,
                        photoUrl: photoUrl,
                        name: name,
                        temperamento: "",
                        needs: "",
                        size: size,
                        gender: gender,
                      )));
        },
        child: Card(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(name),
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                )
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: NetworkImage(id.isNotEmpty ? photo : photoUrl),
                    width: 200,
                  )
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(gender),
                Text(size),
              ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('Cidade - Estado'),
                  ]),
            ],
          ),
        ));
  }
}
