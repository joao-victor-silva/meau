import 'package:cloud_firestore/cloud_firestore.dart';

class Animal {
  String? id;
  String? name;
  AnimalState? state;
  AnimalSpecie? specie;
  AnimalGender? gender;
  AnimalSize? size;
  AnimalAge? age;
  List<AnimalBehavior>? behaviors;
  List<AnimalHealth>? healths;
  List<AnimalSponsorshipRequirement>? sponsorshipRequirements;
  List<AnimalNeed>? needs;
  String? medicines;
  String? objects;
  String? about;
  List<String>? photoUrls;
  String? ownerId;

  Animal({
    this.id,
    this.name,
    this.state,
    this.specie,
    this.gender,
    this.size,
    this.age,
    this.behaviors,
    this.healths,
    this.sponsorshipRequirements,
    this.needs,
    this.medicines,
    this.objects,
    this.about,
    this.photoUrls,
    this.ownerId,
  });

  Animal.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }

    // TODO: update the order enum like the specie and gender
    id = map['id'];
    name = map['name'];
    state = AnimalState.values.byName(map['state']);
    specie = AnimalSpecie.values.byName(map['specie']);
    gender = AnimalGender.values.byName(map['gender']);
    size = AnimalSize.values.byName(map['size']);
    age = AnimalAge.values.byName(map['age']);
    behaviors = (map['behaviors'] as List)?.map((e) => AnimalBehavior.values.byName(e as String))?.toList();
    healths = (map['healths'] as List)?.map((e) => AnimalHealth.values.byName(e as String))?.toList();
    sponsorshipRequirements = (map['sponsorshipRequirements'] as List)?.map((e) => AnimalSponsorshipRequirement.values.byName(e as String))?.toList();
    needs = (map['needs'] as List)?.map((e) => AnimalNeed.values.byName(e as String))?.toList();
    medicines = map['medicines'];
    objects = map['objects'];
    about = map['about'];
    photoUrls = (map['photoUrls'] as List)?.map((item) => item as String)?.toList();
    ownerId = map['ownerId'];
  }

  Animal.fromDocumentSnapshot(DocumentSnapshot? doc) {
    if (doc == null) {
      return;
    }

    var map = doc.data() as Map<String, dynamic>;

    Animal.fromMap(map);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "state": state?.name,
      "specie": specie?.name,
      "gender": gender?.name,
      "size": size?.name,
      "age": age?.name,
      "behaviors": behaviors?.map((e) => e.name),
      "healths": healths?.map((e) => e.name),
      "sponsorshipRequirements": sponsorshipRequirements?.map((e) => e.name),
      "needs": needs?.map((e) => e.name),
      "medicines": medicines,
      "objects": objects,
      "about": about,
      "photoUrls": photoUrls,
      "ownerId": ownerId,
    };
  }
}

enum AnimalState {
  adopted,
  helped,
  sponsored,
  toAdopt,
  toHelp,
  toSponsor,
}

enum AnimalSpecie {
  cat,
  dog,
}

enum AnimalGender {
  female,
  male,
}

enum AnimalSize {
  small,
  medium,
  big,
}

enum AnimalAge {
  young,
  adult,
  old,
}

enum AnimalBehavior { playful, shy, calm, watchful, loving, lazy }

enum AnimalHealth {
  vaccinated,
  dewormed,
  castrated,
  sick,
}

enum AnimalSponsorshipRequirement {
  sponsorshipTerm,
  financialAssistance,
  financialAssistanceFood,
  financialAssistanceHealth,
  financialAssistanceObject,
  visitsToTheAnimal,
}

enum AnimalNeed {
  food,
  financialAssistance,
  medicine,
  object,
}
