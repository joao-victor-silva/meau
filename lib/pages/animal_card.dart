import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meau/model/animal.dart';
import 'package:meau/model/user.dart';
import 'package:meau/pages/animal_details.dart';

class AnimalCard extends StatelessWidget {
  final Animal animal;
  final User owner;

  const AnimalCard({super.key, required this.animal, required this.owner});

  @override
  Widget build(BuildContext context) {
    var photo =
        "https://firebasestorage.googleapis.com/v0/b/meau-c3971.appspot.com/o/animals%2F${animal.id!}.jpg?alt=media&token=9805742e-61e5-4230-a621-4e36b8462c00";
    if (animal.photoUrls != null && animal.photoUrls!.first.isNotEmpty) {
      photo = animal.photoUrls!.first;
    }
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AnimalDetails(
                        animal: animal,
                      )));
        },
        child: Card(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(animal.name ?? ""),
                // IconButton(
                //   icon: const Icon(Icons.favorite_border),
                //   onPressed: () {},
                // )
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: NetworkImage(photo),
                    width: 200,
                  )
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text(animalGenderTranslate(animal.gender)),
                Text(animalSizeTranslate(animal.size)),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                owner.city != null && owner.state != null
                    ? Text('${owner.city!} - ${owner.state!}')
                    : Text('Cidade - Estado'),
              ]),
            ],
          ),
        ));
  }
}
